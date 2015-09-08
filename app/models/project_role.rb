class ProjectRole < ActiveRecord::Base
  unloadable

  belongs_to :role

end
