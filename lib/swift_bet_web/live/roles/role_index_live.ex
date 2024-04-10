defmodule SwiftBetWeb.Roles.RoleIndexLive do
    use SwiftBetWeb, :live_view
    alias SwiftBet.Role.Roles
    def mount(_params, _session, socket)do
        roles = Roles.roles()

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