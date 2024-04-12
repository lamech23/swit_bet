defmodule SwiftBetWeb.Admin.ListUsersLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Accounts
  alias SwiftBet.Accounts.User
  alias SwiftBet.Repo

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
        <th class="px-4 py-2 font-medium text-gray-900">Actions</th>
      </tr>
    </thead>

    <%# Loop through users %>
    <%=for user <- @users do  %>
      <tbody class="divide-y divide-gray-200">
        <tr>
          <td class="px-4 py-2 text-gray-900"><%= user.first_name %></td>
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
            <button
              type="button"
              class="text-white bg-gradient-to-r from-green-400 via-green-500 to-green-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
              phx-click={JS.push("activate", value: %{"id" => user.id})}
            >
              Activate
            </button>
            <button
              type="button"
              class="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
              phx-click={JS.push("Deactivate", value: %{"id" => user.id})}
            >
              De-Activate
            </button>
            <a
              href="#"
              class="text-white bg-gradient-to-r from-red-400 via-red-500 to-red-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
              phx-click={JS.push("delete", value: %{"id" => user.id}) |> hide("##{user.id}")}
            >
              Delete
            </a>
          </td>
        </tr>
      </tbody>
    <% end %>
  </table>
</div>

    """
  end

  def mount(_session, _params, socket) do
    users =
      Accounts.list_users()
      |> IO.inspect()

    {:ok, assign(socket, users: users)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    post = Accounts.get_user!(id)
    Accounts.delete(post)

    {:noreply,
     socket
     |> put_flash(:info, "User deleted successfully")}
  end

  def handle_event("activate", %{"id" => id}, socket) do
    user = Repo.get(User, id)
    Accounts.soft_delete(user, %{status: "active"})

    {:noreply,
     socket
     |> put_flash(:info, "User Activated  Successfully!")}
  end

  def handle_event("Deactivate", %{"id" => id}, socket) do
    user = Repo.get(User, id)
    Accounts.soft_delete(user, %{status: "inActive"})

    {:noreply,
     socket
     |> put_flash(:info, "#{user.first_name} has been De-Activated.")}
  end
end
