class Project < ActiveRecord::Base
  acts_as_tree :order=>"name"
  has_many :experiments
  has_many :documentations
  
  validates_presence_of :name, :user_id
  before_destroy :checkdestroyable
  
def checkdestroyable
  if self.name == "My reference protocols" or self.name =="My experiment templates" : false  end
end
  
end
