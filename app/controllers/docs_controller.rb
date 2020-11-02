class DocsController < ApplicationController
 before_filter :authorize
 
 def see_full_doc
   @doc = Doc.find(params[:id])
 end

 def create
   @doc = Doc.new(params[:doc])
   table = params[:table].constantize
   @doc.title = @doc.avatar_file_name.match(/.*(?=\..+$)/)[0].gsub("_"," ") # remove .extension and then replace _ by whitespace
   if @doc.save
     what_on_collection(table,'add',@doc)        
     flash[:notice] = 'Doc was successfully created.'
     redirect_to(:action => "step2_confirmsize", :id =>@doc, :table => table)
   else
     flash[:notice] = 'File could not be uploaded or picture identified. Contact the administrator.'
     @table = table
     render "step1_file"       
   end
 end
 
 def update
   table = params[:table].constantize
   @doc = Doc.find(params[:id])
   
   @doc.protref_id = params[:protref][:id]
   
   respond_to do |format|
     if @doc.update_attributes(params[:doc])
       flash[:notice] = 'Doc was successfully updated.'
       what_on_collection(table,'update',@doc)
       format.html { redirect_to(:controller => "docs", :action => "edit_frame_picture", :table => table)}
     else
       format.html { render :action => "step2_legend", :table => table }
     end
   end
 end

 def destroy
   table = params[:table].constantize
   @doc = Doc.find(params[:id])
   what_on_collection(params[:table].constantize,'del',@doc)
   @doc.destroy
   if params[:p1] then redirect_to :action => "step1_file", :table => table else redirect_to :action => "edit_frame_picture", :table => table end
 end
  
 def step1_file
   @doc= Doc.new
   @table = params[:table]
 end

 def step2_confirmsize
    @doc= Doc.find(params[:id])
    @table = params[:table]
 end
 
 def step3_legend
  @doc = Doc.find(params[:id])
  protref=Protref.find(:all, :conditions => ["title like ? and user_id = ? ", "Gels%", session[:user_id] ])
  @table2 = protref.collect{ |p| [p.title, p.id]}
  if not @doc.protref == nil  then @protref = @doc.protref end
  @table = params[:table]  
end

def reupload
  redirect_to :action => "destroy", :id => params[:id], :p1 => "reupload", :table => params[:table]
end

def vide
@doc = Doc.find(params[:id])
render(:layout => false)
end

def detailwhenselecting
   @protref = Protref.find( params[:id] )
   @readonly=true
   render(:layout => false)
rescue
  render(:action => "vide",:layout => false)
  
end


 def edit_from_exp
   table = params[:table].constantize
   @iframe=true #pour layout
   @collection = find_collection(table)
   @items = @collection.items
   @table=table
   render "edit_frame_picture"
 end
  
 def edit_frame_picture
    table = params[:table].constantize
    @iframe=true #pour layout
    @collection = find_collection(table)
    @collection.type(table)
    @collection.readbd(params[:id]) #Remplit la collection en interrogeant la BD
    @items = @collection.items.uniq # remove duplicates but there are duplicates in session, not elegant
    @table=table
    
    if table == Linkexpdoc
      @collection_protref = find_collection(Linkexpprotref)
      @collection_protref.type(Linkexpprotref)
      @collection_protref.readbd([params[:id]])
    
    end
  end          


 def detail_frame_picture
    table = params[:table].constantize #Linkblablabla
    if table == Linkprotrefdoc 
      @items = table.find(:all, :conditions => {:protref_id => [params[:id]]}, :limit => 20)
    elsif table == Linkdocumentationdoc
      @items = table.find(:all, :conditions => {:documentation_id => [params[:id]]}, :limit => 20)
    elsif table == Linkexpdoc
      @items = table.find(:all, :conditions => {:experiment_id => [params[:id]]}, :limit => 20)  
    end
   #layout
    @iframe=true  
 end     

 def new_frame_picture
    @iframe= true
    @table=params[:table].constantize
    @collection = find_collection(@table)
    @collection.type(@table)
    @items = @collection.items
  end

private
 def what_on_collection (table,task,doc)
   @collection = find_collection(table)
   if task=='add'
     @collection.add_picture(doc) 
   elsif task=='del'  
     @collection.del_doc(doc)
   elsif task=='update'
     @collection.update_doc(doc)
   end
 end

end

