defmodule SwiftBetWeb.Roles.RoleCreateLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Role.Roles
  alias SwiftBet.Permissions
  alias SwiftBet.RolePermissions
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}

  def render(assigns) do
    ~H"""
    <div class="text-center text-teal-200 text-lg  "></div>

    <.simple_form
      :let={f}
      for={@form}
      id="role_form"
      phx-submit="create_role"
      class="w-1/2 mx-auto  shadow-xl"
    >
      <div class="relative z-0 w-full mb-5 group">
        <.input
          field={f[:name]}
          type="text"
          label="Role"
          class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
          required
        />

        <div class="mb-6">
          <label class="block text-gray-700 text-sm font-bold mt-8 ">
            Permissions
          </label>
          <div class="grid grid-cols-2 gap-4">
            <%= for permission <- @permission do %>
              <div class="flex items-center">
                <.input
                  field={f[:permission]}
                  type="checkgroup"
                  id="permisions"
                  multiple={true}
                  options={[{permission.name, permission.id}]}
                />
              </div>
            <% end %>
          </div>
        </div>
      </div>

      <%= if @live_action==:new do %>
        <button
          type="submit"
          phx-disable-with="Creating..."
          class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
        >
          Create Role
        </button>
      <% else %>
        <button
          type="submit"
          phx-disable-with="Updating..."
          class="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm w-full sm:w-auto px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
        >
          <%= @desc_title %>
        </button>
      <% end %>
    </.simple_form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Roles.change_role(%Roles{})
    permission = Permissions.permissions()
    roles = Roles.roles()

    socket = assign(socket, :form, to_form(changeset))

    {:ok, assign(socket, roles: roles, permission: permission)}
  end


  @impl true
  def handle_event("create_role", role_params, socket) do
    changeset = Roles.change_role(%Roles{}) |> IO.inspect

    %{current_user: user} = socket.assigns

    role_params_with_user_id =
      role_params
      |> Map.put("user_id", user.id)

    role_params_with_user_id =
      Map.merge(role_params, %{"user_id" => role_params_with_user_id["user_id"]})

    case Roles.create(role_params_with_user_id) do
      {:ok, role} ->
        permissions = role.permission
        

        Enum.each(permissions, fn item ->
          case RolePermissions.create(%{role_id: role.id, permission_id: item}) do
            {:ok, _} ->
              socket
              |> put_flash(:info, "Role added successfully")
              |> redirect(to: "/root/roles/lists")

            {:error, changeset} ->
              {:noreply, assign(socket, changeset: changeset)}
          end
        end)

        socket =
          socket
          |> put_flash(:info, " role added  ")
          |> redirect(to: "/root/roles/lists")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    socket
    |> assign(:form, to_form(changeset))
  end

end
