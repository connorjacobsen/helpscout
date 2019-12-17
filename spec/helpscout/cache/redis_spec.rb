# frozen_string_literal: true

RSpec.describe HelpScout::Cache::RedisCache do
  let(:url) { 'redis://localhost:6380' }
  let(:cache) { described_class.new(url: url) }
  let(:redis_client) { double('Redis') }

  before do
    allow(Redis).to receive(:new).and_return(redis_client)
  end

  describe '#initialize' do
    it 'passes options onto redis' do
      opts = { url: url }
      expect(Redis).to receive(:new).with(opts)

      described_class.new(opts)
    end
  end

  describe '#get' do
    it 'delegates to Redis' do
      expect(redis_client).to receive(:get).with('key')

      cache.get('key')
    end
  end

  describe '#set' do
    it 'delegates to Redis' do
      expect(redis_client).to receive(:setex).with('key', 12_345, 'foobar')

      cache.set('key', 12_345, 'foobar')
    end
  end
end
