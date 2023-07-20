defmodule PostandcommentWeb.Comment.HandleComments do
  use GenServer

  alias Postandcomment.Context.Comments


  @impl true
  def init(post_id) do
    comments_by_post = Comments.get_all_by(post_id)
    {:ok, comments_by_post}
  end

  @impl true
  def handle_call({:get_comments}, _from, state) do
    {:reply, state, state}
  end


  @impl true
  def handle_cast({:add_comment, comment}, state) do
    updated_comment = [comment | state.comments]
    {:noreply, %Postandcomment.Model.Post{state | comments: updated_comment}}
  end

end
