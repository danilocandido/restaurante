require 'rails_helper'

RSpec.describe Item, type: :model do
  subject { Item.new(order: order, product: product) }

  let(:order) { Order.new(table: table) }
  let(:table) { Table.find_or_create_by!(number: 11) }
  let(:product) { Product.find_or_create_by!(name: 'São Geraldo', price: 10.00, category: :bebida) }

  it { is_expected.to be_valid }
end
