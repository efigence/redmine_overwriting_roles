module RedmineOverwritingRoles
  module Patches
    module ProjectPatch
      def self.included(base)
        base.class_eval do
          unloadable

          def self.allowed_to_condition(user, permission, options={})
            perm = Redmine::AccessControl.permission(permission)
            base_statement = (perm && perm.read? ? "#{Project.table_name}.status <> #{Project::STATUS_ARCHIVED}" : "#{Project.table_name}.status = #{Project::STATUS_ACTIVE}")
            if perm && perm.project_module
              # If the permission belongs to a project module, make sure the module is enabled
              base_statement << " AND #{Project.table_name}.id IN (SELECT em.project_id FROM #{EnabledModule.table_name} em WHERE em.name='#{perm.project_module}')"
            end
            if project = options[:project]
              project_statement = project.project_condition(options[:with_subprojects])
              base_statement = "(#{project_statement}) AND (#{base_statement})"
            end

            if user.admin?
              base_statement
            else
              statement_by_role = {}
              statement_by_role.compare_by_identity
              unless options[:member]
                role = user.builtin_role
                if role.allowed_to?(permission)
                  statement_by_role[role] = "#{Project.table_name}.is_public = #{connection.quoted_true}"
                end
              end
              user.projects.each do |project|
                if user.allowed_to?(permission, project)
                  user.roles_for_project(project).each do |role|
                    statement_by_role[role] = "#{Project.table_name}.id = #{project.id}"
                  end
                end
              end


              if statement_by_role.empty?
                "1=0"
              else
                if block_given?
                  statement_by_role.each do |role, statement|
                    if s = yield(role, user)
                      statement_by_role[role] = "(#{statement} AND (#{s}))"
                    end
                  end
                end
                "((#{base_statement}) AND (#{statement_by_role.values.join(' OR ')}))"
              end
            end
          end
        end
      end
    end
  end
end

unless Project.included_modules.include?(RedmineOverwritingRoles::Patches::ProjectPatch)
  Project.send(:include, RedmineOverwritingRoles::Patches::ProjectPatch)
end
