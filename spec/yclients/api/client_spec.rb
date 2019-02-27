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

end
