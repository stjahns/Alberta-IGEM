ActionController::Routing::Routes.draw do |map|

  map.resources :encyclopaedias

  map.resources :glossaries

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.signup '/signup', :controller => 'users', :action => 'new'

  map.resources :users
  map.resources :viewer

  #map annoations as nested resource of biobytes
  map.resources :bio_bytes, :member => { :upload => :post, :update => :post } do |bytes|
    bytes.resources :annotations
  end

  map.resources :orfs, :controller => :bio_bytes
  map.resources :linkers, :controller => :bio_bytes

  map.resource :session


  # pretty routes for user profile pages
  map.profile '/user/:login', :controller => 'users', :action => 'profile', :method => 'get' 

  # nest note in steps without nesting steps in experiment
  map.resources :steps do |steps|
     steps.resource  :note, :member => { :upload => :post }
  end

  map.resources :glossaries

  # map steps as nested resource of experiments
  map.resources :experiments, :member => { :print => :get,
                                           :clone => :get } do |experiments|
     experiments.resources :steps, 
	     :member => { :upload => :post, 
	     		  :up => :put,
    			  :down => :put,
    			  :insert_after => :put,
                          :insert_before => :put }
     experiments.resource :construct
  end 


  # named route for getting part data for construct/experiment views
  map.part_data '/get_part_data', :controller => :constructs, :action => :get_data
  map.save_construct '/save_construct', :controller => :constructs, :action => :save
  # some shorthand for routes
  map.move_step_up 'experiments/:experiment_id/steps/:id/up' , :controller => :steps, :action =>:up
  map.move_step_down 'experiments/:experiment_id/steps/:id/down', :controller => :steps, :action =>:down

  map.root :controller => :home 

  # routes for images
  map.resources :images, :member => { :thumb => :get, :step => :get  }
  
  
  # default routes
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
  

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
end
