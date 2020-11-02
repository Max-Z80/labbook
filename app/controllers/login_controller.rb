class LoginController < ApplicationController


def welcome
 if request.get?
  session[:user_id] = nil 
  @user = User.new
 else
  @user = User.new(params[:user])
  logged_in_user = @user.try_to_login
   if logged_in_user
    session[:user_id] = logged_in_user.id
    redirect_to(:controller => "projects", :action => "index")
   else flash[:notice] = "Invalid user/password combination" end
 end
end

def logout
 #session[:user_id] = nil
 redirect_to_welcome("Logged out")
end

def contactmewhenlogged
  @origin = "logged"
  user = User.find(session[:user_id])
  message = { :who => user.name, :sender=> user.email, :core => "", :object => ""}
  @message = Message.new(message,false)
  render :action => "contactme" 
end

def contactme
  @origin = "notlogged"
end

def sendmessage
  @message = Message.new(params[:message],true)
  UserMailer.deliver_contact_webmaster(@message)
  flash[:notice] = 'Message sent successfully.'
  if session[:user_id] == nil
   redirect_to :action => "welcome"
  else
   redirect_to :controller => "projects", :action => "index" 
  end
  
  rescue
  flash[:notice] = 'Please fill all the fields'
  @message = Message.new(params[:message], false)
  render :action => "contactme" 
end

def add_user
 if request.get?
  @user = User.new
 else
  @user = User.new(params[:user])
  if @user.save
   #creation of a root and template project folders
   project = Project.new(:name => "Root",:user_id => @user.id) 
   if project.save
    project2 = Project.new( :name => 'My projects', :user_id => @user.id, :parent_id => project.id)
    if project2.save
    project3 = Project.new( :name => 'Miscellaneous', :user_id => @user.id, :parent_id => project.id)
      if project3.save
      project4 = Project.new( :name => 'My experiment templates', :user_id => @user.id, :parent_id => project3.id)
        if project4.save
        project5 = Project.new( :name => 'My reference protocols', :user_id => @user.id, :parent_id => project3.id)
          if project5.save
          redirect_to_welcome("The user has been successfully created. Check your e-mails.")  
          end
        end
      end
    end  
   end
  end
 end
end

def redirect_to_welcome(msg = nil)
  flash[:notice] = msg if msg
  redirect_to(:action => 'welcome')
end

end
