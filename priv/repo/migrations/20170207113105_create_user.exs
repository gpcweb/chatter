defmodule Chatter.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :last_name, :string
      add :email, :string

      timestamps()
    end

  end
end
