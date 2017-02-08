defmodule Chatter.Router do
  use Chatter.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Chatter do
    pipe_through :browser # Use the default browser stack
    coherence_routes()

    get "/", PageController, :index
    get "/welcome", PageController, :welcome
  end

  # Other scopes may use custom stacks.
  # scope "/api", Chatter do
  #   pipe_through :api
  # end
end
