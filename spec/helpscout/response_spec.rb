# frozen_string_literal: true

RSpec.describe HelpScout::Response do
  let(:list_json) { ResponseLoader.load_json('list_mailboxes') }
  let(:get_json) { ResponseLoader.load_json('get_mailbox') }

  describe '#initialize' do
    context 'list response' do
      let(:response) { double('Response') }

      before { expect(response).to receive(:body).and_return(list_json) }

      it 'is successful' do
        expect(response).to receive(:status).and_return(200)
        resp = described_class.new(response, is_list: true)

        expect(resp).to be_success
        expect(resp.result.count).to eq(2)
        first = resp.result.first
        expect(first.id).to eq(1)
      end

      it 'is unsuccessful' do
        expect(response).to receive(:status).and_return(404)
        resp = described_class.new(response)

        expect(resp).not_to be_success
        expect(resp.result).to be_nil
      end

      it 'handles 201 Created' do
        expect(response).to receive(:status).and_return(201)
        expect(response).to receive(:headers).and_return(
          'resource-id' => '12345'
        )
        resp = described_class.new(response)

        expect(resp).to be_success
        expect(resp.result).not_to be_nil
        expect(resp.result.id).to eq(12_345)
      end

      it 'handles 204 No Content' do
        expect(response).to receive(:status).and_return(204)
        resp = described_class.new(response)

        expect(resp).to be_success
        expect(resp.result).to be_nil
      end
    end
  end

  describe '#success?' do
    let(:response) { double('Response') }

    before do
      expect(response).to receive(:body).and_return(list_json)
      allow(response).to receive(:handle_error)
    end

    it 'returns true for 2xx responses' do
      expect(response).to receive(:status).and_return(200)
      resp = described_class.new(response)

      expect(resp).to be_success
    end

    it 'returns false for 4xx responses' do
      expect(response).to receive(:status).and_return(401)
      resp = described_class.new(response)

      expect(resp).not_to be_success
    end

    it 'returns false for 5xx responses' do
      expect(response).to receive(:status).and_return(500)
      resp = described_class.new(response)

      expect(resp).not_to be_success
    end
  end
end
