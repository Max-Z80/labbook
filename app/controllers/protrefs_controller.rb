class ProtrefsController < ApplicationController
layout :test_layout_protref
before_filter :authorize

def add
protref=Protref.find(:all, :conditions => {:user_id => session[:user_id]})
@table = protref.collect{ |p| [p.title, p.id]}
@layout_application = false
end

def new
  @readonly =false
  @protref = Protref.new
  if params[:title_start] : @protref.title ="Gels: " end
  @origine = params[:origin] || "new"
  @layout_application = search_layout(params[:origin] || "new")
end  

def new_from_index
  redirect_to :action => "new", :origin => "new_from_index"
end

def added
  @protref = Protref.find(params[:protref][:id])
  what_on_collection('add',@protref)
  #redirect_to_index('Protocole successfully added.')
  redirect_to :action => "ok"
rescue
  flash[:notice] = "Please, select a protocole"
  redirect_to :action => "add"
end

def create
  @origine = params[:parameter][:origin] #@origine reused in case save fails. values: new or new_from_index
  @protref = Protref.new(params[:protref])
  @protref.user_id = session[:user_id]
  @collection = find_collection(Linkprotrefdoc)
  @protref.linkprotrefdocs = @collection.items
    if @protref.save
      flash[:notice] = 'Reference protocole was successfully created.'
      if @origine =="new"
        what_on_collection('add',@protref)
        redirect_to :action => "ok", :layout => false
      else redirect_to :action => "index" end
    else 
      @readonly =false 
      render :action => @origine  
      end
end

def update
  @protref = Protref.find(params[:id])    
  @protref.user_id = session[:user_id]
  
  @collection = find_collection(Linkprotrefdoc)
  @protref.linkprotrefdocs = @collection.items
  if @protref.update_attributes(params[:protref])
    flash[:notice] = 'Reference protocole was successfully updated.'
    if params[:parameter][:hidden]=="edit"
      then   
      what_on_collection('update',@protref)     
      redirect_to :action => "ok", :layout => false
      else redirect_to :action => "index"  end
    else render :action => params[:parameter][:hidden]  end
end


def detail_from_exp
  @items = Linkexpprotref.find(:all, :conditions => {:experiment_id => [params[:id]]}, :limit => 20)
end

def edit_from_exp
  @collection_protref = find_collection(Linkexpprotref)
  @items = @collection_protref.items.uniq
end

def index
    @collection = find_collection(Linkprotrefdoc)
    @collection.empty!
    @layout_application = true
    @protrefs = Protref.find(:all, :conditions => {:user_id => session[:user_id]})
end

def unlink
  @protref = Protref.find( params[:id] )
  what_on_collection('del',@protref)
  flash[:notice] = "Unlinking successfull"
  redirect_to :action => "edit_from_exp"
end

def detail
   @protref = Protref.find( params[:id] )
   @readonly=true
   @origine = params[:p1] || "detail"
   @layout_application = search_layout(@origine)
 end

def detail_frame_picture
    @items = Linkprotrefdoc.find(:all, :conditions => {:protref_id => [params[:id]]}, :limit => 20) 
    #layout
    @iframe=true
end 

def detail_from_index
  redirect_to :action => "detail", :id => params[:id], :p1 => "detail_from_index"
end

def detailwhenselecting
   @protref = Protref.find( params[:id] )
   @readonly=true
rescue
  flash[:notice] = "Please, select a protocole"
  render :action => "vide"
 end
 
def edit
   @readonly = false    
   @protref = Protref.find(params[:id])
   @origine = params[:p1] || "edit"
   @layout_application = search_layout(@origine)
end

def edit_from_index
redirect_to :action => "edit", :id => params[:id], :p1 => "edit_from_index"
end

 

def ok
  @collection = find_collection(Linkprotrefdoc)
  @collection.empty!
end

def delete
   @iframe=true
   @origine = params[:origin] || "delete"
   @layout_application = search_layout(@origine)
  #creation d'un tableau contenant que les protocoles pouvant etre effacer
  @tableau =[]
  for var in Protref.find(:all, :conditions => {:user_id => session[:user_id]}) do
    if var.linkexpprotrefs == [] && var.docs ==[] then @tableau << var end
  end
end

def delete_from_index
 redirect_to :action => "delete", :origin => "delete_from_index"
end

def destroy
  origin = params[:parameter][:origin]
  @protref = Protref.find(params[:protref][:id])
  # la destruction des linkprotrefdoc associe est automatique par :dependent
    # les doc associes a protref sont detruit seulement si ils ne pointent vers rien d'autre
    tab = @protref.linkprotrefdocs
      for item in tab do
        tab2 = Linkprotrefdoc.find(:all, :conditions => {:doc_id => item.doc_id})
        if tab2.length == 1
          vardoc = Doc.find(item.doc.id)
          # on destroy le doc
          vardoc.destroy  
        end
      end
  @protref.destroy
  flash[:notice] = 'Reference protocole was successfully deleted.'

if params[:parameter][:origin] == "delete" 
  then redirect_to :action => "edit_from_exp"
  else redirect_to :action => "index" end

  rescue
  # we reach this point if the find request fails because the field is not filled
    flash[:notice] = 'Please, select a protocole.'
     redirect_to :action => params[:parameter][:origin]    
  end

private

def what_on_collection (task,doc)
 @collection_protref = find_collection(Linkexpprotref)
 if task=='add'
  @collection_protref.add_picture(doc) 
 elsif task=='del'  
  @collection_protref.del_doc(doc)
 elsif task=='update'
  @collection_protref.update_doc(doc)
 end
end

def search_layout (origine)
  if origine.include? "index": true else false end
end

end
  