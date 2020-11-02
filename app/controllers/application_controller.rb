# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  
  protect_from_forgery  :secret => 'bf4a0de3a87c14d97104c563a3f2b016'
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  #model :collection
  #model :linkexpdoc

private
  def find_project
    session[:project] ||= Array.new(1)
  end   

 def find_collection(table)
   if table == Linkprotrefdoc then session[:collection_doc_for_protref] ||= Collection.new   
   elsif table == Linkdocumentationdoc then session[:collection_doc_for_documentation] ||= Collection.new
   elsif table == Linkexpdoc then session[:collection_doc_for_exp] ||= Collection.new
   elsif table == Linkexpprotref then session[:collection_protref_for_exp] ||= Collection.new
   end
 end
  
  def get_date
    Date.today
  end

  def test_iframe
   if @iframe then "iframe" else "application"  end
  end

  def test_layout_protref
   if @layout_application then  "application"  else "iframe"  end
  end


  def authorize
   unless session[:user_id]
   flash[:notice] = "Please log in"
   redirect_to(:controller => "login", :action => "welcome")
   end
  end


end
