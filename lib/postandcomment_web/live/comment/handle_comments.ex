defmodule PostandcommentWeb.Comment.HandleComments do
  use GenServer

  alias Postandcomment.Context.Comments
  alias Postandcomment.Context.Posts


  @impl true
  def init(post_id) do
    case Comments.get_all_by(post_id) do
      [] ->
        post = Posts.get_by_id(post_id)
        {:ok, Comments.get_comments_by(post)}

      [comments_by_post | _] -> {:ok, comments_by_post}
    end
  end

  @impl true
  def handle_call(:get_comments, _from, state) do
    filtered_comments = do_fillter_comments(state, 5*60)
    {:reply, filtered_comments, filtered_comments}
  end


  @impl true
  def handle_cast({:add_comment, comment}, state) do
    updated_comment = [comment | state.comments]

    {:noreply, %Postandcomment.Model.Post{state | comments: updated_comment}}
  end


  defp do_fillter_comments(comments_by_post, limit) do
    expression = &(NaiveDateTime.diff(NaiveDateTime.utc_now, &1))
    filtered_comments = comments_by_post.comments
    |> Enum.filter(fn comment -> expression.(comment.inserted_at) < limit end)

    %Postandcomment.Model.Post{comments_by_post | comments: filtered_comments}
  end

end
