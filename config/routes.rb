Cogy::Engine.routes.draw do
  post "cmd/:cmd" => "cogy#command"
  get "inventory" => "cogy#inventory"
end
