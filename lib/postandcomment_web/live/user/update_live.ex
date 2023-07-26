defmodule PostandcommentWeb.User.UpdateLive do
  use Phoenix.LiveView
  alias Phoenix.Token
  alias Postandcomment.Context.Users

  def render(assigns) do
    ~L"""
    <div class="">
    <form phx-submit="save">


    <input placeholder="Enter Profession" type="text"  name="current_user[profession]" value="<%= @current_user.profession %>">
    <input placeholder="Enter Phone Number" type="text"  name="current_user[phone_number]" value="<%= @current_user.phone_number %>">
    <%= if @current_user.gender === "male" do %>
      <p>
        <label>
          <input type="radio" value="male" name="current_user[gender]" checked>
          <span>Male</span>
        </label>
      </p>
      <p>
        <label>
          <input type="radio" value="female" name="current_user[gender]">
          <span>Female</span>
        </label>
      </p>
    <% else %>
      <p>
        <label>
          <input type="radio" value="male" name="current_user[gender]">
          <span>Male</span>
        </label>
      </p>
      <p>
        <label>
          <input type="radio" value="female" name="current_user[gender]" checked>
          <span>Female</span>
        </label>
      </p>
    <% end %>
    <%= for error <- @errors do %>
      <div class="flex justify-start text-gray-700 rounded-md px-2 py-2 my-2">
        <span class="bg-gray-400 h-2 w-2 m-2 rounded-full"></span>
        <div class="flex-grow font-medium px-2"><%= error %></div>
      </div>
    <% end %>
    <button type="submit" class="btn btn--primary">Update</button>
    </form>
    </div>
    """
  end

  def mount(_, %{"auth_key" => token}, socket) do
    {:ok, uid} = Token.verify(PostandcommentWeb.Endpoint, "somekey", token)
    user = Users.get_user_by_id(uid)
    {:ok, socket |> assign(current_user: user, errors: [])}
  end

  def handle_event("save", %{"current_user" => updated_user}, socket) do
    current_user = socket.assigns.current_user
    case Users.update(current_user, updated_user) do
      {:ok, _updated_user} -> {:noreply, socket |> put_flash(:info, "UPDATED PROFILE") |> redirect(to: "/")}
      {:error, changeset} ->
        errors = Enum.map(changeset.errors, fn {key, {msg, _}} -> "#{key} #{msg}" end)
      {:noreply, socket |> assign(errors: errors) }
    end
  end
end
