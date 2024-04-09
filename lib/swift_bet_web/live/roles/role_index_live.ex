defmodule SwiftBetWeb.Roles.RoleIndexLive do
    use SwiftBetWeb, :live_view
    alias SwiftBet.Role.Roles
    def mount(_params, _session, socket)do
        roles = Roles.roles()

        {:ok, assign(socket, roles: roles)}

    end

    
end