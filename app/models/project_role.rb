class ProjectRole < ActiveRecord::Base
  unloadable

  belongs_to :role

  attr_accessor :project_id

end
