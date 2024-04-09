defmodule SwiftBet.Bets do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :away, :string
    field :day, :date
    field :draw, :string
    field :home, :string
    field :teams, :string
    field :odds, {:array, :string}
    field :time, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bets, attrs) do
    bets
    |> cast(attrs, [:teams, :home, :draw, :away, :day, :odds, :time])
    |> validate_required([:teams, :home, :draw, :away, :day, :odds, :time])
  end
end
