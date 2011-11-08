Billing::Application.routes.draw do

  resources :messages

  resource :account, :controller => :activation, :only => [:show, :activate] do
    member do
      put :activate
    end
  end
      
  resource :profile, :except => [:new, :destroy] do
    member do
      get :show_password
      put :change_password
    end        
  end  

  resources :invoices   do
    member do
      put :process_lines
      delete :remove_line
      put :flow
    end
    collection do
      post :filter 
      delete :reset
    end
    resource :pdf, :controller => "InvoicePreviews", :only => [:show, :preview] do
      collection do
        get :show
        get :preview
      end
    end
  end

  resources :currencies 

  resources :invoice_line_presets
  resources :official_fee_types
  resources :attorney_fee_types

  resources :matters do
    member do
      get   :find_ajax
      post  :link
      post   :add_image
      put :flow
    end
    collection do
      post :filter
      delete :reset
    end
    resources :invoices, :only => [:new]
    resources :tasks, :controller => "MatterTasks" do
      member do
        put :flow
      end
      resources :invoices, :only => [:new]
    end
    resources :matters, :only => [:new, :create, :add, :choose] do
      collection do
        get   :choose
        post  :add
      end
      member do
        get   :remove
      end
    end
  end

  resources :operating_parties, :except => [:destroy] do
    resources :accounts    
    resources :addresses
    resources :contacts
    member do
      get  :choose_matter_type      
      post :add_matter_type 
    end
  end

  resources :customers, :except => [:destroy] do
    resources :accounts    
    resources :contact_persons do
      resources :addresses
      resources :contacts
    end
    resources :addresses
    resources :contacts
    collection do
      get :applicant_find_ajax
      get :agent_find_ajax
      get :list_addresses
      get :list_contact_persons
    end
  end

  root :to => 'sessions#new'

  resources :dashboard, :only => [:show, :message] do
    collection do
      get :show
      post :filter
      delete :reset
    end
    member do
      get :message
    end
  end

  resources :functions, :only => [:show] do
    member do
      get :show
    end
  end

  resources :users do
    resources :addresses
    resources :contacts
    member do
      get :activate
      post :block
    end
    resources :roles, :only => [:choose, :add, :remove] do
      collection do
        get :choose
        post :add
      end
      member do
        delete :remove
      end
    end
  end

  resources :roles do
    resources :functions, :only => [:index, :choose, :add, :show] do
      collection do
        get :index
        get :choose
        post :add
      end
      member do
        get :show
      end
    end
  end

  resources :sessions, :only => [:new, :signin, :signout] do
    collection do
      get :new
      post :signin
      get :signout
    end
  end

  resources :documents, :only =>[] do
    resources :tags, :only => [:add] do
      collection do
        post  :add
      end
    end
  end

end
