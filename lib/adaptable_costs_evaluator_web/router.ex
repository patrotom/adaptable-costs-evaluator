defmodule AdaptableCostsEvaluatorWeb.Router do
  use AdaptableCostsEvaluatorWeb, :router

  alias AdaptableCostsEvaluatorWeb.Pipelines.{JWTAuthPipeline}

  pipeline :jwt_authenticated do
    plug JWTAuthPipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", AdaptableCostsEvaluatorWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    post "/sign_in", UserController, :sign_in
  end

  scope "/api/v1", AdaptableCostsEvaluatorWeb do
    pipe_through [:api, :jwt_authenticated]

    # Users
    resources "/users", UserController, except: [:create, :new, :edit]

    # Organizations
    resources "/organizations", OrganizationController, except: [:new, :edit]

    # Memberships
    get "/organizations/:organization_id/users", MembershipController, :index
    post "/organizations/:organization_id/users/:user_id", MembershipController, :create
    delete "/organizations/:organization_id/users/:user_id", MembershipController, :delete

    # Roles
    get "/organizations/:organization_id/users/:user_id/roles", RoleController, :index
    post "/organizations/:organization_id/users/:user_id/roles", RoleController, :create
    delete "/organizations/:organization_id/users/:user_id/roles", RoleController, :delete

    # Computations
    resources "/computations", ComputationController, except: [:new, :edit, :index] do
      # Formulas
      resources "/formulas", FormulaController, except: [:new, :edit]

      # Inputs
      resources "/inputs", InputController, except: [:new, :edit]
    end
    get "/organizations/:organization_id/computations", ComputationController, :index, as: :organization_computation
    post "/organizations/:organization_id/computations/:computation_id", ComputationController, :create
    delete "/organizations/:organization_id/computations/:computation_id", ComputationController, :delete
    get "/users/:creator_id/computations", ComputationController, :index, as: :user_computation

    # Field Schemas
    resources "/field-schemas", FieldSchemaController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: AdaptableCostsEvaluatorWeb.Telemetry
    end
  end
end
