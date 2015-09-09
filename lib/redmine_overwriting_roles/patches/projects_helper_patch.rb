require_dependency 'projects_helper'

module RedmineOverwritingRoles
  module Patches
    module ProjectsHelperPatch
      def self.included(base)
        base.class_eval do
          unloadable

          def project_settings_tabs_with_project_roles
            # if User.current.allowed_to?(:manage_public_tags, @project)
            tabs = project_settings_tabs_without_project_roles

            tabs << {
              name: 'roles',
              action: :manage_project_roles,
              partial: 'projects/settings/roles',
              label: :project_roles_settings
            }
            tabs
          end

          alias_method_chain :project_settings_tabs, :project_roles

        end
      end
    end
  end
end

unless ProjectsHelper.included_modules.include?(RedmineOverwritingRoles::Patches::ProjectsHelperPatch)
  ProjectsHelper.send(:include, RedmineOverwritingRoles::Patches::ProjectsHelperPatch)
end
