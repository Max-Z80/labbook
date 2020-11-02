class ExperimentsController < ApplicationController
  layout :test_iframe
  before_filter :checkexpid , :only => [ :edit_frame_form, :detail_frame_form, :edit_frame_picture, :detail_frame_picture,:print ]
  before_filter :authorize
  
  def checkexpid
    @project = Project.find(find_project[0])
    if not params[:id] == nil
      experiment = Experiment.find(:all, :conditions => {:id => params[:id], :project_id => @project})
    else
      experiment = ["nothing"]
    end
    
    if experiment == [] 
    flash[:notice] = "Access denied. Your are not the author."
    redirect_to :action => "index"  
    end
  end
  
  def from_project_to_index
    var = find_project
    var[0] = params[:id]
    if Project.find(params[:id]).name == "My reference protocols"
      then redirect_to :controller => "protrefs", :action => "index"
      else redirect_to :action => "redirect_to_index"   
    end
  end
  
  def index
    @project = Project.find(find_project[0])
    @experiments = Experiment.find(:all, :conditions => "project_id = " + @project.id.to_s )

    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @experiments }
    end
  rescue
  logger.error("Attempt to display the list of experiments without defined project")
  flash[:notice] = 'Select a project'
  redirect_to(:controller =>"projects", :action => 'index')
  end

  def detail_frame_form
    # before_filter checkexpid done before
    @readonly =true
    @experiment = Experiment.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @experiment }
    end
  end
 
  def new_frame_form
    @readonly = false
    @project = Project.find(find_project[0])
    @experiment = Experiment.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @experiment }
    end
  end
    
  def edit_frame_form
    # before_filter checkexpid done before
    @readonly =false
    @experiment = Experiment.find(params[:id])
     
    respond_to do |format|
     format.html # new.html.erb
     format.xml  { render :xml => @experiment }
    end
  end
  
  def create
    @project = Project.find(find_project[0]) #utile en cas de echec sauvegarde
    @experiment = Experiment.new(params[:experiment])
    @experiment.last_update = get_date
    @experiment.project_id = find_project[0]
    
    @collection = find_collection(Linkexpdoc)
    @experiment.linkexpdocs << @collection.items
    @collection_protref = find_collection(Linkexpprotref)
    @experiment.linkexpprotrefs << @collection_protref.items
        
    collection2 = find_collection(Linkdocumentationdoc)
    if collection2.items.length != 0
      flash[:notice] = 'You opened another window of documentation. Go back to index and click close this window before creating this experiment.'
      render :action => "new_frame_form"    
    else
    respond_to do |format|
      if @experiment.save
        format.html { redirect_to_index('Experiment was successfully created.')}
        format.xml  { render :xml => @experiment, :status => :created, :location => @experiment }
      else
        format.html { @readonly = false; render :action => "new_frame_form" }
        format.xml  { render :xml => @experiment.errors, :status => :unprocessable_entity }
      end
    end
    end
  end
  
  def update
    @project = Project.find(find_project[0]) #utile en cas de echec sauvegarde
    @experiment = Experiment.find(params[:id])
    @experiment.last_update = get_date
    
    @collection = find_collection(Linkexpdoc)
    @experiment.linkexpdocs = @collection.items    
    @collection_protref = find_collection(Linkexpprotref)
    @experiment.linkexpprotrefs = @collection_protref.items
     
    collection2 = find_collection(Linkdocumentationdoc)
    if collection2.items.length != 0
      flash[:notice] = 'You opened another window of documentation. Go back to index and click close this window before creating this experiment.'
      render :action => "edit_frame_form"    
    else
    respond_to do |format|
      if @experiment.update_attributes(params[:experiment])
        format.html { redirect_to_index('Experiment was successfully updated.') }  
      else
        format.html { @readonly = false; render :action => "edit_frame_form" }
      end
    end
    end
  end

  def destroy
    experiment = Experiment.find(params[:id])
    # la destruction des linkexpdoc associe est automatique par :dependent
    # les doc associes a l'exp sont detruit seulement si ils ne pointent vers rien d'autre
    tab = experiment.linkexpdocs
      for item in tab do
        tab2 = Linkexpdoc.find(:all, :conditions => {:doc_id => item.doc_id})
        if tab2.length == 1
          vardoc = Doc.find(item.doc.id)
          # on destroy le doc
          vardoc.destroy  
        end
      end
    
   # je ne détruit pas les protref associes car iles peuvent etre utilisés par d'autre experiences.
    experiment.destroy

    respond_to do |format|
      format.html { redirect_to_index }
      format.xml  { head :ok }
    end
  end

