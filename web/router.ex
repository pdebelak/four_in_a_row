defmodule Four.Router do
  use Four.Web, :router

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

  scope "/", Four do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/games", GameController, except: [:index, :new, :edit, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Four do
  #   pipe_through :api
  # end
end
