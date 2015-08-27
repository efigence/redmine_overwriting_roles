module RedmineOverwritingRoles
  module Patches
    module RolePatch
      def self.included(base)
        base.class_eval do
          unloadable

          before_save :check_if_name_exists

          def check_if_name_exists
            if Role.exists?(name: self.name)
              self.name += self.project.id
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
