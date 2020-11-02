class Typexp < ActiveRecord::Base
  has_many :experiments, :dependent => :nullify
end
