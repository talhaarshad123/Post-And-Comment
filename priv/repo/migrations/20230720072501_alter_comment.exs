defmodule Postandcomment.Repo.Migrations.AlterComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :inserted_at, :naive_datetime
      add :updated_at, :naive_datetime
    end
  end
end
