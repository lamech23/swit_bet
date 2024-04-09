defmodule SwiftBet.Role.Roles do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwiftBet.Repo
  import Ecto.Query

  schema "roles" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(roles, attrs) do
    roles
    |> cast(attrs, [:name])
    |> validate_required([:name])

  end




  def create(params)do
    %__MODULE__{}
    |>changeset(params)
    |> Repo.insert()

  end 

  # @spec update(t, Map.t()) :: {:ok, t} | {:error, Ecto.Changeset.t()}
  def update(roles, params) do
    roles
    |> changeset(params)
    |> Repo.update()
  end


  def get_role!(id) do
    Repo.get!(__MODULE__, id)
    # |>  Repo.preload(:user)
  end


  def roles()do
    query =
    from p in __MODULE__,
    order_by: [desc: :inserted_at]
    Repo.all(query)
  end

  def delete(role) do
    Repo.delete(role)
  end


  def change_role(%__MODULE__{} = role, attrs\\ %{})do
    changeset(role, attrs)

  end
end
