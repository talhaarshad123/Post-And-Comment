defmodule Postandcomment.Context.Comments do
  alias Postandcomment.Repo
  alias Postandcomment.Context.Posts
  alias Postandcomment.Model.Comment
  import Ecto


  def get_all_by(pid) do
    Posts.get_by_id(pid)
    |> Repo.preload(:comments)
  end

  def create(post, uid, comment) do
    post
    |> build_assoc(:comments, user_id: uid)
    |> Comment.changeset(comment)
    |> Repo.insert()
  end

  def get_by_id(cid) do
    Repo.get(Comment, cid)
  end
end
