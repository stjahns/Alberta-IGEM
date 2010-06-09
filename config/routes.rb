ActionController::Routing::Routes.draw do |map|
  
 
  #map.resources :steps
  map.resources :experiments, :has_many => :steps

 
############ various routes i was trying out
  # map.resources :experiments do |e|
 #	  e.resources :has_many => :steps , :member => { :upload => :post }
 # end
#  map.resources :steps, :member => { :upload => :post }
############

  map.root :controller => "home"

  # routes for images
  map.resources :images
  #map.resources :images, :member => {:thumb => :get, :step => 'get' }
  map.thumb 'images/thumb/:id', :controller => 'images', :action => 'thumb' 
  map.step_image 'images/step/:id', :controller => 'images', :action => 'step'

  # image upload route to steps 
 # map.connect 'experiments/:experiment_id/steps/:id', :controller => 'steps', :action => 'upload', :upload => :post

  # make steps send image data
#  map.step_image 'experiments/:experiment_id/steps/:id', :controller => 'steps', :action => 'image', :image => :get
 
  # default routes
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  

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
