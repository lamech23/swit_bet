defmodule SwiftBet.Role.Roles do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwiftBet.Repo
  import Ecto.Query
  alias SwiftBet.Accounts
  alias SwiftBet.Permissions
  alias SwiftBet.RolePermissions
  alias SwiftBet.Accounts.User

  schema "roles" do
    field :name, :string
    field :permission, {:array, :integer}, default: []
    field(:permission_ids,  {:array, :integer}, virtual: true)
    has_many :role_permisions, RolePermissions, foreign_key: :role_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(roles, attrs) do
    roles
    |> cast(attrs, [:name, :permission_ids, :permission])
    |> handle_permission_ids(attrs)
    |> cast_assoc(:role_permisions)
    |> validate_required([:name])
   

  end

defp handle_permission_ids(changeset, _attrs) do
  changeset |> IO.inspect(label: "handle permission ids")
  case changeset do
    %Ecto.Changeset{valid?: true, changes: %{permissions: permissions}} ->
      put_change(changeset, :permissions, permissions)
      # |> IO.inspect(label: "handle_permission_ids")
    _ ->
      changeset
  end
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
    |> IO.inspect(label: "CHANGESET")
    |> Repo.update()
  end


  def get_role!(id) do
    Repo.get!(__MODULE__, id)
    |> Repo.preload(role_permisions: [:permission])
    |> combine_role_and_permissions()


  end


  defp combine_role_and_permissions(role) do
    permissions = Enum.map(role.role_permisions, &(&1.permission.id))
    %{role | permission_ids: permissions}
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
