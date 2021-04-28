require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe "#create" do

    context 'when mo code provided' do
      subject { post :create }
      it_behaves_like 'unauthorized_requests'
    end

    context 'when invalid code provided' do
      subject { post :create, params: { code: 'invalid_code' } }
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

      subject { post :create, params: { code: 'valid_code' } }

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

  describe 'DELETE #destroy' do
    subject { delete :destroy }
  
    context 'when no authorization header provided' do
      it_behaves_like 'forbidden_requests'
    end

    context 'when invalid authorization header provided' do
      before { @request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_requests'
    end

    context 'when valid request' do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }

      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      it 'should return 204 status code' do
        subject
        expect(response).to have_http_status(:no_content)
      end

      it 'should remove the proper access token' do
        expect{ subject }.to change{ AccessToken.count }.by(-1)
      end
    end
  end
end
