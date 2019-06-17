Rails.application.routes.draw do
  devise_for :users
	require 'sidekiq/web'
	mount Sidekiq::Web => '/sidekiq'
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	get '/', as: 'index', to: 'main#index'
	get '/domain-list', as: 'domain_list', to: 'domain#domain_list'
	get '/add-domains', as: 'add_domains', to: 'domain#add_domains'
	post '/add-domains', as: 'add_domains_save', to: 'domain#add_domains_save'
	post '/del-domain', as: 'del_domain', to: 'domain#del_domain'

end
