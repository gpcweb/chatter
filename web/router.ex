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

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    coherence_routes
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", Chatter do
    pipe_through :browser # Use the default browser stack

    get "/", WelcomeController, :index
  end

  scope "/", Chatter do
    pipe_through :protected

    get "/lobby", ChattController, :lobby
  end

  # Other scopes may use custom stacks.
  scope "/api", Chatter do
    pipe_through :api

    post "/log_in", UserController, :log_in
  end
end
