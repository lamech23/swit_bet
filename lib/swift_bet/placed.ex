defmodule SwiftBet.Placed do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwiftBet.Repo
  alias SwiftBet.Accounts.User
  alias SwiftBet.Bets
  import Ecto.Query


  schema "slips" do
    belongs_to(:user, User)
    belongs_to(:bet, Bets)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(placed, attrs) do
    placed
    |> cast(attrs, [:bet_id, :user_id])
    |> validate_required([:bet_id, :user_id])
  end

  def create(params) do
    %__MODULE__{}
    |> change(params)
    |> Repo.insert()
  end


  def get_slips() do
    __MODULE__
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> Repo.preload(:user)
  end
  

  
end
