RSpec.describe Yclients::Api::Auth, :vcr do
  let(:client) do
    Yclients::Api::Client.new partner_token: CLIENT_CREDENTIALS[:partner_token],
      user_token: CLIENT_CREDENTIALS[:user_token],
      login: CLIENT_CREDENTIALS[:login],
      password: CLIENT_CREDENTIALS[:password]
  end

  describe '#auth' do
    it 'reject POST request when user token is set' do
      client.user_token = 'user_token'
      expect(client.auth).to eq('user_token')
      expect(client.user_token).to eq('user_token')
    end
  end

  describe '#auth!' do
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
