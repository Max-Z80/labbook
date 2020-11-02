class CreateTypexps < ActiveRecord::Migration
  def self.up
    create_table :typexps do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :typexps
  end
end
