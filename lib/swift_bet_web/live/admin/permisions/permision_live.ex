defmodule SwiftBetWeb.Permisions.PermisionsLive do
  use SwiftBetWeb, :live_view
  alias SwiftBet.Permissions
  use Phoenix.LiveView, layout: {SwiftBetWeb.Layouts, :admin}


  def render(assigns) do
    ~H"""
    <div class="w-full max-w-xl  mx-auto">
      <.simple_form
        :let={f}
        for={@form}
        id="premissions_form"
        phx-submit="create_permision"
        class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4"
      >
        <div class="mb-4">
          <.input
            field={f[:name]}
            type="text"
            label="Permisions "
            class="block py-2.5 px-0 w-full text-sm text-gray-900 bg-transparent border-0 border-b-2 border-gray-300 appearance-none dark:text-white dark:border-gray-600 dark:focus:border-blue-500 focus:outline-none focus:ring-0 focus:border-blue-600 peer"
            required
          />
        </div>

        <div class="flex items-center justify-between">
          <button
            type="submit"
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
          >
            Save
          </button>
        </div>
      </.simple_form>
    </div>
    """
  end

  def mount(_session, __params, socket) do
    changeset = Permissions.change_permission(%Permissions{})

    socket = assign(socket, :form, to_form(changeset))
    {:ok, socket}
  end

  def handle_event("create_permision", params, socket) do

    case Permissions.create(params) do
      {:ok, permission} ->
        socket= 
        socket
        |> put_flash(:info, "permission added")
        {:noreply, socket}


      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset)}
    end

    {:noreply, socket}
  end
end
