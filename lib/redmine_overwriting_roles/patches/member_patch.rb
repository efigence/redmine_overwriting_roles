module RedmineOverwritingRoles
  module Patches
    module MemberPatch
      def self.included(base)
        base.class_eval do
          unloadable

          before_save :assign_project_role

          def assign_project_role
            project_roles = self.roles
            project.roles.each do |role|
              if ProjectRole.where("name = ? AND project_id = ?", self.project_id)
                member.project_role_id =
              else

              end
            end
          end
        end
      end
    end
  end
end

unless Member.included_modules.include?(RedmineOverwritingRoles::Patches::MemberPatch)
  Member.send(:include, RedmineOverwritingRoles::Patches::MemberPatch)
end
