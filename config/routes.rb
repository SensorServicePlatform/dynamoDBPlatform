CmuSds::Application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => 'home#index'

  match 'dashboard' => 'home#dashboard', :as => "dashboard"

  #root :to => 'projects#index'
  resources :sensor_readings, :devices, :device_agents, :sensor_types, :device_types, :locations
  resources :sensors

  match '/get_devices' => 'devices#get_devices'
  match '/get_sensors' => 'sensor_types#get_sensors_by_type'
  match '/get_latest_reading' => 'sensor_readings#get_latest_reading'
  match ':controller(/:action(/:id))(.:format)'
end
