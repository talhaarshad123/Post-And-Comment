defmodule Postandcomment.Context.Comments do
  alias Postandcomment.Repo
  alias Postandcomment.Model.Comment
  alias Postandcomment.Model.Post
  import Ecto
  import Ecto.Query


  def get_all_by(pid) do
    limit = NaiveDateTime.add(NaiveDateTime.utc_now(), -(5*60))
    query = from p in Post,
    join: c in assoc(p, :comments),
    where: p.id == ^pid and c.inserted_at >= ^limit,
    preload: [comments: c]

    Repo.all(query)
  end

  def get_comments_by(post) do
    post
    |> Repo.preload(:comments)
    |> do_fillter_comments(5*60)
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


  defp do_fillter_comments(comments_by_post, limit) do
    expression = &(NaiveDateTime.diff(NaiveDateTime.utc_now, &1))
    filtered_comments = comments_by_post.comments
    |> Enum.filter(fn comment -> expression.(comment.inserted_at) < limit end)

    %Postandcomment.Model.Post{comments_by_post | comments: filtered_comments}
  end
end
