class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.references :event_organizer, null: false, foreign_key: true
      t.string :name,         null: false
      t.text :description
      t.datetime :start_time, null: false
      t.datetime :end_time,   null: false
      t.integer :duration
      t.string :venue,        null: false

      t.timestamps
    end
  end
end
