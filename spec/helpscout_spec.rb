# frozen_string_literal: true

RSpec.describe Helpscout do
  it 'has a version number' do
    expect(Helpscout::VERSION).not_to be nil
  end

  it 'has a default base_uri' do
    expect(Helpscout.base_uri).to eq(Helpscout::DEFAULT_BASE_URI)
  end

  it 'can set base_uri' do
    new_uri = 'https://api.some-other-uri.com'
    Helpscout.base_uri = new_uri
    expect(Helpscout.base_uri).to eq(new_uri)
  end

  it 'can set a cache' do
    # Nil by default.
    expect(Helpscout.cache).to be_nil

    Helpscout.cache = Helpscout::Cache::RedisCache
    expect(Helpscout.cache).to be(Helpscout::Cache::RedisCache)
  end

  describe '.new_client' do
    it 'creates a new client' do
      described_class.client_id = 'some_id'
      described_class.client_secret = 'some_secret'
      client = described_class.new_client

      expect(client.base_uri).to eq(described_class.base_uri)
      # expect(client.cache).to eq(described_class.cache)
      expect(client.client_id).to eq(described_class.client_id)
      expect(client.client_secret).to eq(described_class.client_secret)
    end
  end
end
