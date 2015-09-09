class ProjectRole < ActiveRecord::Base
  unloadable

  belongs_to :role

  attr_accessible :project_id,
                        :role_id,
                        :name,
                        :position,
                        :assignable,
                        :builtin,
                        :permissions,
                        :issues_visibility,
                        :users_visibility

  serialize :permissions, ::Role::PermissionsAttributeCoder

  def setable_permissions
    setable_permissions = Redmine::AccessControl.permissions - Redmine::AccessControl.public_permissions
    setable_permissions -= Redmine::AccessControl.members_only_permissions
    setable_permissions -= Redmine::AccessControl.loggedin_only_permissions
    setable_permissions -= [:manage_project_activities]
    setable_permissions
  end

  def permissions=(perms)
    perms = perms.collect {|p| p.to_sym unless p.blank? }.compact.uniq if perms
    write_attribute(:permissions, perms)
  end

end
