require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { Product.new(product_attributes) }

  let(:product_attributes) do
    {
      name: 'Feijoada',
      price: 20,
      category: :prato
    }
  end

  it { is_expected.to be_valid }

  describe 'when category enum is wrong' do
    it 'is not valid with a bad category' do
      expect { Product.new(category: :invalid) }
        .to raise_error(ArgumentError)
        .with_message(/is not a valid category/)
    end
  end
end
