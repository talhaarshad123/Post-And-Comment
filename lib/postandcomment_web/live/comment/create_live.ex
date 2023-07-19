defmodule PostandcommentWeb.Comment.CreateLive do
  use Phoenix.LiveView
  alias Postandcomment.Model.Post
  alias Postandcomment.Context.Posts


  def render(assigns) do
    ~L"""
    <h3><%= @post.title %></h3>

    """
  end

  def mount(%{"id" => id}, %{"auth_key" => _token}, socket) do
    with {post_id, _}  <- Integer.parse(id),
         %Post{} = post <- Posts.get_by_id(post_id)
    do
      {:ok, socket |> assign(post: post)}
    else
      _error -> {:ok, socket |> put_flash(:error, "NOT ALLOWED") |> redirect(to: "/")}
    end
  end

end
