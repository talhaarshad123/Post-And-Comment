defmodule Postandcomment.Repo.Migrations.Posts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :description, :string
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
