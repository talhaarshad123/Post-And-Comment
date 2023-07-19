defmodule PostandcommentWeb.User.LoginLive do
  alias Postandcomment.Context.Users
  use Phoenix.LiveView
  import Argon2
  alias Postandcomment.Model.User
  alias Phoenix.Token


  def render(assigns) do
    ~L"""
    <div class="row">
    <form phx-submit="save">
    <input placeholder="Enter Email" type="email"  name="current_user[email]" required><br><br>
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

  def mount(_params, %{"auth_key" => key}, socket) do
    case Token.verify(PostandcommentWeb.Endpoint, "somekey", key, max_age: 10800) do
      {:ok, _user_id} ->
        {:ok, socket |> redirect(to: "/")}
      {:error, _reason} ->
        user = %{
          email: "",
          password: ""
        }
        {:ok, socket |> assign(current_user: user, errors: [])}
    end

  end

  def mount(_params, _session, socket) do
    user = %{
      email: "",
      password: ""
    }
    {:ok, socket |> assign(current_user: user, errors: [])}
  end

  def handle_event("save", %{"current_user" => user}, socket) do
    case do_verify_user(user) do
      {:ok, valid_user} ->
        token = Token.sign(PostandcommentWeb.Endpoint, "somekey", valid_user.id)
         {:noreply, socket |> redirect(to: "/#{token}/login")}
      {:error, errors} -> {:noreply, socket |> assign(errors: errors)}
    end
  end


  defp do_verify_user(%{"email" => email, "password" => password}) do
    with %User{} = valid_user <- Users.get_user_by_email(email)
    do
      do_verify_pass(valid_user, password)
    else
      _ -> {:error, ["invalid email or password"]}
    end
  end

  defp do_verify_pass(user, plain_password) do
    with true <- verify_pass(plain_password, user.password),
    true <- is_verified_user?(user)
    do
      {:ok, user}
    else
      _ -> {:error, ["Invalid email or password"]}
    end
  end

  defp is_verified_user?(user), do: user.is_active


end
