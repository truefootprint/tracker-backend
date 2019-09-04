Rails.application.routes.draw do
  get "company_rankings/:sector/:distribution/:threshold/:year/outcome/:id", to: "company_rankings#outcome"
  get "company_rankings/:sector/:distribution/:threshold/:year/group/:id", to: "company_rankings#group"
  get "company_rankings/:sector/:distribution/:threshold/:year/company/:id", to: "company_rankings#company"

  get "company_rankings/:sector/:distribution/:threshold/all/history/:id", to: "company_rankings#history",
    constraints: { id: CompanyRankingsController::ID_FORMAT }

  get "company_rankings/:sector/:distribution/:threshold/:year/history/:id", to: "company_rankings#show",
    constraints: { id: CompanyRankingsController::ID_FORMAT }

  get "company_rankings/:sector/:distribution/:threshold/all/compare/:id", to: "company_rankings#compare",
    constraints: { id: CompanyRankingsController::ID_FORMAT }

  get "ancestry/:type/:id", to: "ancestry#show"
  get "parents/:type/:id", to: "ancestry#parents"
  get "ancestors/:type/:id", to: "ancestry#ancestors"
  get "children/:type/:id", to: "ancestry#children"
  get "descendents/:type/:id", to: "ancestry#descendents"

  resources :companies, only: :show
end