def add_typexp
  @typexp = Typexp.new(params[:typexp])
  if @typexp.save
    flash[:notice] = 'Vendor was successfully created.'
    redirect_to :action => 'list_typexp'
  else
    flash[:notice] = 'Bad syntax or field Name empty, try again.'
    redirect_to :action => 'list_typexp'
  end
end

def update_typexp
   @typexp = Typexp.find(params[:id]) 
   if @typexp.update_attributes(params[:typexp])
   redirect_to :action => 'list_typexp'
   end
end

  def list_typexp
    @typexps = Typexp.find(:all)
    #@typexp_pages, @typexps = paginate :typexps, :per_page => 10
    render(:layout => false)
  end
  
  def destroy_typexp
    Typexp.find(params[:id]).destroy
    redirect_to :action =>'list_typexp'
  end  


def redirect_to_index(msg = nil)
@collection = find_collection(Linkexpdoc)
@collection.empty!
@collection_protref = find_collection(Linkexpprotref)
@collection_protref.empty!

flash[:notice] = msg if msg
redirect_to :action => 'index'
end

def import
  @project = Project.find(find_project[0])
  indic1=[["-----Your templates-----",0]]
  template = Project.find(:first, :conditions => {:name => "My experiment templates"})
  indic2= [["------Your experiments------",0]]
  exp=Experiment.find(:all, :conditions => {:project_id => @project})
  @table = indic1 + template.experiments.collect{ |p| [p.title, p.id] } + indic2 + exp.collect{ |p| [p.title, p.id]}
end

def imported
  var = params[:experiment][:id]
  if (var=="") or (var=="0")
    @project = Project.find(find_project[0])
    flash[:notice] = 'Error: Select a template'
    redirect_to :action => 'import'
  else
  @experiment = Experiment.find(params[:experiment][:id])  
  
  @collection_protref = find_collection(Linkexpprotref)
  for item in @experiment.linkexpprotrefs do
  @collection_protref.add_picture(item.protref)
  end
  
  @project = Project.find(find_project[0])
  @readonly =false  
  @experiment.id = nil
  render :action => 'new_frame_form'
  end  
 
end

def sort
  quoi = params[:sort]
  @project = Project.find(find_project[0])
  if quoi == "Type"
  @experiments = Experiment.find(:all, :conditions => "project_id = " + @project.id.to_s, :order => "typexp_id" ) 
  elsif quoi == "Performed"
  @experiments = Experiment.find(:all, :conditions => "project_id = " + @project.id.to_s, :order => "date_exp" )
  elsif quoi == "Updated"
  @experiments = Experiment.find(:all, :conditions => "project_id = " + @project.id.to_s, :order => "last_update" )
  end
render :action => "index"
end

def keypoints
  @project = Project.find(find_project[0])
  essai = Experiment.find(:all, :conditions => {:project_id => @project}, :select => "DISTINCT typexp_id")
 
 @table = []
 for n in essai do
 v1=Typexp.find(n.typexp_id)
 exp = Experiment.find(:all, :conditions => "project_id = " + @project.id.to_s + " AND typexp_id = " + n.typexp_id.to_s + " AND summary <> ''" )
 @table << [v1.name, exp ]
 end
end

def print
 @experiment = Experiment.find(params[:id])
 @items = Linkexpdoc.find(:all, :conditions => {:experiment_id => [params[:id]]}, :limit => 20)
 @items2 = Linkexpprotref.find(:all, :conditions => {:experiment_id => [params[:id]]}, :limit => 20)
 render(:layout => false, :popup => true)
end

end
