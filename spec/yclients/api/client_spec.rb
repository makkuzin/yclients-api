RSpec.describe Yclients::Api::Client do
  let(:client) do
    Yclients::Api::Client.new partner_token: CLIENT_CREDENTIALS[:partner_token],
      user_token: CLIENT_CREDENTIALS[:user_token],
      login: CLIENT_CREDENTIALS[:login],
      password: CLIENT_CREDENTIALS[:password]
  end

  describe '.new' do
    it 'must have partner token' do
      expect{ Yclients::Api::Client.new }.to raise_exception(Yclients::Api::NoPartnerToken)
    end
  end

  describe '#has_user_token?' do
    it 'yes' do
      expect(client.has_user_token?).to be_truthy
    end

    it 'no' do
      client.user_token = nil
      expect(client.has_user_token?).to be_falsey
    end
  end

  describe "#query_param" do
    context 'numeric value' do
      it 'correct params' do
        expect(client.query_param(:group_id, 83, :numeric)).to eq({ group_id: 83 })
      end
      it 'value == 0' do
        expect(client.query_param(:group_id, 0, :numeric)).to eq({})
      end
      it 'incorrect value' do
        expect(client.query_param(:group_id, false, :numeric)).to eq({})
      end
    end

    context 'boolean value' do
      it 'value == true' do
        expect(client.query_param(:active, true, :boolean)).to eq({ active: 1 })
      end
      it 'value == false' do
        expect(client.query_param(:active, false, :boolean)).to eq({ active: 0 })
      end
      it 'incorrect value' do
        expect(client.query_param(:active, 1, :boolean)).to eq({})
      end
    end

    context 'string value' do
      it 'correct params' do
        expect(client.query_param(:title, 'title', :string)).to eq({ title: 'title' })
      end
      it 'value is empty' do
        expect(client.query_param(:title, '', :string)).to eq({})
      end
      it 'incorrect value' do
        expect(client.query_param(:title, false, :string)).to eq({})
      end
    end

    it 'undefined type' do
      expect(client.query_param(:key, 'value', 'undefined')).to eq({})
    end
  end

  describe '#auth', :vcr do
    it 'reject POST request when user token is set' do
      client.user_token = 'user_token'
      expect(client.auth).to eq('user_token')
      expect(client.user_token).to eq('user_token')
    end
  end

  describe '#auth!', :vcr do
    it 'send POST request when user token is set' do
      client.user_token = 'user_token'
      expect(client.auth!).to eq(CLIENT_CREDENTIALS[:user_token])
      expect(client.user_token).to eq(CLIENT_CREDENTIALS[:user_token])
    end

    context 'raise exception' do
      it 'when partner token is wrong' do
        client.partner_token = 'wrong_token_value'
        expect { client.auth! }.to raise_exception(Yclients::Api::AuthError)
      end

      it 'when login is empty' do
        client.login = nil
        expect { client.auth! }.to raise_exception(Yclients::Api::AuthError)
      end

      it 'when password is empty' do
        client.password = nil
        expect { client.auth! }.to raise_exception(Yclients::Api::AuthError)
      end

      it 'when login and password are incorrect' do
        client.login = 'wrong_login'
        client.password = 'wrong_password'
        expect { client.auth! }.to raise_exception(Yclients::Api::AuthError)
      end
    end
  end

  describe '#companies', :vcr do
    it 'user_token is not required' do
      client.user_token = nil
      result = client.companies
      expect(result.class).to eq(Array)
      expect(result.first.class).to eq(Hash)
    end

    it 'user_token is required with `my` param' do
      client.user_token = nil
      expect { client.companies(my: true) }.to raise_exception(Yclients::Api::AuthError)
    end

    it 'search by title' do
      result = client.companies title: 'clinik'
      expect(result.size > 0).to be_truthy
      expect(result.select { |c| c['title'].match(/clinik/i) }).to eq(result)
    end
  end
end
