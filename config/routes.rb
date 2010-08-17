ActionController::Routing::Routes.draw do |map|
  map.resources :sections

  map.resources :glossaries

  map.resources :definitions

  map.resources :encyclopaedias do |encyclopaedias|
     encyclopaedias.resources :sections,
       :member => { :upload => :put}
  end

  #map.upload '/upload', :controller =>'sections', :action => 'upload', :encyclopaedia_id => '1'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.forgot '/forgot', :controller => 'users', :action => 'forgot'
  map.reset 'reset/:reset_code', :controller => 'users', :action => 'reset'
  map.new_email 'users/:id/new_email/:key', :controller => 'users', :action => 'activate_email'

 
  # print to pdf
  map.print '/print', :controller => 'print', :action => 'print', :method => :post 
  
  
  # normal user routes
  map.resources :users, :member=>{:new_email=>:put}
  
  # group routes
  map.resources :groups, :member => { :upload => :post, :join => :get, :join_with_key=>:post, :request_to_join => :post , :quit=>:delete, :new_key=>:put, :change_role=>:put, :kick_out=>:delete } do |groups|
	  groups.resources :messages, :only=>[ :index,:create,:destroy,:update ]
  end


    map.resources :viewer


  #TODO validate_sequence probably shoudn't be a GET request?
  #->Use button-to
  map.resources :requests, :only => ['destroy'], :member=>{:accept => :post, :reject=>:post}



  #map annoations as nested resource of biobytes
  map.resources :bio_bytes, :member => { :upload => :post, 
                                        :upload_desc_img => :post, 
                                        :update => :post,
                                        :upload_abi => :post,
                                        :download_vf => :get,
                                        :download_vr => :get,
                                        :validate_sequence => :get } do |bytes|
    bytes.resources :annotations
  end

  map.resources :orfs, :controller => :bio_bytes
  map.resources :linkers, :controller => :bio_bytes

  map.resource :session


    # nest note in steps without nesting steps in experiment
  map.resources :steps do |steps|
     steps.resource  :note, :member => { :upload => :post }
  end

  map.resources :glossaries

  # map steps as nested resource of experiments
  map.resources :experiments, :member => { :print => :get,
                                           :clone => :get,
 					   :set_status => :post } do |experiments|
     experiments.resources :steps, 
	     :member => { :upload => :post, 
	     		  :up => :put,
    			  :down => :put,
    			  :insert_after => :put,
                          :insert_before => :put }
     experiments.resources :constructs
  end 

  map.resources :step_generators


  # named route for getting part data for construct/experiment views
  map.part_data '/get_part_data', :controller => :constructs, :action => :get_data
  map.save_construct '/save_construct', :controller => :constructs, :action => :save
  # some shorthand for routes
  map.move_step_up 'experiments/:experiment_id/steps/:id/up' , :controller => :steps, :action =>:up
  map.move_step_down 'experiments/:experiment_id/steps/:id/down', :controller => :steps, :action =>:down

  map.root :controller => :home 
  map.home '', :controller => :home

  # routes for images
  map.resources :images, :member => { :thumb => :get, :step => :get , :section => :get }
  
  
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
