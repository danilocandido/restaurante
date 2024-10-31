class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.integer :status, null: false, index: true, default: 0
      t.references :table, null: false, foreign_key: true

      t.timestamps
    end
  end
end
