require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe 'GET #show' do
    before(:each) do 
      @product = FactoryBot.create(:product)
      get :show, params: { id: @product.id }
    end

    it 'return the information about a reportes on a hash' do 
      product_response = json_response 
      expect(product_response[:title]).to eql @product.title
    end

    it { should respond_with 200 }
  end

  describe 'GET #index' do
    before(:each) do
      FactoryBot.create_list(:product, 5)
      get :index
    end

    it 'returns 5 records from the database' do
      products_response = json_response      
      expect(products_response.count).to eql 5
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do 
        user = FactoryBot.create(:user)
        @product_attributes = FactoryBot.attributes_for(:product) 
        api_authorization_header user.token
        post :create, params: { user_id: user.id, product: @product_attributes }
      end

      it 'renders the json representation for the product record just created' do
        product_response = json_response
        expect(product_response[:title]).to eql @product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context 'when is not created' do 
      before(:each) do 
        user = FactoryBot.create(:user)
        @invalid_product_attributes = { title: 'Smart TV', price: '20 Reais' }
        api_authorization_header user.token
        post :create, params: { user_id: user.id, product: @invalid_product_attributes}
      end

      it 'renders an errors json' do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        product_response = json_response
        expect(product_response[:errors][:price]).to include 'is not a number'
      end

      it { should respond_with 422 }
    end
  end

  describe 'PUT/PATCH #update' do 
    before(:each) do
      @user = FactoryBot.create(:user)
      @product = FactoryBot.create(:product, user: @user)
      api_authorization_header @user.token
    end

    context 'when is successfully updated' do 
      before do 
        patch :update, params: { user_id: @user.id, id: @product.id, product: { title: 'An expensive TV'} }
      end

      it 'renders the json representation for the update user' do 
        product_response = json_response
        expect(product_response[:title]).to eql 'An expensive TV'
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do 
      before do
        patch :update, params:{ user_id: @user.id, id: @product.id, product: {
          price: '123 reais'
        }}
      end

      it 'renders an errors json' do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could no be created' do
        product_response = json_response
        expect(product_response[:errors][:price]).to include 'is not a number'
      end

      it { should respond_with 422 }
    end
  end
  
  describe 'DELETE #destroy' do
    before do
      @user = FactoryBot.create(:user)
      @product = FactoryBot.create(:product, user: @user)
      api_authorization_header @user.token
      delete :destroy, params: { user_id: @user.id, id: @product.id}
    end

    it { should respond_with 204 }
  end
end
