class AddProjectRoleIdToMemberRoles < ActiveRecord::Migration

  def up
    add_column :member_roles, :project_role_id, :integer, :limit => 4, :null => false
  end

  def down
    remove_column :member_roles, :project_role_id
  end

end
