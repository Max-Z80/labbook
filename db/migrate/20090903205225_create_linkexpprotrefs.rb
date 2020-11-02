class CreateLinkexpprotrefs < ActiveRecord::Migration
  def self.up
    create_table :linkexpprotrefs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :linkexpprotrefs
  end
end
