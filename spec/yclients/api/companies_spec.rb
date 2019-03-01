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
      expect { client.companies(my: true) }.to raise_exception(Yclients::Api::CompaniesAccessError)
    end

    it 'search by title' do
      result = client.companies title: 'clinik'
      expect(result.size > 0).to be_truthy
      expect(result.select { |c| c['title'].match(/clinik/i) }).to eq(result)
    end
  end

  describe '#company' do
    let!(:company_id) { client.companies.first['id'] }

    it 'user_token is not required' do
      client.user_token = nil
      expect(client.company(company_id).class).to eq(Hash)
    end

    it 'request company with wrong id' do
      expect { client.company(0) }.to raise_exception(Yclients::Api::CompaniesAccessError)
    end

    it 'get company without params' do
      result = client.company(company_id)
      expect(result['groups']).to be_nil
      expect(result['active_staff_count']).to be_nil
      expect(result['next_slot']).to be_nil
    end

    it 'get company with params' do
      result = client.company(company_id, { for_booking: true, show_groups: true })
      expect(result['groups']).not_to be_nil
      expect(result['active_staff_count']).not_to be_nil
      expect(result['next_slot']).not_to be_nil
    end
  end
end
