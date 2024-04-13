defmodule SwiftBet.Bets do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias SwiftBet.Repo

  alias SwiftBet.Accounts.User


  schema "bets" do
    field :away, :string
    field :day, :date
    field :draw, :string
    field :home, :string
    field :teams, :string
    field :stake, :string
    field :odds, :string
    field :slip_id, :integer
    field :status, :string, default: "open"
    field :total_payout, :string
    field :selected, :string
    field :time, :utc_datetime
    belongs_to(:user, SwiftBet.Users.User)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bets, attrs) do
    bets
    |> cast(attrs, [:teams, :home, :draw, :away, :day, :odds, :time, :stake, :user_id, :status, :slip_id, :total_payout, :selected])
    |> validate_required([:teams, :home, :draw, :away, :day, :odds, :time])
  end



  def get_user_bets(slip_id) do
    from(record in __MODULE__,
    where: record.slip_id == ^slip_id,
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

  def update_slip_id(bet, slip_id) do
    bet
    |> changeset(%{slip_id: slip_id})
    |> Repo.update()
  end
  
end
