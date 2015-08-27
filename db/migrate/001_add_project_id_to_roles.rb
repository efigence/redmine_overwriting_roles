class AddProjectIdToRoles < ActiveRecord::Migration
  def up
    add_column :roles, :project_id, :integer
  end

  def down
    remove_column :roles, :project_id, :integer
  end
end
