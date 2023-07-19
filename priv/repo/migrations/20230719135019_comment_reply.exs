defmodule Postandcomment.Repo.Migrations.CommentReply do
  use Ecto.Migration

  def change do
    create table(:replies) do
      add :content, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :comment_id, references(:comments, on_delete: :delete_all)
      timestamps()
    end
  end
end
