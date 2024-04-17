defmodule SwiftBetWeb.Router do
  use SwiftBetWeb, :router

  import SwiftBetWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SwiftBetWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SwiftBetWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", SwiftBetWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:swift_bet, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SwiftBetWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", SwiftBetWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{SwiftBetWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit

    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", SwiftBetWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{SwiftBetWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end

  end
  scope "/user", SwiftBetWeb do
    pipe_through [:browser]

    live_session :current_users,
    on_mount: [{SwiftBetWeb.UserAuth, :mount_current_user}, {SwiftBetWeb.UserAuth, :ensure_authenticated}] do


    live("/home",Home.HomeLive, :new)
    live("/bet-slip",BetSlip.BettingSlipLive, :index)
    live("/bet-history/:id",BetSlip.BetHistoryLive, :index)
    get "/users/log_out", UserSessionController, :delete




end
end

  

  scope "/root", SwiftBetWeb do
    pipe_through [:browser]


    live_session :current_user,
      on_mount: [{SwiftBetWeb.UserAuth, :mount_current_user}, {SwiftBetWeb.UserAuth, :ensure_authenticated},  {SwiftBetWeb.UserAuth, :admin_auth}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new

      live("/add-game",Games.GameLive, :new)
      live("/game/:id",Games.GameLive, :edit)
      live("/user/:id",Admin.CreateAdminLive, :edit)
      
      live("/list",Games.GameIndexLive, :index)
      live("/analytics",Admin.AnalyticsLive, :index)
      live("/roles",Roles.RoleLive, :new)
      live("/role/:id/edit",Roles.RoleLive, :edit)
      live("/roles/lists",Roles.RoleIndexLive, :index)
      live("/roles/create",Roles.RoleLive, :new)
      live("/create-user",Admin.CreateAdminLive, :new)
      live("/users",Admin.ListUsersLive, :index)
      live("/permisions",Permisions.PermisionsLive, :index)
      live("/users-bets/:id",BetSlip.SpecificUserBetsLive, :index)

    end
  end
end
