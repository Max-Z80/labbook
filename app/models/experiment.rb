class Experiment < ActiveRecord::Base
  belongs_to :typexp
  has_many :linkexpdocs, :dependent => :destroy
  has_many :linkexpprotrefs, :dependent => :destroy
  
  acts_as_tree :order=>"title"
  
  validates_presence_of :title, :goal, :protocole, :result, :conclusion, :last_update
end
