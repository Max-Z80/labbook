class Doc < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :medium => ["300x300>",:jpg ], :thumb => ["100x100>", :jpg] }
  has_many :linkexpdocs
  belongs_to :protref  
  validates_presence_of :title
end
