 module RedmineOverwritingRoles
  module Patches
    module MemberPatch
      def self.included(base)
        base.class_eval do
          unloadable

          before_save :create_project_role

          def create_project_role

          end

        end
      end
    end
  end
end

unless Member.included_modules.include?(RedmineOverwritingRoles::Patches::MemberPatch)
  Member.send(:include, RedmineOverwritingRoles::Patches::MemberPatch)
end
