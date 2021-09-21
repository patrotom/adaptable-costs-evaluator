defmodule AdaptableCostsEvaluatorWeb.Router do
  use AdaptableCostsEvaluatorWeb, :router

  alias AdaptableCostsEvaluatorWeb.Pipelines.{JWTAuthPipeline}

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :jwt_authenticated do
    plug JWTAuthPipeline
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AdaptableCostsEvaluatorWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", AdaptableCostsEvaluatorWeb do
    pipe_through :api

    resources "/users", UserController, only: [:create]
    post "/sign_in", UserController, :sign_in
  end

  scope "/api/v1", AdaptableCostsEvaluatorWeb do
    pipe_through [:api, :jwt_authenticated]

    resources "/users", UserController, except: [:create]
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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AdaptableCostsEvaluatorWeb.Telemetry
    end
  end
end
