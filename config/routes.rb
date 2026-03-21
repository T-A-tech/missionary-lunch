Rails.application.routes.draw do
  root "sessions#new"

  # Autenticação
  get    "login",    to: "sessions#new"
  post   "login",    to: "sessions#create"
  delete "logout",   to: "sessions#destroy"

  # Cadastro do líder
  get  "register", to: "registrations#new"
  post "register", to: "registrations#create"

  # Dashboard do líder (autenticado)
  get   "dashboard",             to: "dashboard#index",          as: :dashboard
  patch "dashboard/ward",        to: "dashboard#update_ward",    as: :dashboard_ward
  get   "dashboard/appointments",to: "dashboard#appointments",   as: :dashboard_appointments
  delete "dashboard/appointments/:id", to: "dashboard#destroy_appointment", as: :dashboard_appointment

  # Página pública da ala/ramo (via token)
  get  "w/:token",              to: "public#show",   as: :public_ward
  post "w/:token/appointments", to: "public#create", as: :public_appointments
end
