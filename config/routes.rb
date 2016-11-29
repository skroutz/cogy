Cogy::Engine.routes.draw do
  post "cmd/:cmd/:user" => "cogy#command"
  get "inventory" => "cogy#inventory"
end
