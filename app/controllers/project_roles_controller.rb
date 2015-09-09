class ProjectRolesController < ApplicationController

  before_filter :find_project
  before_filter :find_role, only: [:save, :edit, :reset]

  def index
    @roles = Role.all
  end

  def edit
    @project_role = find_project_role || build_project_role
  end

  def save
    @project_role = find_project_role || build_project_role
    @project_role.permissions = params[:project_role][:permissions]
    if @project_role.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to "/projects/#{@project.id}/settings/roles"
    else
      render :action => 'edit'
    end
  end

  def reset
    @project_role = find_project_role || build_project_role
    @project_role.permissions = @role.permissions
    @project_role.save
    flash[:notice] = l(:notice_successfull_reset)
    redirect_to edit_project_role_path(@project, @role)
  end

  private
  def build_project_role
    ProjectRole.new(@role.attributes.merge({project_id: @project.id, role_id: @role.id}))
  end

  def find_project_role
    @role.project_roles.where(project_id: @project.id).first
  end

  def find_role
    @role = Role.find(params[:role_id])
  end

end
