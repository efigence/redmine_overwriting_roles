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
    setable_permissions = Array.new
    Setting.plugin_redmine_overwriting_roles["permissions"].each do |setting|
      setable_permissions += Redmine::AccessControl.permissions.select {|perm| perm.name == setting.to_sym}
    end
    setable_permissions
  end

  def permissions=(perms)
    perms = perms.collect {|p| p.to_sym unless p.blank? }.compact.uniq if perms
    write_attribute(:permissions, perms)
  end

end
