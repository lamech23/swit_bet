defmodule SwiftBet.RolePermissions do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwiftBet.Role.Roles
  alias SwiftBet.Permissions
  alias SwiftBet.Repo
  import Ecto.Query


  schema "permisions_ids" do
    # field :permission_id, :integer
    # field :role_id, :integer
    belongs_to(:role, Roles)
    belongs_to(:permission, Permissions)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role_permissions, attrs) do
    role_permissions
    |> cast(attrs, [:role_id, :permission_id])

    |> validate_required([])
  end



  def create(params) do
    %__MODULE__{}
    |> change(params)
    |> Repo.insert()
  end


  def role_permision_list() do
    query  = from(p in __MODULE__,
    select: p)
    |> Repo.all()
    |> Repo.preload(:permission)
    |> Repo.preload(:role)
  
    


    

  end

  
end
