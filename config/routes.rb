# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do

  get 'projects/:id/project_roles/:role_id/edit', :to => 'project_roles#edit', as: :edit_project_role
  get 'projects/:id/project_roles', :to => 'project_roles#index', as: :project_roles
  post 'projects/:id/project_roles/:role_id/save', :to => 'project_roles#save', as: :save_project_role
  patch 'projects/:id/project_roles/:role_id/save', :to => 'project_roles#save'

end
