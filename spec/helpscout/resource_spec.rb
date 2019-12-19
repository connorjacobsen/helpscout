# frozen_string_literal: true

module Helpscout
  class Foo < Helpscout::Resource
    OBJECT_NAME = 'foo'
  end
end

RSpec.describe Helpscout::Resource do
  let(:resource) { Helpscout::Foo }

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
