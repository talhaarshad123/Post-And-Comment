defmodule PostandcommentWeb.Reply.CreateLive do
  use Phoenix.LiveView
  alias Postandcomment.Context.Replies
  alias Phoenix.Token


  def render(assigns) do
    ~L"""
    <div id="info"><%= Phoenix.Flash.get(@flash, :info)%></div>
    <div id="error"><%= Phoenix.Flash.get(@flash, :error)%></div>
    <h3><%= @replies.content %></h3>
    <form phx-submit="save">
      <input placeholder="Enter Reply" required name="reply[content]" type="text">
      <%= for error <- @errors do %>
        <div class="flex justify-start text-gray-700 rounded-md px-2 py-2 my-2">
          <span class="bg-gray-400 h-2 w-2 m-2 rounded-full"></span>
          <div class="flex-grow font-medium px-2"><%= error %></div>
        </div>
      <% end %>
      <button type="submit" class="btn btn--primary">Reply</button>
    </form>
    <ul class="collection">
      <%= for reply <- @replies.replies do %>
        <li class="collection-item"><%= reply.content %></li>
      <% end %>
    </ul>
    """
  end

  def mount(%{"id" => id}, %{"auth_key" => token}, socket) do
    with {comment_id, _} <- Integer.parse(id),
    {:ok, uid} <- Token.verify(PostandcommentWeb.Endpoint, "somekey", token, max_age: 10800),
    %Postandcomment.Model.Comment{} = replies <- Replies.get_by_comment_id(comment_id)
    do
      Phoenix.PubSub.subscribe(Postandcomment.PubSub, "comment:#{comment_id}")
      {:ok, socket |> assign(uid: uid, replies: replies, errors: [])}
    else
      _ -> {:ok, socket |> put_flash(:error, "NOT ALLOWED") |> redirect(to: "/")}
    end
  end

  def handle_event("save", %{"reply" => reply}, %Phoenix.LiveView.Socket{assigns: %{uid: uid, replies: comment}} = socket) do
    case Replies.create(comment.id, reply, uid) do
      {:ok, new_reply} ->
        Phoenix.PubSub.broadcast(Postandcomment.PubSub, "comment:#{new_reply.comment_id}", {:reply, new_reply})
        replies = Replies.get_by_comment_id(new_reply.comment_id)
        {:noreply, socket |> put_flash(:info, "ADDED") |> assign(replies: replies)}
      {:error, changeset} ->
        errors = changeset.errors |> Enum.map(fn {key, {msg, _}} -> "#{key} #{msg}" end)
        {:noreply, socket |> assign(errors: errors)}
    end
  end

  def handle_info({:reply, new_reply}, socket) do
    replies = Replies.get_by_comment_id(new_reply.comment_id)
    {:noreply, socket |> assign(replies: replies)}
  end
end
