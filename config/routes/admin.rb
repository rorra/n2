N2::Application.routes.draw do
  namespace :admin do
    match '/block.:format' => 'misc#block', :as => :block
    match '/flag_item.:format' => 'misc#flag', :as => :flag_item
    match '/feature.:format' => 'misc#feature', :as => :feature
    match '/featured_items/:id/load_items/page/:page' => 'featured_items#load_items', :as => :feature
    match '/translations.:format' => 'translations#translations', :as => :translations
    match '/asset_translations.:format' => 'translations#asset_translations', :as => :asset_translations

    resources :activity_scores
    resources :ad_layouts
    resources :ads
    resources :announcements
    resources :answers
    resources :cards do
      collection do
        get :search
        post :search
      end
    end
    resources :classifieds do
      collection do
        get :search
        post :search
      end
    end
    resources :comments do
      collection do
        get :search
        post :search
      end
    end
    resources :content_dashboard do
      collection do
        get :news_topics
        post :news_topics
        put :news_topics
      end
    end

    resources :content_images
    resources :contents do
      collection do
        get :search
        post :search
      end
    end

    resources :dashboard_messages do
      member do
        post :send_global
        get :send_global
        get :clear_global
        post :clear_global
      end
      collection do
        get :clear_global
        post :clear_global
      end
    end


    resources :events do
      collection do
        get :import_zvents
        post :import_zvents
        get :search
        post :search
      end
    end


    resources :featured_items do
      member do
        get :load_template
        post :load_template
        get :load_new_template
        post :load_new_template
        get :load_items
        post :load_items
      end
      collection do
        post :save
        get :new_featured_widgets
        post :save_featured_widgets
      end
    end

    resources :feeds do
      member do
        get :fetch_new
      end
      collection do
        get :search
        post :search
      end
    end
    resources :flags do
      collection do
        get :search
        post :search
      end
    end
    resources :forums do
      collection do
        get :reorder
        post :reorder
        get :search
        post :search
      end
    end
    resources :galleries do
      collection do
        get :search
        post :search
      end
    end
    resources :gallery_items do
      collection do
        get :search
        post :search
      end
    end
    resources :gos do
      collection do
        get :search
        post :search
      end
    end
    resources :idea_boards
    resources :ideas
    resources :images
    resources :locales do
      collection do
        get :refresh
      end
      resources :translations
    end

    resources :menu_items do
      collection do
        post :save
      end
    end
    
    resources :newswires do
      collection do
        get :search
        post :search
      end
    end
    resources :prediction_groups do
      member do
        get :approve
        post :approve
      end
    end
    resources :prediction_guesses
    resources :prediction_questions do
      member do
        get :approve
        post :approve
      end
    end

    resources :prediction_results do
      member do
        get :accept
        post :accept
      end
    end
    resources :prediction_scores do
      collection do
        get :refresh_all
        post :refresh_all
      end
    end
    resources :questions
    resources :related_items do
      collection do
        get :search
        post :search
      end
    end
    resources :resource_sections do
      collection do
        get :search
        post :search
      end
    end
    resources :resources do
      collection do
        get :search
        post :search
      end
    end
    resources :settings
    resources :setting_groups
    resources :skip_images
    resources :sources do
      collection do
        get :search
        post :search
      end
    end
    resources :sponsor_zones
    resources :title_filters
    resources :topics do
      collection do
        get :search
        post :search
      end
    end
    resources :tweet_streams do
      member do
        get :fetch_new_tweets
      end
      collection do
        get :search
        post :search
      end
    end

    resources :tweets do
      collection do
        get :search
        post :search
      end
    end
    resources :tweet_accounts do
      collection do
        get :search
        post :search
      end
    end
    resources :twitter_settings do
      collection do
        post :update_keys
        post :update_auth
        get :reset_keys
      end
    end
    resources :user_profiles,      :active_scaffold => true
    resources :users,           :active_scaffold => true
    resources :view_objects do
      collection do
        get :search
        post :search
      end
    end
    resources :view_object_templates do
      collection do
        get :search
        post :search
      end
    end
    resources :votes,           :active_scaffold => true

    resources :widgets do
      collection do
        post :save
        get :new_widgets
        get :newer_widgets
        post :save_newer_widgets
      end
    end

    namespace :metadata do
      resources :activity_scores
      resources :ad_layouts
      resources :ads
      resources :custom_widgets
      resources :settings
      resources :skip_images
      resources :sponsor_zones
      resources :title_filters
    end
  end

  match 'admin' => "admin#index"
end
