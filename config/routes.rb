Billing::Application.routes.draw do

  root :to => 'sessions#new'

  resources :invoices
  resources :exchange_rates, :only => [:edit, :update]

  resources :currencies do
    member do
      post :add_rate
    end
  end

  resources :dashboard, :only => [:show] do
    collection do
      get :show
    end
  end

  resources :functions, :only => [:show] do
    member do
      get :show
    end
  end

  resources :users do
    member do
      post :activate
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
      delete :signout
    end
  end

  resources :parties, :only => [] do
    resources :addresses, :only => [:new, :create, :show, :edit, :update]
    resources :contacts, :only => [:new, :create, :show, :edit, :update]
  end

  resources :documents, :only =>[] do
    resources :tags, :only => [:add] do
      collection do
        post  :add
      end
    end
  end

  resources :matters do
    resources :matter_tasks
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

  resources :customers, :except => [:destroy] do
    resources :addresses
    resources :contacts
    resources :individuals do
      resources :addresses
      resources :contacts
      collection do
        get   :choose
        post  :add
      end
    end
    collection do
      get :applicant_find_ajax
      get :agent_find_ajax
    end
  end
end
