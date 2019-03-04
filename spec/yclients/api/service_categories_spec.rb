RSpec.describe Yclients::Api::ServiceCategories, :vcr do
  let(:client) { Yclients::Api::Client.new CLIENT_CREDENTIALS }
  let!(:company_id) { client.companies.first['id'] }

  describe '#service_categories' do
    it 'user_token is not required' do
      client.user_token = nil
      result = client.service_categories(company_id)
      expect(result.class).to eq(Array)
      expect(result.first.class).to eq(Hash)
    end

    it 'with wrong company_id' do
      expect { client.service_categories(0) }.to raise_exception(
        Yclients::Api::ServiceCategoriesAccessError
      )
    end

    it 'with wrong id' do
      expect { client.service_categories(company_id, id: 99999999999999999999) }.to raise_exception(
        Yclients::Api::ServiceCategoriesAccessError
      )
    end
  end

  describe '#service_category' do
    let!(:id) { client.service_categories(company_id).first['id'] }
    it 'user_token is not required' do
      client.user_token = nil
      result = client.service_category(company_id, id)
      expect(result.class).to eq(Hash)
    end

    it 'with wrong company_id' do
      expect { client.service_category(0, id) }.to raise_exception(
        Yclients::Api::ServiceCategoriesAccessError
      )
    end

    it 'with wrong id' do
      expect { client.service_category(company_id, 0) }.to raise_exception(
        Yclients::Api::ServiceCategoriesAccessError
      )
    end
  end
end
