require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET /show' do
    before(:each) do
      @user = FactoryBot.create :user

      get :show, params: { id: @user.id }, format: :json
    end

    it 'returns the informating about a reporter on a hash' do
      user_response = json_response
      expect(user_response[:email]).to eq @user.email
    end

    it { should respond_with :ok }
  end

  describe 'POST #create' do
    context 'when is sucessfully created' do
      before(:each) do
        @user_attributes = FactoryBot.attributes_for :user
        post :create, params: { user: @user_attributes }, format: :json
      end

      it 'renders the json represetation for the user record just created' do
        user_response = json_response 
        expect(user_response[:email]).to eq @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_user_attributes = {
          password: '123456',
          password_confirmation: '123456'
        }

        post :create, params: { user: @invalid_user_attributes }, format: :json
      end

      it 'renders an error json' do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end


      it 'renders the json error on why the user could not be created' do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when is successfully updated' do      
      before(:each) do
        @user = FactoryBot.create(:user)
        patch :update, params: {
          id: @user.id,
          user: { email: 'newemail@test.com' }, format: :json
        }
      end

      it 'renders the json representation for the updated user' do
        user_response = json_response
        expect(user_response[:email]).to eql('newemail@test.com')
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        @user = FactoryBot.create(:user)
        patch :update, params: {
          id: @user.id,
          user: { email: 'bademail.com' }, format: :json
        }
      end

      it 'rendered an errors json' do
        user_response = json_response

        expect(user_response).to have_key(:errors)
      end

      it 'rendered the jsons errors on why the user could not be updated' do
        user_response = json_response

        expect(user_response[:errors][:email]).to include 'is invalid'
      end

      it { should respond_with 422}
    end
  end

  describe 'DELETE #destroy' do 
    before(:each) do
      @user = FactoryBot.create(:user)
      delete :destroy, params: { id: @user.id, format: :json }
    end

    it { should respond_with 204 }
  end
end
