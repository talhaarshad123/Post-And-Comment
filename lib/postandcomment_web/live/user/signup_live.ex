defmodule PostandcommentWeb.User.SignupLive do
  use Phoenix.LiveView
  alias Postandcomment.Context.Users


  def render(assigns) do
    ~L"""
    <div class="">
    <form phx-submit="save">
    <input placeholder="Enter Email" type="email"  name="current_user[email]">
    <input placeholder="Enter Date Of Birth" type="date"  name="current_user[date_of_birth]">
    <input placeholder="Enter Profession" type="text"  name="current_user[profession]">
    <input placeholder="Enter Phone Number" type="text"  name="current_user[phone_number]">
    <input type="radio" value="male" name="current_user[gender]">
    <label for="male">Male</label>
    <input type="radio" value="female" name="current_user[gender]">
    <label for="female">Female</label>
    <input type="password" required name="current_user[password]" placeholder="Enter Password"><br><br>
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

  def mount(_params, %{"auth_key" => _key}, socket) do
    {:ok, socket |> redirect(to: "/")}
  end

  def mount(_params, _session, socket) do
    user = %{
      email: "",
      password: "",
      phone_number: "",
      profession: "",
      date_of_birth: "",
      gender: ""
    }
    {:ok, socket |> assign(current_user: user, errors: [])}
  end

  def handle_event("save", %{"current_user" => %{"date_of_birth" => date_of_birth} = user}, socket) do
    [year, month, day] = date_of_birth |> String.split("-", trim: true)
    {:ok, dob} = Date.new(String.to_integer(year), String.to_integer(month), String.to_integer(day))

    Map.put(user, "date_of_birth", dob)
    |> Users.create()
    |> case do
      {:ok, _user} -> {:noreply, socket |> put_flash(:info, "User created") |> redirect(to: "/")}
      {:error, changeset} ->
        errors = changeset.errors |> Enum.map(fn {key, {msg, _}} -> to_string(key) <> " " <> msg end)
        {:noreply, socket |> assign(errors: errors)}
    end
  end
end
