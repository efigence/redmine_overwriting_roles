module RedmineOverwritingRoles
  module Patches
    module RolePatch
      def self.included(base)
        base.class_eval do
          unloadable

          has_many :project_roles

          def allowed_to?(action, context = nil)
            if context != nil
              if context.is_a?(Project) && self.project_roles && self.project_roles.pluck(:role_id).include?(self.id)
                self.permissions = self.project_roles.where("project_id = ? AND role_id = ?", context.id, self.id).first.permissions
                return self
              end
            end

            if action.is_a? Hash
              allowed_actions.include? "#{action[:controller]}/#{action[:action]}"
            else
              allowed_permissions.include? action
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
