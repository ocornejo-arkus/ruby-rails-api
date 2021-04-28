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
      let(:user_data) do
        {
          login: 'jsmith1',
          url: 'http://example.com',
          avatar_url: 'http://example.com/avatar',
          name: 'John Smith',
        }
      end

      subject { post '/login', params: { code: 'valid_code' } }

      it 'should return 201 status code' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'should return proper json body' do
        expect{ subject }.to change{ User.count }.by(1)
        user = User.find_by(login: 'jsmith1')
        token = user_access_token
        pp token.token
        pp token.reload.token
        expect(json_data['attributes']).to eq(
          { 
            'token' => user.access_token.token
          }
        )
      end
    end
  end
end
