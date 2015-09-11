class ProjectRolesController < ApplicationController

  before_filter :find_project
  before_filter :find_role, only: [:save, :edit, :reset]
  before_filter :assign_project_role, only: [:edit, :save, :reset]
  before_filter :check_permissions

  def index
    @roles = Role.all
  end

  def edit
    render partial: 'edit', :layout => false if request.xhr?
  end

  def save
    @project_role.permissions = params[:project_role][:permissions]
    if @project_role.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to settings_project_path(:tab => 'roles')
    else
      render :action => 'edit'
    end
  end

  def reset
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

  def assign_project_role
    @project_role = find_project_role || build_project_role
  end

  def check_permissions
    unless User.current.admin? || User.current.allowed_to?(:manage_roles, @project)
      redirect_to home_path
    end
  end
end
