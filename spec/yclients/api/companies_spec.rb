RSpec.describe Yclients::Api::Companies, :vcr do
  let(:client) { Yclients::Api::Client.new CLIENT_CREDENTIALS }

  describe '#companies' do
    it 'user_token is not required' do
      client.user_token = nil
      result = client.companies
      expect(result.class).to eq(Array)
      expect(result.first.class).to eq(Hash)
    end

    it 'get `my` companies' do
      expect(client.companies(my: true).class).to eq(Array)
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
