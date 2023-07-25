defmodule PostandcommentWeb.Post.IndexLive do
  use Phoenix.LiveView
  alias Postandcomment.Context.Posts
  alias Phoenix.PubSub
  alias Phoenix.Token


  def render(assigns) do
    ~L"""
    <div id="info"><%= Phoenix.Flash.get(@flash, :info)%></div>
    <div id="error"><%= Phoenix.Flash.get(@flash, :error)%></div>
    <ul class="collection">
      <%= for post <- @posts do %>
        <li class="collection-item"> <a href="/post/<%= post.id %>"><%= post.title %></a> </li>
      <% end %>
    </ul>
    """
  end

  def mount(_, %{"auth_key" => token}, socket) do
    case Token.verify(PostandcommentWeb.Endpoint, "somekey", token, max_age: 10800) do
      {:ok, _user_id} ->
        PubSub.subscribe(Postandcomment.PubSub, "post")
        posts = Posts.all_posts()
        {:ok, socket |> assign(posts: posts)}
      {:error, _} ->
        posts = Posts.all_posts()
        {:ok, socket |> assign(posts: posts)}
    end
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
