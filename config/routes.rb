Cogy::Engine.routes.draw do
  get "cmd/:cmd/:user" => 'cogy#command'
  get "inventory" => 'cogy#inventory'
end
