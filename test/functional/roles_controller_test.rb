require File.expand_path('../../test_helper', __FILE__)

class ProjectRoleTest < ActiveSupport::TestCase
  fixtures :users, :projects, :roles, :project_roles, :members, :member_roles

  def test_should_update_role_without_context
    role = roles(:roles_001)
    assert_no_difference('ProjectRole.count') do
      role.update(name: "Update test")
    end
  end

  def test_should_create_project_role_with_context
    role = roles(:roles_001)
    assert_difference('ProjectRole.count') do
      role.update(name: "Update test") # context?!
    end
  end

end
