require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { FactoryBot.build :product}

  subject { product } 

  it { respond_to(:title) }
  it { respond_to(:price) }
  it { respond_to(:description) }
  it { respond_to(:published) }
  it { respond_to(:user_id) }

  describe 'validations' do
    it { should validate_presence_of :title}
    it { should validate_presence_of :price}
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0)}
    it { should validate_presence_of :user_id}
  end

  describe 'associations' do
    it { should belong_to(:user).optional }
  end
end
