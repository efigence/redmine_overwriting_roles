module RedmineOverwritingRoles
  module Patches
    module RolesControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          def update(context = nil)
            if context != nil && context.is_a?(Project)
              @project_role = ProjectRole.new(params[:role])
              @project_role.project_id = context.project_id
              @project_role.role_id = @role.id

              if @project_role.save
                flash[:notice] = l(:notice_successful_create)
                redirect_to settings_project_path
              else
                render :action => 'edit'
              end

            elsif @role.update_attributes(params[:role])
              flash[:notice] = l(:notice_successful_update)
              redirect_to roles_path(:page => params[:page])
            else
              render :action => 'edit'
            end
          end

        end
      end
    end
  end
end

unless RolesController.included_modules.include?(RedmineOverwritingRoles::Patches::RolesControllerPatch)
  RolesController.send(:include, RedmineOverwritingRoles::Patches::RolesControllerPatch)
end
