defmodule SwiftBetWeb.Roles.RoleLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Role.Roles
  alias SwiftBet.Permissions
  alias SwiftBet.RolePermissions
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}

  @impl true
  def mount(_params, _session, socket) do
    changeset = Roles.change_role(%Roles{})
    permission = Permissions.permissions()
    roles = Roles.roles()

    socket = assign(socket, :form, to_form(changeset))

    {:ok, assign(socket, roles: roles, permission: permission)}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("create_role", role_params, socket) do
    create_role(socket, socket.assigns.live_action, role_params)
  end

  @impl true
  defp create_role(socket, :new, %{"roles" => role_params}) do
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
        {:noreply, assign(socket, changeset: changeset )}
    end
  end

  @impl true
  defp create_role(socket, :edit, %{"roles" => role_params}) do
    role_params
    # |> IO.inspect(label: "ROLE PARAMS ONE  ")

    roles = socket.assigns.role
    # |> IO.inspect(label: "ROLE PARAMS TWO   ")


    case Roles.update(roles, role_params)  do
      {:ok, _role} ->
        
        socket =
          socket
          |> put_flash(:info, " role updated ")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "All Roles")
  end

  defp apply_action(socket, :new, _params) do
    changeset = Roles.change_role(%Roles{})

    socket
    |> assign(:page_title, "Create New Role")
    |> assign(:role, %Roles{})
    |> assign(:changeset, changeset)
    |> assign(:desc_title, "Create ")
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    role =
      Roles.get_role!(id)
      # |> IO.inspect()

    changeset = Roles.change_role(role)

    socket
    |> assign(:page_title, "Update  ")
    |> assign(:desc_title, "Update  Role ")
    |> assign(:role, role)
    |> assign(:changeset, changeset)
  end

  # validate 
  def handle_event("validate", role_params, socket) do
    changeset =
      socket.assigns.role
      |> Roles.changeset(role_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  # defp assign_form(socket, %Ecto.Changeset{} = changeset) do
  #   socket
  #   |> assign(:form, to_form(changeset))
  # end
end
