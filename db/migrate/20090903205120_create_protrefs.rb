class CreateProtrefs < ActiveRecord::Migration
  def self.up
    create_table :protrefs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :protrefs
  end
end
