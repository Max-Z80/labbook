class DocumentationsController < ApplicationController
  layout :test_iframe
  before_filter :authorize
 
def detail_frame_form
    @readonly =true
    @project = Project.find(find_project[0])
    @documentation = Documentation.find(params[:id])
    @origine = "detail"
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @experiment }
    end
end
   

  def edit_frame_form
    @readonly =false
    @project = Project.find(find_project[0])
    @documentation = Documentation.find(params[:id])
      respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @experiment }
      end
  end
                
  def index
    @project = Project.find(find_project[0])
    @documentations = Documentation.find(:all, :conditions => "project_id = " + @project.id.to_s )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documentations }
    end
  rescue
  logger.error("Attempt to display the list of experimenst without defined project")
  flash[:notice] = 'Select a project'
  redirect_to(:controller =>"projects", :action => 'index')
  end

  # GET /documentations/new
  # GET /documentations/new.xml
  def new_frame_form
    @readonly =false
    @project = Project.find(find_project[0])
    @documentation = Documentation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @documentation }
    end
  end


  def create
    @documentation = Documentation.new(params[:documentation])
    @documentation.last_update = get_date
    @documentation.project_id = find_project[0]
    @project = Project.find(find_project[0]) #utile en cas de echec sauvegarde
    @collection = find_collection(Linkdocumentationdoc)
    @documentation.linkdocumentationdocs << @collection.items
    respond_to do |format|
      if @documentation.save
        format.html { redirect_to_index('Documentation was successfully created.')}
        format.xml  { render :xml => @documentation, :status => :created, :location => @documentation }
      else
        format.html { render :action => "new_frame_form" }
        format.xml  { render :xml => @documentation.errors, :status => :unprocessable_entity }
      end
    end
  end
  

  def update
    @documentation = Documentation.find(params[:id])
    @documentation.last_update = get_date
    
    #Collection of docs
    @collection = find_collection(Linkdocumentationdoc)
    @documentation.linkdocumentationdocs = @collection.items
    @project = Project.find(find_project[0]) #utile en cas de echec sauvegarde
    
    respond_to do |format|
      if @documentation.update_attributes(params[:documentation])
        format.html { redirect_to_index('Documentation was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit_frame_form" }
        format.xml  { render :xml => @documentation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /experiments/1
  # DELETE /experiments/1.xml
  def destroy
    documentation = Documentation.find(params[:id])
    # la destruction des linkdocumentationdoc associe est automatique par :dependent
    # les doc associes a la documentation sont detruit seulement si ils ne pointent vers rien d'autre
    tab = documentation.linkdocumentationdocs
      for item in tab do
        tab2 = Linkdocumentationdoc.find(:all, :conditions => {:doc_id => item.doc_id})
        if tab2.length == 1
          vardoc = Doc.find(item.doc.id)
          # on destroy le doc
          vardoc.destroy  
        end
      end
    documentation.destroy

    respond_to do |format|
      format.html { redirect_to_index }
      format.xml  { head :ok }
    end
  end

def redirect_to_index(msg = nil)
@collection = find_collection(Linkdocumentationdoc)
@collection.empty!
flash[:notice] = msg if msg
redirect_to :action => 'index'
end

def select_documentation
@project = Project.find(find_project[0])
documentation=Documentation.find(:all, :conditions => {:project_id => @project})
@table = documentation.collect{ |p| [p.title, p.id]}
end

def selected
    var = params[:documentation][:id]
  if (var=="") or (var=="0")
    @project = Project.find(find_project[0])
    flash[:notice] = 'Error: Select a template'
    redirect_to :action => 'select_documentation'
  else
  @documentation = Documentation.find(params[:documentation][:id])
  @project = Project.find(find_project[0])
  @origine = "popup"
  @readonly =true
  render :action => 'detail_frame_form'
  end  
end

def print
 @project = Project.find(find_project[0])
 @documentation = Documentation.find(params[:id])
 @items = Linkdocumentationdoc.find(:all, :conditions => {:documentation_id => [params[:id]]}, :limit => 20)
 render(:layout => false, :popup => true)
end

end

