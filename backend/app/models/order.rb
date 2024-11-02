class Order < ApplicationRecord
  enum status: %i[received in_progress finished completed]

  belongs_to :table
  has_many :items

  after_commit :publish!, on: :create

  private

  def publish!
    OrderPublisher.publish('order.received', attributes.slice('id', 'status'))
  end
end
