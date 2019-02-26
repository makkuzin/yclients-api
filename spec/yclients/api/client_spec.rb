RSpec.describe Yclients::Api::Client do
  describe '.new' do
    it 'must have partner token' do
      client = Yclients::Api::Client.new partner_token: 'partner_token'
      expect(client.partner_token).to eq('partner_token')

      expect{ Yclients::Api::Client.new }.to raise_exception(Yclients::Api::NoPartnerToken)
    end
  end

  describe '#has_user_token?' do
    it 'yes' do
      client = Yclients::Api::Client.new partner_token: 'partner_token', user_token: 'user_token'
      expect(client.has_user_token?).to be_truthy
    end

    it 'no' do
      client = Yclients::Api::Client.new partner_token: 'partner_token'
      expect(client.has_user_token?).to be_falsey
    end
  end

  describe '#auth' do
    it 'reject POST request when user token is set' do
      client = Yclients::Api::Client.new partner_token: 'partner_token', user_token: 'user_token',
        login: 'login', password: 'password'

      expect(client.auth).to eq('user_token')
      expect(client.user_token).to eq('user_token')
    end
  end

  describe '#auth!' do
    it 'send POST request when partner token is set' do
      client = Yclients::Api::Client.new partner_token: 'partner_token', user_token: 'user_token',
        login: 'login', password: 'password'

      # TODO  replace
      expect { client.auth! }.to raise_exception(Yclients::Api::AuthError)
      # expect(client.auth!).to eq('new_user_token')
      # expect(client.user_token).to eq('new_user_token')
    end

    context 'raise exception' do
      it 'when partner token is wrong'
      it 'when login is empty'
      it 'when password is empty'
      it 'when login and password are incorrect'
    end
  end

end
