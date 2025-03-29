# frozen_string_literal: true

class DeviseCreateEventOrganizers < ActiveRecord::Migration[7.1]
  def change
    create_table :event_organizers do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Custom fields
      t.string :name, null: false

      t.timestamps null: false
    end

    add_index :event_organizers, :email,                unique: true
    add_index :event_organizers, :reset_password_token, unique: true
    # add_index :event_organizers, :confirmation_token,   unique: true
    # add_index :event_organizers, :unlock_token,         unique: true
  end
end
