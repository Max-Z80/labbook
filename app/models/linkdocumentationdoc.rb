class Linkdocumentationdoc < ActiveRecord::Base
belongs_to :doc
   
def self.for_doc(doc)
  item = self.new
  item.doc = doc  #item.doc contient un object doc 
  item
end

end
