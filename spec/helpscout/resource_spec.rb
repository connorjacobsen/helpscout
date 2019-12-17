# frozen_string_literal: true

module HelpScout
  class Foo < HelpScout::Resource
    OBJECT_NAME = 'foo'
  end
end

RSpec.describe HelpScout::Resource do
  let(:resource) { HelpScout::Foo }

  describe '.class_name' do
    it 'returns the proper class name' do
      expect(resource.class_name).to eq('Foo')
    end
  end

  describe '.resource_url' do
    it 'returns the resource url' do
      expect(resource.resource_url).to eql('/v2/foos')
    end
  end
end
