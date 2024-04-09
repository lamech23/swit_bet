defmodule SwiftBet.Games do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
# @type t :: %__MODULE__{away:String.t(), day:Date.t(), home:String.t(), draw:String.t(), away:String.t(), teams:String.t(), away:String.t(),   }
  alias SwiftBet.Account.User
  alias SwiftBet.Repo

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
    |> cast(attrs, [:teams, :home, :draw, :away, :time, :day])
    |> validate_required([:teams, :home, :draw, :away, :time, :day])
  end

  # @spec create(Map.t()) :: {:ok, t} | {:error, Ecto.Changeset.t()}

  def create(params)do
    %__MODULE__{}
    |>changeset(params)
    |> Repo.insert()

  end 

  # @spec update(t, Map.t()) :: {:ok, t} | {:error, Ecto.Changeset.t()}
  def update(games, params) do
    games
    |> changeset(params)
    |> Repo.update()
  end

  def change_games(%__MODULE__{} = game, attrs\\ %{})do
    changeset(game, attrs)

  end

  def list_games()do
    query =
    from p in __MODULE__,
    order_by: [desc: :inserted_at]
    Repo.all(query)
  end


  def get_game!(id) do
    Repo.get!(__MODULE__, id)
  end




end
