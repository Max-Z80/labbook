class CreateLinkexpdocs < ActiveRecord::Migration
  def self.up
    create_table :linkexpdocs do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :linkexpdocs
  end
end
