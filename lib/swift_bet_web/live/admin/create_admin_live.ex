defmodule SwiftBetWeb.Admin.CreateAdminLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Accounts
  alias SwiftBet.Role.Roles
  alias SwiftBet.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto w-1/2  border p-4  rounded shadow shadow-2xl shadow-indigio-300 ">
      <.header class="text-center">
        Add User
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:first_name]} type="text" label="First Nmae" />
        <.input field={@form[:last_name]} type="text" label="Last Name" />
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:msisdn]} type="text" label="Msisdn" />
        <.input
          field={@form[:role_id]}
          type="select"
          label="Role"
          options={Enum.map(@role, &{ &1.name, &1.id})}
        />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})
    roles = Roles.roles()
    

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, role: roles)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    user_params
|> IO.inspect()
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
