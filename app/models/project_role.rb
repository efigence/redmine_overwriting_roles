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

  def roles_permissions
    Setting.plugin_overwriting_roles["permissions"]
  end

  def permissions=(perms)
    perms = perms.collect {|p| p.to_sym unless p.blank? }.compact.uniq if perms
    write_attribute(:permissions, perms)
  end

end
