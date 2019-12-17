# frozen_string_literal: true

RSpec.describe HelpScout::Object do
  describe '.from' do
    it 'initializes properly' do
      data = {
        id: 1,
        name: 'HelpScout',
        slug: 'fab6de7f13aab712',
        email: 'contact@helpscout.net',
        createdAt: '2019-08-25T13:18:48Z',
        updatedAt: '2019-12-09T21:17:17Z',
        _links: {
          fields: { href: 'https://api.helpscout.net/v2/mailboxes/28798/fields/' },
          folders: { href: 'https://api.helpscout.net/v2/mailboxes/28798/folders/' },
          self: { href: 'https://api.helpscout.net/v2/mailboxes/28798' }
        }
      }

      obj = described_class.from(data)
      expect(obj.id).to eq(data[:id])
      expect(obj.name).to eq(data[:name])
      expect(obj.slug).to eq(data[:slug])
      expect(obj.email).to eq(data[:email])
      expect(obj.created_at).to eq(data[:createdAt])
      expect(obj.updated_at).to eq(data[:updatedAt])
    end
  end
end
