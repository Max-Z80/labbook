class Linkexpdoc < ActiveRecord::Base
belongs_to :doc
belongs_to :experiment

def self.for_doc(doc)
  item = self.new
  item.doc = doc  #item.doc contient un object doc 
  item
end


end
