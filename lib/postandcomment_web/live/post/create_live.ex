defmodule PostandcommentWeb.Post.CreateLive do
  use Phoenix.LiveView
  alias Phoenix.PubSub
  alias Phoenix.Token
  alias Postandcomment.Context.Posts


  def render(assigns) do
    ~L"""
    <%= PostandcommentWeb.HandleFlash.render(assigns) %>
    <form phx-submit="save">
      <div class="heading text-center font-bold text-2xl m-5 text-gray-800">New Post</div>
      <style>
        body {background:white !important;}
      </style>
      <div class="editor mx-auto w-10/12 flex flex-col text-gray-800 border border-gray-300 p-4 shadow-lg max-w-2xl">
        <input class="title bg-gray-100 border border-gray-300 p-2 mb-4 outline-none" spellcheck="false" placeholder="Title" type="text" name="post[title]">
        <textarea class="description bg-gray-100 sec p-3 h-60 border border-gray-300 outline-none" spellcheck="false" placeholder="Describe everything about this post here" name="post[description]"></textarea>
        <%= PostandcommentWeb.HandleError.render(assigns) %>
        <div class="buttons flex">
          <button tye="submit" class="btn border border-indigo-500 p-1 px-4 font-semibold cursor-pointer text-gray-200 ml-2 bg-indigo-500">Post</button>
        </div>
      </div>
    </form>
    """
  end

  def mount(_, %{"auth_key" => token}, socket) do
    {:ok, uid} = Token.verify(PostandcommentWeb.Endpoint, "somekey", token, max_age: 10800)
    {:ok, socket |> assign(uid: uid, errors: [])}
  end

  def handle_event("save", %{"post" => post}, socket) do
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
