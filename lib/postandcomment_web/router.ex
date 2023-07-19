defmodule PostandcommentWeb.Router do
  use PostandcommentWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PostandcommentWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PostandcommentWeb.Plugs.SetUser
  end


  pipeline :authenticated do
    plug PostandcommentWeb.Plugs.RequireAuth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PostandcommentWeb do
    pipe_through :browser
    # get "/", PageController, :home
    live "/", Post.IndexLive

    live "/registration", User.SignupLive
    live "/login", User.LoginLive

    get "/:token/login", SessionController, :login
    get "/:token/verify/user", EmailController, :verify
  end

  scope "/", PostandcommentWeb do
    pipe_through [:browser, :authenticated]
    get "/logout", SessionController, :logout
    live "/profile", User.UpdateLive
    live "/post", Post.CreateLive
    live "/post/:id", Comment.CreateLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", PostandcommentWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:postandcomment, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PostandcommentWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
