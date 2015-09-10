require File.expand_path('../../test_helper', __FILE__)

class ProjectRolesControllerTest < Redmine::IntegrationTest
  fixtures :users, :projects, :roles, :project_roles, :members, :member_roles

  def test_should_allow_project_manager_to_see_roles_settings
    log_user("jsmith", "jsmith")
    project = projects(:projects_002)
    # byebug
    # get '/projects/2/'
    # assert_response :success
    # assert_select '.settings'

    get '/projects/2/project_roles/'
    assert_response :success

    get '/projects/2/project_roles/1/edit'
    assert_response :success

    get '/projects/2/project_roles/1/reset'
    assert_response :redirect

  end

  def test_should_not_allow_to_see_roles_settings
    log_user("jsmith", "jsmith")
    Project.find(2).members.first.roles.where(name: "Manager").first.delete
    # get '/projects/2/'
    # assert_response :success
    # assert_select '.settings', false

    get '/projects/2/project_roles/'
    assert_response :missing

    get '/projects/2/project_roles/1/edit'
    assert_response :missing

    get '/projects/2/project_roles/1/reset'
    assert_response :missing
  end

end
