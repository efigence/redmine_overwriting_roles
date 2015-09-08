Redmine::Plugin.register :redmine_overwriting_roles do
  name 'Redmine Overwriting Roles plugin'
  author 'Maria Syczewska'
  description 'This is a plugin for Redmine for overwriting roles within the project'
  version '0.0.1'
  url 'https://github.com/efigence/redmine_overwriting_roles'
  author_url 'https://github.com/efigence'

  ActionDispatch::Callbacks.to_prepare do
    require 'redmine_overwriting_roles/patches/role_patch'
    # require 'redmine_overwriting_roles/patches/roles_controller_patch'
    require 'redmine_overwriting_roles/patches/user_patch'
  end
end
