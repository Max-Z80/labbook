class CreateExperiments < ActiveRecord::Migration
  def self.up
    create_table :experiments do |t|
      t.text :goal
      t.text :protocole
      t.text :result
      t.text :conclusion
      t.text :summary

      t.timestamps
    end
  end

  def self.down
    drop_table :experiments
  end
end
