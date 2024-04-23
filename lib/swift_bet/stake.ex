defmodule SwiftBet.Stake do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias SwiftBet.Accounts.User
  alias SwiftBet.Repo

  schema "stakes" do
    field :name, :integer, default: 0
    belongs_to(:user, User)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(stake, attrs) do
    stake
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name])
  end


  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert()
  end

  def deposit(user_id) do
    query =
      from(p in __MODULE__,
        where: p.user_id == ^user_id,
        order_by: [desc: p.inserted_at],
        limit: 1,
        select: p.name
      )
    Repo.one(query)
  end



  def deposits(user_id) do
    query =
      from(p in __MODULE__,
        where: p.user_id == ^user_id,
        order_by: [desc: p.inserted_at],
        limit: 1,
        select: p
      )
    Repo.one(query)
  end

  def update(stake, name) do
    stake
    |> changeset(%{name: name})
    |> Repo.update()
  end

  

end
