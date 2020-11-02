class ProjectsController < ApplicationController
  layout :test_iframe 
  before_filter :authorize
  
  def index
    @projects = Project.find(:all, :conditions => { :parent_id => nil, :user_id => session[:user_id]})
    @protref = Protref.find(:all, :conditions => {:user_id => session[:user_id]})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
      end
  end


  # GET /projects/new
  # GET /projects/new.xml
  def new
    @iframe=true
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

 def move
   @iframe=true
 end
 
 def rename
   @iframe=true
 end
 
 
  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    @project.user_id = session[:user_id]
    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { render :action => "ok", :layout => false }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new", :layout => false }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    var = params[:origin][:value]
    @project = Project.find(params[:project][:id])
    

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { render :action => "ok", :layout => false}
        format.xml  { head :ok }
      else
        if var == 'rename'
        format.html { render :action => "rename"}
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
        else
        format.html { render :action => "move"}
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
        end    
      end
    end   
  rescue
    # we reach this point if the first find request fails because the first filed is not filled
    flash[:notice] = 'Please, select a folder.'
    if var == 'rename'
     redirect_to :action => "rename", :layout => false
    else
     redirect_to :action => "move", :layout => false
    end    
  end

  def delete
    @iframe=true
  #creation d'un tableau contenant que les folders pouvant etre effacer
  @tableau =[]
  for var in Project.find(:all, :conditions => {:user_id => session[:user_id]}) do
    if var.children.empty? & var.experiments.empty? & var.documentations.empty? & (not var.name == "My reference protocols")
      @tableau << var
    end
  end
  end
  
  def destroy
    @project = Project.find(params[:project][:id])
    if @project.destroy
    flash[:notice] = 'Project was successfully deleted.'
    render :action => "ok", :layout => false
    else 
    flash[:notice] = "It is forbidden to delete this entry."
    redirect_to :action => "delete"
    end
  rescue
  # we reach this point if the find request fails because the field is not filled
    flash[:notice]='Please, select a folder.'
    redirect_to :action => "delete", :layout => false    
  end


end
