defmodule IdeaPoolWeb.Router do
  use IdeaPoolWeb, :router

  alias IdeaPoolWeb.Accounts.AuthPipeline

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug AuthPipeline
  end

  scope "/", IdeaPoolWeb do
    pipe_through :api

    post "/users", UserController, :create
    post "/access-tokens", TokenController, :login
    post "/access-tokens/refresh", TokenController, :refresh
  end

  scope "/", IdeaPoolWeb do
    pipe_through [:api, :auth]

    get "/me", UserController, :show
    delete "/access-tokens", TokenController, :logout
    resources "/ideas", IdeaController, only: [:create, :update, :delete, :index]
  end
end
