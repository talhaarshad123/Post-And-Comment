defmodule Postandcomment.Repo.Migrations.User do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password, :string
      add :date_of_birth, :date
      add :gender, :string
      add :phone_number, :string
      add :profession, :string
      add :is_active, :boolean, default: false
    end

    create unique_index(:users, [:email, :phone_number])
  end
end
