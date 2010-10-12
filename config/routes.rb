ActionController::Routing::Routes.draw do |map|

  # Homepage route.
  map.root :controller => 'main'
  
  # Contact routes.
  map.contact 'contact', :controller => 'contact', :action => 'index', :conditions => { :method => :get }
  map.connect 'contact', :controller => 'contact', :action => 'create', :conditions => { :method => :post }
  
  # Session management routes.
  map.resource :user_session, :as => 'session'
  
  # Account routes.
  # This includes nice urls for pagination and sorting.
  map.connect '/accounts/page/:page/:c/:d', :controller => 'users', :action => 'index', :d => /(ASC|DESC)/
  map.connect '/accounts/page/:page', :controller => 'users', :action => 'index'
  map.connect '/accounts/:c/:d', :controller => 'users', :action => 'index', :d => /(ASC|DESC)/
  map.resources :users, :as => 'accounts', :path_names => { :new => 'signup'}, :member => {:unavatar => :put}
  
  # Admin routes.
  map.admin 'admin', :controller => 'admin', :action => 'index'
  map.namespace(:admin) do |admin|
    admin.connect '/users/page/:page/:c/:d', :controller => 'users', :action => 'index', :d => /(ASC|DESC)/
    admin.connect '/users/page/:page', :controller => 'users', :action => 'index'
    admin.connect '/users/:c/:d', :controller => 'users', :action => 'index', :d => /(ASC|DESC)/
    admin.resources :users, :member => {:demote_admin => :put, :create_admin => :put, :unavatar => :put, :activate => :put}
    admin.connect '/pages/page/:page/:c/:d', :controller => 'pages', :action => 'index', :d => /(ASC|DESC)/
    admin.connect '/pages/page/:page', :controller => 'pages', :action => 'index'
    admin.connect '/pages/:c/:d', :controller => 'pages', :action => 'index', :d => /(ASC|DESC)/
    admin.resources :pages
    admin.connect '/galleries/page/:page/:c/:d', :controller => 'galleries', :action => 'index', :d => /(ASC|DESC)/
    admin.connect '/galleries/page/:page', :controller => 'galleries', :action => 'index'
    admin.connect '/galleries/:c/:d', :controller => 'galleries', :action => 'index', :d => /(ASC|DESC)/
    admin.resources :galleries
    admin.connect '/images/:id/style/:preview', :controller => 'images', :action => 'show'
    admin.resources :images
    admin.edit_batch_images 'images/*ids/edit', :controller => 'images', :action => 'edit_batches', :conditions => { :method => :get }
    admin.update_batch_images 'images/*ids', :controller => 'images', :action => 'update_batches', :conditions => { :method => :put }
    admin.detroy_batch_images 'images/*ids', :controller => 'images', :action => 'destroy_batches', :conditions => { :method => :delete }
    admin.resources :pdfs
    admin.edit_batch_pdfs 'pdfs/*ids/edit', :controller => 'pdfs', :action => 'edit_batches', :conditions => { :method => :get }
    admin.update_batch_pdfs 'pdfs/*ids', :controller => 'pdfs', :action => 'update_batches', :conditions => { :method => :put }
    admin.detroy_batch_pdfs 'pdfs/*ids', :controller => 'pdfs', :action => 'destroy_batches', :conditions => { :method => :delete }
    admin.resources :contacts
    admin.detroy_batch_contacts 'contacts/*ids', :controller => 'contacts', :action => 'destroy_batches', :conditions => { :method => :delete }
  end
  
  # Password reset routes.
  map.resources :password_resets, :as => 'passwords', :only => [ :new, :create, :edit, :update ]
  
  # User activation route.
  map.activate '/activate/:activation_code', :controller => 'activations', :action => 'create'
  
  # Maintenance route.
  map.maintenance 'maintenance', :controller => 'main', :action => 'maintenance'
  
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
  # map.root :controller => "main"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
end
