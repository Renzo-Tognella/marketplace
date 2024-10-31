require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do

  path '/users/{id}' do
    get 'Get user' do
      tags 'Users'
      produces 'application/json'
      parameter name: 'Accept',
                in: :header,
                description: 'Add structure for version',
                required: true,
                type: :string,
                schema: { type: :string }
      parameter name: :id,
                in: :path,
                type: :string
                
      response '200', 'user found' do
        schema type: :object, 
               properties: {
                id: { type: :integer }, 
                email: { type: :string },
                created_at: { type: :string },
                updated_at: { type: :string }
               }
        let!(:id) { FactoryBot.create(:user).id }      
        let!(:Accept) { 'application/vnd.marketplace.v1' }    

        run_test!
      end
    end

  end

  path '/users' do 
    post 'Post user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema:{
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
            }
          }
        }
      }

      response '201', 'create user' do
        let(:user) {}
        let!(:body) do
          FactoryBot.attributes_for(:user)
        end

        run_test!
      end
    end
  end

  path '/users/{id}' do 
    delete 'Deletre user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string

      response '204', 'user deleted' do
        let(:id) { FactoryBot.create(:user).id }

        run_test!
      end

      # response '404', 'user not found' do
      #   let!(:id) { 6 }
        
      #   run_test!
      # end
    end
  end

end
