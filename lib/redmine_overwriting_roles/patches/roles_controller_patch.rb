module RedmineOverwritingRoles
  module Patches
    module RolesControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          def update
            if @role.update_attributes(params[:role])
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
