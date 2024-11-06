require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { Order.new(table: table) }

  let(:table) { Table.find_or_create_by!(number: 11) }

  it { is_expected.to be_valid }

  context 'when order is created' do
    before do
      allow(OrderPublisher).to receive(:publish).and_return(true)
      allow(ActionCable).to receive_message_chain(:server, :broadcast).and_return(true)
      subject.save!
    end

    describe 'when websocket is added' do
      it { expect(ActionCable).to have_received(:server).at_least(:once) }
    end

    describe 'when queue messaged is added' do
      it { expect(OrderPublisher).to have_received(:publish).at_least(:once) }
    end
  end

  context 'is invalid when order items are empty' do
  end
end
