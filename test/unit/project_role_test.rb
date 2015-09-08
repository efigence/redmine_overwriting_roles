require File.expand_path('../../test_helper', __FILE__)

class ProjectRoleTest < ActiveSupport::TestCase
  fixtures :users, :projects, :roles, :project_roles, :members, :member_roles

  def test_should_check_permissions_without_context
    role = roles(:roles_001)
    assert_equal true, role.allowed_to?(role.permissions.last)
  end

  def test_should_check_permissions_in_project_context
    role = roles(:roles_001)
    byebug
    assert_equal false, role.allowed_to?(role.permissions.last, Project.first)
  end

end
