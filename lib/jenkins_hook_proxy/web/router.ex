defmodule JenkinsHookProxy.Web.Router do
  use JenkinsHookProxy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JenkinsHookProxy.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", JenkinsHookProxy.Web do
    pipe_through :api
#    resources "/callbacks", CallbackController, only: [:create]
    post "/callbacks/:host_id/:token", CallbackController, :create
  end
end
