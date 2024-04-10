defmodule SwiftBet.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string
      add :permission, {:array, :string}, default: []
      add :user_id, references(:users)


      timestamps(type: :utc_datetime)
    end
  end
end
