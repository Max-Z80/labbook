class ExpTreeController < ApplicationController
layout :test_iframe 
before_filter :authorize

def index
   @project = Project.find(find_project[0])
   
 end
 
def change
  @iframe = true
  @project = Project.find(find_project[0])
  indic1=[["-----Experiments hierarchized-----",0]]
  expnoneorphan = Experiment.find(:all, :conditions => ["project_id = ? AND parent_id is not null", @project])
  indic2= [["------Orphan experiments------",0]]
  orphan=Experiment.find(:all, :conditions => {:project_id => @project, :parent_id => nil})
  @table = indic1 + expnoneorphan.collect{ |p| [p.title, p.id] } + indic2 + orphan.collect{ |p| [p.title, p.id]}
end
 
def update
 var = params[:experiment][:id]
 @project = Project.find(find_project[0]) #utile en cas de echec sauvegarde
 
 if (var=="") or (var=="0")
   flash[:notice] = 'Error: Select a template'
   redirect_to :action => 'change'
 else
   @experiment = Experiment.find(params[:experiment][:id])
   respond_to do |format|
    if @experiment.update_attributes(params[:experiment])
      flash[:notice] = "Experiment sucessfully updated"
      format.html { render :action => "ok" ,:layout => false}
      format.xml  { head :ok }
    else
      format.html { render :action => "change" }
      format.xml  { render :xml => @experiment.errors, :status => :unprocessable_entity }
    end
   end
 end 
end

def list
  @iframe = true
  @project = Project.find(find_project[0])
  @experiment = Experiment.find(:all, :conditions => {:project_id => @project} )
  
end
 
end
