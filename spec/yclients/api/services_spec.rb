RSpec.describe Yclients::Api::Services, :vcr do
  let(:client) { Yclients::Api::Client.new CLIENT_CREDENTIALS }
  let!(:company_id) { client.companies.first['id'] }

  describe '#services' do
    it 'user_token is not required' do
      client.user_token = nil
      result = client.services(company_id)
      expect(result.class).to eq(Array)
      expect(result.first.class).to eq(Hash)
    end

    it 'with wrong company_id' do
      expect { client.services(0) }.to raise_exception(
        Yclients::Api::ServicesAccessError
      )
    end

    it 'with wrong service_id' do
      expect { client.services(company_id, service_id: 99999999999999999999) }.to raise_exception(
        Yclients::Api::ServicesAccessError
      )
    end
  end
end
