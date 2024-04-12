defmodule SwiftBet.Permissions do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias SwiftBet.Repo

  # @allowed_permissions ~w(create edit delete)
  schema "permissions" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(permissions, attrs) do
    permissions
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert()
  end

  def permissions() do
    query =
      from p in __MODULE__,
        order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  def change_permission(%__MODULE__{} = role, attrs \\ %{}) do
    changeset(role, attrs)
  end
end
