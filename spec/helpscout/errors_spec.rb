# frozen_string_literal: true

RSpec.describe HelpScout::Errors do
  let(:log_ref) { SecureRandom.uuid }
  let(:message) { 'Bad request' }
  let(:data) do
    [
      {
        path: 'subject',
        message: 'may not be empty',
        source: 'JSON',
        _links: {
          about: {
            href: '...'
          }
        }
      }
    ]
  end

  it 'initializes properly' do
    errors = described_class.new(message, log_ref, data)
    expect(errors.message).to eq(message)
    expect(errors.log_ref).to eq(log_ref)
    expect(errors.errors.size).to eq(1)

    error = errors.errors.first
    expect(error.path).to eq('subject')
    expect(error.message).to eq('may not be empty')
    expect(error.source).to eq('JSON')
  end
end
