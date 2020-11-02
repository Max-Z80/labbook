class Collection
attr_reader :items

def initialize
  @items =[]
  brandnew = true 
end

def type(type)
  @type = type
end

def type?
  @type
end

def add_picture(doc)  
@items << @type.for_doc(doc)
end

def update_doc(doc)
  if @type == Linkexpprotref
    for line in @items do
      if line.protref == doc
        @items[@items.index(line)]= @type.for_doc(doc)
      end
    end
  else  
    for line in @items do
      if line.doc == doc
        @items[@items.index(line)]= @type.for_doc(doc)
      end
    end
  end
end  

def del_doc(doc)
  if @type == Linkexpprotref
    for line in @items do
      if line.protref == doc
         @items.delete(line)
      end
    end
  else
    for line in @items do
      if line.doc == doc
        @items.delete(line)
      end
    end
  end
end

def empty?
  if @items == []
  return true
  end
end

def empty!
@items = []
@type=nil #effacement
end

def readbd(id)
  if @type == Linkexpdoc
    variable= Linkexpdoc.find(:all, :conditions => {:experiment_id => id}, :limit => 20)
  elsif @type == Linkdocumentationdoc
    variable= Linkdocumentationdoc.find(:all, :conditions => {:documentation_id => id}, :limit => 20)
  elsif @type == Linkexpprotref
    variable= Linkexpprotref.find(:all, :conditions => {:experiment_id => id}, :limit => 20)
  elsif @type == Linkprotrefdoc
    variable= Linkprotrefdoc.find(:all, :conditions => {:protref_id => id}, :limit => 20)    
  end
    @items.concat(variable)
end

end
