class Linkexpprotref < ActiveRecord::Base
belongs_to :experiment
belongs_to :protref

def self.for_doc(doc)
  item = self.new
  item.protref = doc  #item.doc contient un object doc 
  item
end
end
