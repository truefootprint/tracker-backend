Rails.application.routes.draw do
  get "company_rankings/:sector/:year/outcome/:id", to: "company_rankings#outcome"
  get "company_rankings/:sector/:year/group/:id", to: "company_rankings#group"
  get "company_rankings/:sector/:year/company/:id", to: "company_rankings#company"

  get "ancestry/:type/:id", to: "ancestry#show"
  get "parents/:type/:id", to: "ancestry#parents"
  get "ancestors/:type/:id", to: "ancestry#ancestors"
  get "children/:type/:id", to: "ancestry#children"
  get "descendents/:type/:id", to: "ancestry#descendents"

  resources :companies, only: :show
end
