defmodule Postandcomment.Repo.Migrations.Comment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :post_id, references(:posts, on_delete: :delete_all)
    end
  end
end
