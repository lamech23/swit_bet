defmodule SwiftBetWeb.Admin.ListUsersLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Accounts
  alias SwiftBet.Accounts.User
  alias SwiftBet.Repo
  alias SwiftBet.RolePermissions
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}

  def render(assigns) do
    ~H"""
    <div class="overflow-x-auto">
      <table class="w-full divide-y-2 divide-gray-200 bg-white text-sm">
        <thead class="text-left">
          <tr>
            <th class="px-4 py-2 font-medium text-gray-900">First Name</th>
            <th class="px-4 py-2 font-medium text-gray-900">Last Name</th>
            <th class="px-4 py-2 font-medium text-gray-900">Email</th>
            <th class="px-4 py-2 font-medium text-gray-900">Account Status</th>
            <th class="px-4 py-2 font-medium text-gray-900">Msisdn</th>
            <th class="px-4 py-2 font-medium text-gray-900">Role</th>
            <th class="px-4 py-2 font-medium text-gray-900">Permisions</th>

            <th class="px-4 py-2 font-medium text-gray-900">Actions</th>
          </tr>
        </thead>

        <%= for user <- @users do %>
          <%= if @current_user.id  == user.id do %>
          <% else %>
            <tbody class="divide-y divide-gray-200">
              <tr>
                <td
                  class="px-4 py-2 text-gray-900 "
                  phx-click="user_bets"
                  phx-click={show_modal("user-games")}
                  phx-value-user_id={user.id}
                >
                  <%= user.first_name %>
                </td>
                <td class="px-4 py-2 text-gray-900"><%= user.last_name %></td>
                <td class="px-4 py-2 text-gray-900"><%= user.email %></td>
                <%= if user.status == "active"  do %>
                  <td class="px-4 py-2 text-gray-900 text-green-500"><%= user.status %></td>
                <% else %>
                  <td class="px-4 py-2 text-gray-900 text-red-500"><%= user.status %></td>
                <% end %>

                <td class="px-4 py-2 text-gray-900"><%= user.msisdn %></td>
                <td class="px-4 py-2 text-gray-900">
                  <%= if user.role do %>
                    <%= user.role.name %>
                  <% else %>
                    N/A
                  <% end %>
                </td>

               

                <td class="px-4 py-2">
                  <%= if @super_user == true do %>
                    <.link
                      patch={~p"/root/user/#{user}"}
                      }
                      class="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                    >
                      edit
                    </.link>
                  <% else %>
                  <% end %>

                  <%= if user.status == "active" do %>
                    <button
                      type="button"
                      class="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                      phx-click={JS.push("Deactivate", value: %{"id" => user.id})}
                    >
                      De-Activate
                    </button>
                  <% else %>
                    <button
                      type="button"
                      class="text-white bg-gradient-to-r from-green-400 via-green-500 to-green-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                      phx-click={JS.push("activate", value: %{"id" => user.id})}
                    >
                      Activate
                    </button>
                  <% end %>

                  <a
                    href="#"
                    class="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                    phx-click={JS.push("delete", value: %{"id" => user.id}) |> hide("##{user.id}")}
                  >
                    Delete
                  </a>

                  <button
                    type="button"
                    phx-click="user_bets"
                    phx-value-id={user.id}
                    class="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                  >
                    games
                  </button>

                  <button
                    type="button"
                    phx-click={show_modal("permission-Modal")}
                    phx-value-id={user.id}
                    class="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
                  >
                    permisions
                  </button>
                </td>
              </tr>
            </tbody>
          <% end %>
        <% end %>
      </table>
    </div>
    """
  end

  def mount(_session, _params, socket) do
    users =
      Accounts.list_users()
      |> IO.inspect()

    current_user = socket.assigns.current_user
    user = current_user.role
    # check_permission  = user.permission
    #  |> Enum.find( &(&1 == "super-user")) 
    RolePermissions.role_permision_list()

    super_user =
      socket.assigns.current_user.role.role_permisions
      |> Enum.map(fn item ->
        item.permission
      end)

      |> Enum.any?(fn item ->
        item.name == "super-user"
      end)
      |> IO.inspect(label: "Super-User")

    {:ok, assign(socket, users: users, super_user: super_user)}
  end

  def handle_event("check_permisions", %{"id" => id}, socket) do

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    post = Accounts.get_user!(id)
    Accounts.delete(post)

     socket= 
     socket 
     |> put_flash(:info, "User deleted successfully")
     |> push_redirect(to: "/root/users")

     {:noreply, socket }
  end

  def handle_event("activate", %{"id" => id}, socket) do
    user = Repo.get(User, id)
    Accounts.soft_delete(user, %{status: "active"})

    socket =
      socket
      |> put_flash(:info, "User Activated  Successfully!")
      |> push_redirect(to: "/root/users")

    {:noreply, socket}
  end

  def handle_event("Deactivate", %{"id" => id}, socket) do
    user = Repo.get(User, id)
    Accounts.soft_delete(user, %{status: "inActive"})

    socket =
      socket
      |> put_flash(:info, "#{user.first_name} has been De-Activated.")
      |> push_redirect(to: "/root/users")

    {:noreply, socket}
  end

  def handle_event("user_bets", %{"id" => id}, socket) do
    bet_slips =
      id
      |> String.to_integer()

    {:noreply,
     socket
     |> redirect(to: "/root/users-bets/#{id}")}
  end


 
end
