defmodule Postandcomment.Context.Posts do

  alias Postandcomment.Repo
  alias Postandcomment.Model.Post
  alias Postandcomment.Context.Users
  import Ecto
  import Ecto.Query

  def create(post, uid) do
    Users.get_user_by_id(uid)
    |> build_assoc(:posts)
    |> Post.changeset(post)
    |> Repo.insert()
  end

  def all_posts() do
    query = from p in Post,
    order_by: [desc: p.id]
    Repo.all(query)
  end

  def get_by_id(pid) do
    Repo.get(Post, pid)
  end
end
