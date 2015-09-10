require File.expand_path("../../test_helper", __FILE__)

class ProjectRolesControllerTest < Redmine::IntegrationTest
  fixtures :users, :projects, :roles, :project_roles, :members, :member_roles

  def setup
    @project = projects(:projects_001)
  end

  def test_should_allow_admin_to_see_roles_settings
    log_user("admin", "admin")
    assert_equal true, User.current.allowed_to?(:manage_roles, @project)

    get settings_project_path(@project)
    assert_response :success
    assert_select "#tab-roles"

    get project_roles_path(@project)
    assert_response :success

    get edit_project_role_path(@project, Role.first.id)
    assert_response :success

    get reset_project_role_path(@project, Role.first.id)
    assert_redirected_to edit_project_role_path(@project, Role.first.id)
  end

  def test_should_allow_project_manager_to_see_roles_settings
    log_user("jsmith", "jsmith")
    assert_equal true, User.current.allowed_to?(:manage_roles, @project)

    get settings_project_path(@project)
    assert_response :success
    assert_select "#tab-roles"

    get project_roles_path(@project)
    assert_response :success

    get edit_project_role_path(@project, Role.first.id)
    assert_response :success

    get reset_project_role_path(@project, Role.first.id)
    assert_redirected_to edit_project_role_path(@project, Role.first.id)
  end

  def test_should_not_allow_to_see_roles_settings
    log_user("dlopper", "foo")
    assert_equal false, User.current.allowed_to?(:manage_roles, @project)

    get settings_project_path(@project)
    assert_response :success
    assert_select "#tab-roles", false

    get project_roles_path(@project)
    assert_response :redirect

    get edit_project_role_path(@project, Role.first.id)
    assert_response :redirect

    get reset_project_role_path(@project, Role.first.id)
    assert_redirected_to home_path
  end

end
