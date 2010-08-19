class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :short_links do |t|
      t.integer :user_id
      t.string :hash
      t.string :path
      t.integer :counter, :default => 0
      t.boolean :deleted, :default => false
      
      t.datetime :first_hit_on
      t.datetime :expires_on 

      t.timestamps
    end
  end

  def self.down
    drop_table :short_links
  end
end
