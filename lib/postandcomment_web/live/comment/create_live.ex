defmodule PostandcommentWeb.Comment.CreateLive do
  use Phoenix.LiveView
  alias Postandcomment.Context.Comments
  alias Phoenix.Token


  def render(assigns) do
    ~L"""
    <h3><%= @post.title %></h3>
    <form phx-submit="save">
      <input type="text" placeholder="Enter Comment" name="comment[content]" required>
      <%= for error <- @errors do %>
        <%= error %>
      <% end %>
      <button type="submit">Submit</button>
    </form>
    <ul class="collection">
      <%= for comment <- @post.comments do %>
        <li class="collection-item"><a href="/post/comment/<%= comment.id %>"><%= comment.content %></a></li>
      <% end %>
    </ul>
    """
  end

  def mount(%{"id" => id}, %{"auth_key" => token}, socket) do
    with {post_id, _}  <- Integer.parse(id),
    {:ok, uid} <- Token.verify(PostandcommentWeb.Endpoint, "somekey", token, max_age: 10800)
    do
      Phoenix.PubSub.subscribe(Postandcomment.PubSub, "post:#{post_id}")
      comments_by_post = Comments.get_all_by(post_id)
      {:ok, socket |> assign(post: comments_by_post, uid: uid, errors: [])}
    else
      _error -> {:ok, socket |> put_flash(:error, "NOT ALLOWED") |> redirect(to: "/")}
    end
  end


  def handle_event("save", %{"comment" => comment},%Phoenix.LiveView.Socket{assigns: %{post: post, uid: uid}} = socket) do
    case Comments.create(post, uid, comment) do
      {:ok, new_comment} ->
        Phoenix.PubSub.broadcast(Postandcomment.PubSub, "post:#{new_comment.post_id}", {:comment, new_comment})
        {:noreply, socket |> put_flash(:info, "COMMENT ADDED") |> redirect(to: "/post/#{new_comment.post_id}")}
      {:error, changeset} ->
        errors = Enum.map(changeset.errors, fn {key, {msg, _}} -> "#{key} #{msg}" end)
        {:noreply, socket |> assign(errors: errors)}
    end
  end

  def handle_info({:comment, new_comment}, socket) do
    comments_by_post = Comments.get_all_by(new_comment.post_id)
    {:noreply, socket |> assign(post: comments_by_post)}
  end
end
