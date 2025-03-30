class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.references :event, null: false, foreign_key: true
      t.string :ticket_type, null: false
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0.0
      t.integer :quantity_available, null: false, default: 0

      t.timestamps
    end
  end
end
