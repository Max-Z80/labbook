require "digest/sha1"

class User < ActiveRecord::Base
attr_accessor :password
attr_accessible :name, :password, :email

validates_presence_of :name, :email, :password
validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
validates_uniqueness_of :name, :message => "Login already in use, change it."

def before_create
self.hashed_password = User.hash_password(self.password)
end

def after_create
UserMailer.deliver_newuser(self)  

@password = nil
end

def try_to_login
User.login(self.name, self.password)
end



private
def self.hash_password(password)
Digest::SHA1.hexdigest(password)
end

def self.login(name, password)
hashed_password = hash_password(password || "")
find(:first, :conditions => ["name = ? and hashed_password = ?", name, hashed_password])
end

end
