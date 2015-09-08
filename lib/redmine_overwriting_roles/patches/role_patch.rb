module RedmineOverwritingRoles
  module Patches
    module RolePatch
      def self.included(base)
        base.class_eval do
          unloadable

          has_many :project_roles
          attr_accessor :project_id

          before_save :create_project_role

          def allowed_to?(action, context = nil)
            if context != nil && context.is_a?(Project)
              if self.project_roles && self.project_roles.pluck(:role_id).include?(self.id)
               context_permissions = self.project_roles.where("project_id = ? AND role_id = ?", context.id, self.id).first.permissions
               self.permissions = Role::PermissionsAttributeCoder.load(context_permissions)
             end
           end

            if action.is_a? Hash
              allowed_actions.include? "#{action[:controller]}/#{action[:action]}"
            else
              allowed_permissions.include? action
            end
          end

          def create_project_role
            if self.project_id
              @project_role = ProjectRole.new
              self.attributes.each do |attribute|
                @project_role.attribute = attribute
              end
              @project_role.project_id = self.project_id
              @project_role.role_id = @self.id

              # if @project_role.save
              #   flash[:notice] = l(:notice_successful_create)
              #   redirect_to settings_project_path
              # else
              #   render :action => 'edit'
              # end
              return
            end
          end
        end
      end
    end
  end
end

unless Role.included_modules.include?(RedmineOverwritingRoles::Patches::RolePatch)
  Role.send(:include, RedmineOverwritingRoles::Patches::RolePatch)
end
