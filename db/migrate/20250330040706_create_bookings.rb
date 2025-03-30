class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ticket, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.decimal :total_price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
