defmodule SwiftBetWeb.Admin.CreateAdminLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Accounts
  alias SwiftBet.Role.Roles
  alias SwiftBet.Accounts.User
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}


  def render(assigns) do
    ~H"""
    <div class="mx-auto w-1/2  border p-4  rounded shadow shadow-2xl shadow-indigio-300 ">
      <.header class="text-center">
        <%= @page_title %>
      </.header>

      <.simple_form
        for={@changeset}
        :let={f}
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

        <.input field={f[:first_name]} type="text" label="First Name" disabled />
        <.input field={f[:last_name]} type="text" label="Last Name" disabled />
        <.input field={f[:email]} type="email" label="Email" required  disabled/>
        <.input field={f[:msisdn]} type="text" label="Msisdn" disabled/>
        <.input
          field={f[:role_id]}
          type="select"
          label="Role"
          options={Enum.map(@role, &{ &1.name, &1.id})}
        />
        <% if @live_action == :edit do %>
        <% else %>
        <.input field={f[:password]} type="password" label="Password" required />
        <% end %>


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


  def handle_params(params, _uri, socket) do

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  

  def handle_event("save", user_params, socket) do
    save_user(socket, socket.assigns.live_action, user_params)

  end

  defp save_user(socket, :new,  %{"user" => user_params} ) do
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

  defp save_user(socket, :edit,  %{"user" => user_params}) do

   id = socket.assigns.id |> String.to_integer()
  user = Accounts.get_user!(id )

  
    case Accounts.update(user, user_params) do
      {:ok, user} ->
        socket = 
        socket 
        |> put_flash(:info,  " updated ")
        {:noreply, socket }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket }
    end
  end



  defp apply_action(socket, :new, _params) do
    changeset = Accounts.change_user_registration(%User{})
    

    socket
    |> assign(:page_title, "Create New Game")
    |> assign(:user, %User{})
    |> assign(:changeset, changeset)
    |> assign(:desc_title, "Create ")
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    changeset = Accounts.get_user!(id)
    |> Accounts.change_user_registration()

    socket
    |> assign(:page_title, "Update   ")
    |> assign(:desc_title, "Update  User ")
    |> assign(:id, id)
    |> assign(:changeset, changeset)
    
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
