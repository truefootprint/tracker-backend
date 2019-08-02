Rails.application.routes.draw do
  resources :company_rankings, only: :show,
    constraints: { id: CompanyRankingsController::ID_FORMAT }

  get "ancestry/:type/:id", to: "ancestry#show"
  get "parents/:type/:id", to: "ancestry#parents"
  get "ancestors/:type/:id", to: "ancestry#ancestors"
  get "children/:type/:id", to: "ancestry#children"
  get "descendents/:type/:id", to: "ancestry#descendents"
end
