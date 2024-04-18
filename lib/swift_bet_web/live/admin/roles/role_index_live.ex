defmodule SwiftBetWeb.Roles.RoleIndexLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Role.Roles
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}

  def mount(_params, _session, socket) do
    roles = Roles.roles()

    user = socket.assigns.current_user.role

    # check_permission =
    #   user.permission
    #   |> Enum.find(&(&1 == "super-user"))

    {:ok, assign(socket, roles: roles)}
  end

  def handle_event("delete_role", %{"id" => id}, socket) do
    role = Roles.get_role!(id)
    Roles.delete(role)

    {:noreply,
     socket
     |> put_flash(:info, "role  deleted successfully")}
  end
end
