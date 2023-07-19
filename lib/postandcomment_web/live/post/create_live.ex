defmodule PostandcommentWeb.Post.CreateLive do
  use Phoenix.LiveView
  alias Phoenix.PubSub
  alias Phoenix.Token
  alias Postandcomment.Context.Posts


  def render(assigns) do
    ~L"""
    <div class="row">
    <form phx-submit="save">
    <input placeholder="Enter Title" type="text"  name="post[title]"><br><br>
    <input type="text" required name="post[description]" placeholder="Enter Description"><br><br>
    <ul>
    <%= for error <- @errors do %>
    <li><%= error %></li>
    <% end %>
    </ul>
    <button type="submit">Submit</button>
    </form>
    </div>
    """
  end

  def mount(_, %{"auth_key" => token}, socket) do
    {:ok, uid} = Token.verify(PostandcommentWeb.Endpoint, "somekey", token, max_age: 10800)
    post = %{
      title: "",
      description: ""
    }
    {:ok, socket |> assign(uid: uid, post: post, errors: [])}
  end

  def handle_event("save", %{"post" => post}, socket) do
    IO.inspect(socket, label: "SOCKET")
    case Posts.create(post, socket.assigns.uid) do
      {:ok, new_post} ->
        PubSub.broadcast(Postandcomment.PubSub, "post", {:post, new_post})
        {:noreply, socket |> put_flash(:info, "POST ADDED") |> redirect(to: "/")}
      {:error, changeset} ->
        errors = Enum.map(changeset.errors, fn {key, {msg, _}} -> "#{key} #{msg}" end)
        {:noreply, socket |> assign(errors: errors)}
    end
  end
end
