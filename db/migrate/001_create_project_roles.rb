class CreateProjectRoles < ActiveRecord::Migration
  def up
    create_table :project_roles do |t|
      t.column :name, :string, :limit => 30, :default => "", :null => false
      t.column :role_id, :integer, :limit => 4, :null => false
      t.column :project_id, :integer, :limit => 4, :null => false
      t.column :position, :integer, :limit => 4, :default => 1
      t.column :assignable, :boolean, :limit => 1, :default => true
      t.column :builtin, :integer, :limit => 4, :default => 0, :null => false
      t.column :permissions, :text, :limit => 65535
      t.column :issues_visibility, :string, :limit => 30, :default => "default", :null => false
      t.column :users_visibility, :string, :limit => 30, :default => "all", :null => false
    end
  end

  def down
    drop_table :project_roles
  end
end
