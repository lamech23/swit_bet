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


  def get_slips(user_id) do
    query = from(p in __MODULE__, 
    where: p.user_id == ^user_id,
    select: p
    
    )
    |> Repo.all()
    |> Repo.preload(:bet)
  end



  def all_slips(user_id) do
    query = from(p in __MODULE__, 
    where: p.user_id == ^user_id,
    select: p
    
    )
    |> Repo.all()
    |> Repo.preload(:bet)
  end
  
  

  
end
