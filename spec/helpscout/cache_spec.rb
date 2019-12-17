# frozen_string_literal: true

class CacheImpl < HelpScout::Cache
  public_class_method :new
end

RSpec.describe HelpScout::Cache do
  it 'can not be instantiated' do
    expect {
      described_class.new
    }.to raise_exception(NoMethodError)
  end

  it 'raises exception for set' do
    expect {
      CacheImpl.new.set('foo', 12_345, 'value')
    }.to raise_exception(NotImplementedError)
  end

  it 'raises exception for get' do
    expect {
      CacheImpl.new.get('foo')
    }.to raise_exception(NotImplementedError)
  end
end
