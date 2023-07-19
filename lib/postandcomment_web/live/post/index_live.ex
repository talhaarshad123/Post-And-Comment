defmodule PostandcommentWeb.Post.IndexLive do
  use Phoenix.LiveView
  alias Postandcomment.Context.Posts
  alias Phoenix.PubSub


  def render(assigns) do
    ~L"""
    <ul class="collection">
      <%= for post <- @posts do %>
      <li class="collection-item"> <a href="/post/<%= post.id %>"><%= post.title %></a> </li>
      <% end %>
    </ul>
    """
  end

  def mount(_, %{"auth_key" => _token}, socket) do
    PubSub.subscribe(Postandcomment.PubSub, "post")
    posts = Posts.all_posts()
    {:ok, socket |> assign(posts: posts)}
  end

  def mount(_, _, socket) do
    posts = Posts.all_posts()
    {:ok, socket |> assign(posts: posts)}
  end

  def handle_info({:post, _post}, socket) do
    posts = Posts.all_posts()
    {:noreply, socket |> assign(posts: posts)}
  end
end
