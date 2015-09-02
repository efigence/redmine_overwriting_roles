module RedmineOverwritingRoles
  module Patches
    module RolePatch
      def self.included(base)
        base.class_eval do
          unloadable

          has_many :project_roles

        end
      end
    end
  end
end

unless Role.included_modules.include?(RedmineOverwritingRoles::Patches::RolePatch)
  Role.send(:include, RedmineOverwritingRoles::Patches::RolePatch)
end
