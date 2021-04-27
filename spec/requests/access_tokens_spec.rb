require 'rails_helper'

RSpec.describe AccessTokensController do
  describe "#create" do

    shared_examples_for 'unauthorized_requests' do
      let(:error) do
        {
          "status": "401",
          "source": { "pointer": "/code" },
          "title": "Authentication code is invalid",
          "detail": "You must provide valid code in order to exhange it for token.",
        }
      end

      it 'should return 401 status code' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'should return proper error body' do
        subject
        expect(json[:errors]).to eq(error)
      end
    end

    context 'when mo code provided' do
      subject { post '/login' }
      it_behaves_like 'unauthorized_requests'
    end

    context 'when invalid code provided' do
      subject { post '/login', params: { code: 'invalid_code' } }
      it_behaves_like 'unauthorized_requests'
    end

    context 'when success request' do
      
    end
  end
end
