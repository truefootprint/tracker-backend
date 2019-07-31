Rails.application.routes.draw do
  resources :company_rankings, only: :show,
    constraints: { id: CompanyRankingsController::ID_FORMAT }
end
