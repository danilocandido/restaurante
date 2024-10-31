class CreateTables < ActiveRecord::Migration[7.2]
  def change
    create_table :tables do |t|
      t.string :number, null: false

      t.timestamps
    end
  end
end
