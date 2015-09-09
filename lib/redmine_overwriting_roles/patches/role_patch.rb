module RedmineOverwritingRoles
  module Patches
    module RolePatch
      def self.included(base)
        base.class_eval do
          unloadable

          has_many :project_roles

          def allowed_to_with_project?(action, context = nil)
            if context != nil && context.is_a?(Project)
              project_role = project_roles.where(project_id: context.id).first
              if project_role
               self.permissions = project_role.permissions.collect {|p| p.to_sym unless p.blank? }.compact.uniq
             end
           end
           allowed_to_without_project?(action)
         end

         alias_method_chain :allowed_to?, :project

       end
     end
   end
 end
end

unless Role.included_modules.include?(RedmineOverwritingRoles::Patches::RolePatch)
  Role.send(:include, RedmineOverwritingRoles::Patches::RolePatch)
end
