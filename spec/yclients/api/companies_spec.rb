RSpec.describe Yclients::Api::Companies, :vcr do
  let(:client) do
    Yclients::Api::Client.new partner_token: CLIENT_CREDENTIALS[:partner_token],
      user_token: CLIENT_CREDENTIALS[:user_token],
      login: CLIENT_CREDENTIALS[:login],
      password: CLIENT_CREDENTIALS[:password]
  end

  describe '#companies' do
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
