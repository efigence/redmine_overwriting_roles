module RedmineOverwritingRoles
  module Patches
    module ProjectsHelperPatch
      def self.included(base)
        base.class_eval do
          unloadable

          alias_method :project_settings_tabs_original, :project_settings_tabs

          def project_settings_tabs
            # if User.current.allowed_to?(:manage_public_tags, @project)
            tabs << {
              name: 'roles',
              action: :manage_project_roles,
              partial: 'projects/settings/roles',
              label: :project_roles_settings
            }
            project_settings_tabs
          end
        end
      end
    end
  end
end

unless ProjectsHelper.included_modules.include?(RedmineOverwritingRoles::Patches::ProjectsHelperPatch)
  ProjectsHelper.send(:include, RedmineOverwritingRoles::Patches::ProjectsHelperPatch)
end
