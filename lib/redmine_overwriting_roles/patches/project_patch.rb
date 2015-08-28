module RedmineOverwritingRoles
  module Patches
    module ProjectPatch
      def self.included(base)
        base.class_eval do
          unloadable

          has_many :roles

        end
      end
    end
  end
end

unless Project.included_modules.include?(RedmineOverwritingRoles::Patches::ProjectPatch)
  Project.send(:include, RedmineOverwritingRoles::Patches::ProjectPatch)
end
