class RemoveEventOrganizersTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :event_organizers
  end
end
