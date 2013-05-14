class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :initiator_id
      t.integer :consumer_id
      t.boolean :confirmed

      t.timestamps
    end
  end
end
