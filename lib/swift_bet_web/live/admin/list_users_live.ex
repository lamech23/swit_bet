defmodule SwiftBetWeb.Admin.ListUsersLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Accounts
  alias SwiftBet.Accounts.User
  alias SwiftBet.Repo

  def render(assigns) do
    ~H"""
    <!--
  Heads up! 👋

  This component comes with some `rtl` classes. Please remove them if they are not needed in your project.
-->

<div class="overflow-x-auto">
  <table class="w-full  divide-y-2 divide-gray-200 bg-white text-sm">
    <thead class="ltr:text-left rtl:text-right">
      <tr>
        <th class="whitespace-nowrap px-4 py-2 font-medium text-gray-900">First Name</th>
        <th class="whitespace-nowrap px-4 py-2 font-medium text-gray-900">Last Name</th>
        <th class="whitespace-nowrap px-4 py-2 font-medium text-gray-900">Email</th>
        <th class="whitespace-nowrap px-4 py-2 font-medium text-gray-900">Account Status</th>
        <th class="whitespace-nowrap px-4 py-2 font-medium text-gray-900">Msisdn</th>
        <th class="whitespace-nowrap px-4 py-2 font-medium text-gray-900">Role</th>
        <th class="whitespace-nowrap px-4 py-2 font-medium text-gray-900">Actions</th>
      </tr>
    </thead>
    


<%=  for user <- @users do  %>
    <tbody class="divide-y divide-gray-200">
      <tr>
        <td class="whitespace-nowrap px-4 py-2 font-medium text-gray-900"><%= user.first_name %></td>
        <td class="whitespace-nowrap px-4 py-2 text-gray-700"><%= user.last_name %></td>
        <td class="whitespace-nowrap px-4 py-2 text-gray-700"><%= user.email %></td>
        <td class="whitespace-nowrap px-4 py-2 text-gray-700"><%= user.status %></td>
        <td class="whitespace-nowrap px-4 py-2 text-gray-700"><%= user.msisdn %></td>
        <td class="whitespace-nowrap px-4 py-2 text-gray-700"><%= user.roles %></td>
        <td class="whitespace-nowrap px-4 py-2">
          <a
            href="#"
            class="inline-block rounded bg-green-600 px-4 py-2 text-xs font-medium text-white hover:bg-green-700"
          >
            edit
          </a>

          <button
      type="button"
      class="  text-white bg-gradient-to-r from-green-400 via-green-500 to-green-600 hover:bg-gradient-to-br focus:ring-4 focus:outline-none focus:ring-green-300 dark:focus:ring-green-800 font-medium rounded-lg text-sm px-5 py-2.5 text-center me-2 mb-2"
      phx-click={JS.push("activate", value: %{"id"=> user.id})} 
    >
      Activate
    </button>
          <a
            href="#"
            class="inline-block rounded bg-red-600 px-4 py-2 text-xs font-medium text-white hover:bg-red-700"
            phx-click={JS.push("delete", value: %{"id"=> user.id}) |> hide("##{user.id}")}



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
     users =  Accounts.list_users()


    {:ok, assign(socket, users: users )}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    post = Accounts.get_user!(id)
    Accounts.delete(post)

    {:noreply,
     socket
     |> put_flash(:info, "User deleted successfully")}
  end

  def handle_event("activate", %{"id"=> id}, socket) do
    user = Repo.get(User,  id)
    Accounts.soft_delete(user, %{ status: "active"})

    {:noreply,
     socket
     |> put_flash(:info, "User Activated  Successfully!")
    }
  end


end
