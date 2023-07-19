defmodule Postandcomment.Context.Replies do
  alias Postandcomment.Repo
  alias Postandcomment.Context.Comments
  alias Postandcomment.Model.Reply
  import Ecto

  def get_by_comment_id(cid) do
    Comments.get_by_id(cid)
    |> Repo.preload(:replies)
  end

  def create(cid, reply, uid) do
    Comments.get_by_id(cid)
    |> build_assoc(:replies, user_id: uid)
    |> Reply.changeset(reply)
    |> Repo.insert()
  end
end
