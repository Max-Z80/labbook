class CreateLinkprotrefdocs < ActiveRecord::Migration
  def self.up
    create_table :linkprotrefdocs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :linkprotrefdocs
  end
end
