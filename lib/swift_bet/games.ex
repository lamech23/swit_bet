defmodule SwiftBet.Games do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  # @type t :: %__MODULE__{away:String.t(), day:Date.t(), home:String.t(), draw:String.t(), away:String.t(), teams:String.t(), away:String.t(),   }
  alias SwiftBet.Account.User
  alias SwiftBet.Accounts
  alias SwiftBet.Repo
  alias SwiftBet.Bets
  alias SwiftBet.Accounts.UserNotifier

  schema "game" do
    field :away, :string
    field :day, :date
    field :draw, :string
    field :home, :string
    field :teams, :string
    field :time, :utc_datetime
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(games, attrs) do
    games
    |> cast(attrs, [:teams, :home, :draw, :away, :time, :day, :user_id])
    |> validate_required([:teams, :home, :draw, :away, :time, :day])
  end

  # @spec create(Map.t()) :: {:ok, t} | {:error, Ecto.Changeset.t()}

  def create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> Repo.insert()
  end

  # @spec update(t, Map.t()) :: {:ok, t} | {:error, Ecto.Changeset.t()}
  def update(games, params) do
    games
    |> changeset(params)
    |> Repo.update()
  end

  def change_games(%__MODULE__{} = game, attrs \\ %{}) do
    changeset(game, attrs)
  end

  def list_games() do
    query =
      from p in __MODULE__,
        order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  def get_game!(id) do
    Repo.get!(__MODULE__, id)
  end

  def delete_game(game) do
    Repo.delete(game)
  end

  def change_bet_status_to_lose() do
    bets_to_update =
      from(b in Bets,
        where: b.status == "open",
        select: b.id
      )
      |> Repo.all()

    bets_to_update
    |> Enum.each(fn bet_id ->
      bet = Repo.get!(Bets, bet_id)

      new_status =
        case Enum.random(["lose", "win"]) do
          "lose" -> "lose"
          "win" -> "win"
        end

      bet
      |> change(status: new_status)
      |> Repo.update()

      |> case do
        {:ok, bet} ->

        user =  Accounts.get_user!(bet.user_id)
         if bet.status == "lose" do 
          IO.puts "lose"
         UserNotifier.bet_lost(user)

         else
          IO.puts "win"
         UserNotifier.bet_won(user)

          

         end

          user =
            Accounts.get_user!(bet.user_id)
            |> UserNotifier.bet_lost(bet)
      end
    end)
  end


end
