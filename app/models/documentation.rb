class Documentation < ActiveRecord::Base
  
has_many :linkdocumentationdocs, :dependent => :destroy 

validates_presence_of :title, :author, :year, :source, :last_update, :note, :project_id
end
