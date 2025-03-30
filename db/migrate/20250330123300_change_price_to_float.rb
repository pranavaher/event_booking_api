class ChangePriceToFloat < ActiveRecord::Migration[7.1]
  def up
    change_column :tickets, :price, :float
    change_column :bookings, :total_price, :float
  end

  def down
    change_column :tickets, :price, :decimal, precision: 10, scale: 2
    change_column :bookings, :total_price, :decimal, precision: 10, scale: 2
  end
end
