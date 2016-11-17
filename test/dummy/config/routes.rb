Rails.application.routes.draw do
  mount Cogy::Engine => "/cogy"

  get "baz" => "cogy#cmd"
end
