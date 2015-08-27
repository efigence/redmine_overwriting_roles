module RedmineOverwritingRoles
  module Patches
    module MemberPatch
      def self.included(base)
        base.class_eval do
          unloadable

          def permissions
            @roles = Role.sorted.to_a
            @permissions = Redmine::AccessControl.permissions.select { |p| !p.public? }
            if request.post?
              @roles.each do |role|
                role.permissions = params[:permissions][role.id.to_s]
                role.save
              end
              flash[:notice] = l(:notice_successful_update)
              redirect_to roles_path
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
