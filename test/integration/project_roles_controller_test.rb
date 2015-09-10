require File.expand_path('../../test_helper', __FILE__)

class ProjectRolesControllerTest < Redmine::IntegrationTest
  fixtures :users, :projects, :roles, :project_roles, :members, :member_roles

  def test_should_allow_admin_to_see_roles_settings
    log_user("admin", "admin")
    project = projects(:projects_001)
    get '/projects/1/settings'
    assert_response :success
    assert_equal true, User.current.allowed_to?(:manage_roles, project)

    get '/projects/2/project_roles/'
    assert_response :success

    get '/projects/2/project_roles/1/edit'
    assert_response :success

    get '/projects/2/project_roles/1/reset'
    assert_response :redirect

  end

  def test_should_allow_project_manager_to_see_roles_settings
    log_user("jsmith", "jsmith")
    project = projects(:projects_001)
    byebug
    get '/projects/1/settings'
    assert_response :success
    assert_equal true, User.current.allowed_to?(:manage_roles, project)

    get '/projects/2/project_roles/'
    assert_response :success

    get '/projects/2/project_roles/1/edit'
    assert_response :success

    get '/projects/2/project_roles/1/reset'
    assert_response :redirect

  end

  # def test_should_not_allow_to_see_roles_settings
  #   log_user("jsmith", "jsmith")
  #   Project.find(2).members.first.roles.where(name: "Manager").first.delete
  #   # get '/projects/2/'
  #   # assert_response :success
  #   # assert_select '.settings', false

  #   get '/projects/2/project_roles/'
  #   assert_response :redirect

  #   get '/projects/2/project_roles/1/edit'
  #   assert_response :redirect

  #   get '/projects/2/project_roles/1/reset'
  #   assert_response :redirect
  # end

end
