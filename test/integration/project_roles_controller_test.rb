require File.expand_path('../../test_helper', __FILE__)

class ProjectRolesControllerTest < Redmine::IntegrationTest
  fixtures :users, :projects, :roles, :project_roles, :members, :member_roles

  def test_should_allow_project_manager_to_see_roles_settings
    log_user("jsmith", "jsmith")
    get '/projects/2/settings'
    assert_response :success
    assert_select '#tab-roles'
  end

  def test_should_not_allow_to_see_roles_settings
    log_user("jsmith", "jsmith")
    get '/projects/2'
    Project.find(2).members.first.roles.where(name: "Manager").first.delete
    byebug
    assert_response :success
    assert_select '.settings', false
  end

end
