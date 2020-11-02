class Protref < ActiveRecord::Base
has_many :linkexpprotrefs
has_many :linkprotrefdocs, :dependent => :destroy 
has_many :docs
validates_presence_of :title, :protocole

end
