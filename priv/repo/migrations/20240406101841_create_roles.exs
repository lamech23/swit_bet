defmodule SwiftBet.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string
      add :permission, {:array, :integer}, default: []


      timestamps(type: :utc_datetime)
    end
  end
end
