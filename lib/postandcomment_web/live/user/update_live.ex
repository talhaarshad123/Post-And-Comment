defmodule PostandcommentWeb.User.UpdateLive do
  use Phoenix.LiveView
  alias Phoenix.Token
  alias Postandcomment.Context.Users

  def render(assigns) do
    # <input placeholder="Enter DOB" type="date"  name="current_user[date_of_birth]" value="<%= @current_user.date_of_birth.year %>-09-<%= @current_user.date_of_birth.day %>">

    ~L"""
    <div class="">
    <form phx-submit="save">


    <input placeholder="Enter Profession" type="text"  name="current_user[profession]" value="<%= @current_user.profession %>">
    <input placeholder="Enter Phone Number" type="text"  name="current_user[phone_number]" value="<%= @current_user.phone_number %>">
    <%= if @current_user.gender === "male" do %>
      <input type="radio" value="male" name="current_user[gender]" checked>
      <label for="male">Male</label>
      <input type="radio" value="female" name="current_user[gender]">
      <label for="female">Female</label>
    <% else %>
      <input type="radio" value="male" name="current_user[gender]">
      <label for="male">Male</label>
      <input type="radio" value="female" name="current_user[gender]" checked>
      <label for="female">Female</label>
    <% end %>

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
    {:ok, uid} = Token.verify(PostandcommentWeb.Endpoint, "somekey", token)
    user = Users.get_user_by_id(uid)
    IO.inspect(user.date_of_birth.month, label: "MONTH")
    {:ok, socket |> assign(current_user: user, errors: [])}
  end

  def handle_event("save", %{"current_user" => updated_user}, socket) do
    # [updated_day, updated_month, updated_year] = updated_user["date_of_birth"] |> String.split("-", trim: true)
    # updated_user = Map.put(updated_user, "date_of_birth", Date.new(updated_year, updated_month, updated_day))
    current_user = socket.assigns.current_user
    case Users.update(current_user, updated_user) do
      {:ok, _updated_user} -> {:noreply, socket |> put_flash(:info, "UPDATED") |> redirect(to: "/")}
      {:error, changeset} ->
        errors = Enum.map(changeset.errors, fn {key, {msg, _}} -> "#{key} #{msg}" end)
      {:noreply, socket |> assign(errors: errors) }
    end
  end
end
