defmodule SwiftBet.Bets do
  use Ecto.Schema
  import Ecto.Changeset
  alias SwiftBet.Repo
  import Ecto.Query

  alias SwiftBet.Accounts.User


  schema "bets" do
    field :away, :string
    field :day, :date
    field :draw, :string
    field :home, :string
    field :teams, :string
    field :stake, :string
    field :odds, :string
    field :status, :string, default: "open"
    field :time, :utc_datetime
    belongs_to(:user, SwiftBet.Users.User)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bets, attrs) do
    bets
    |> cast(attrs, [:teams, :home, :draw, :away, :day, :odds, :time, :stake, :user_id, :status])
    |> validate_required([:teams, :home, :draw, :away, :day, :odds, :time])
  end



  def get_user_bets(user_id) do
    from(record in __MODULE__,
    where: record.user_id == ^user_id,
    select: record
  )
  |> Repo.all()
  
  end

  def change_bets(%__MODULE__{} = bets, attrs\\ %{})do
    changeset(bets, attrs)

  end

  def cancel_bet(bets_ids) do
    bets_ids
    |>Enum.each(fn bet_id ->
      Repo.get!(__MODULE__, bet_id)
      |>change(%{status: "cancelled"})
      |> Repo.update()
    end)
  end
  
end
