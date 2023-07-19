defmodule PostandcommentWeb.SessionController do
  use PostandcommentWeb, :controller
  alias Phoenix.Token


  def login(conn, %{"token" => token}) do
    case Token.verify(PostandcommentWeb.Endpoint, "somekey", token, max_age: 10800) do
      {:ok, _user_id} -> put_session(conn, :auth_key, token) |> put_flash(:info, "Loged in") |> redirect(to: "/")
      {:error, _} -> conn |> put_flash(:error, "invalid email or password") |> redirect(to: "/registration")
    end
  end

  def logout(conn, _params) do
    clear_session(conn)
    |> configure_session(drop: true)
    |> put_flash(:info, "Loged out")
    |> redirect(to: "/login")
  end
end
