require 'rails_helper'

RSpec.describe "/orders", type: :request do
  let(:table) { Table.find_or_create_by!(number: 1) }
  let(:peixada) { Product.find_or_create_by!(name: 'Peixada Cearence', price: 100.00, category: :prato) }
  let(:suco) { Product.find_or_create_by!(name: 'Suco de Caju', price: 100.00, category: :bebida) }
  let(:table) { Table.find_or_create_by!(number: 11) }
  let(:valid_attributes) {
    {
      table_id: table.id,
      items: [
        {
          product_id: peixada.id,
          amount: 5
        },
        {
          product_id: suco.id,
          amount: 5
        }
      ]
    }
  }

  before do
    allow(OrderPublisher).to receive(:publish).and_return(true)
    allow(OrderNotifier).to receive(:send).and_return(true)
  end

  before do
    Order.create(table: table)
  end

  describe "GET /index" do
    it "renders a successful response" do
      get orders_url, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Order and new Items" do
        expect {
          post orders_url,
               params: { order: valid_attributes }, as: :json
        }.to change { Order.count }.by(1)
        .and change { Item.count }.by(2)
      end

      it "renders a JSON response with the new order" do
        post orders_url,
             params: { order: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /in_progress" do
    context "with valid parameters" do
      let(:order) { Order.last }

      it "updates the requested order" do
        patch in_progress_order_url(order), as: :json
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "PATCH /finished" do
    context "with valid parameters" do
      let(:order) { Order.last }

      it "updates the requested order" do
        patch finished_order_url(order), as: :json
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
