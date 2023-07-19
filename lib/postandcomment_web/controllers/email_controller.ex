defmodule PostandcommentWeb.EmailController do
  use PostandcommentWeb, :controller
  alias Postandcomment.Context.Users
  alias Postandcomment.Model.User
  alias Phoenix.Token

  def verify(conn, %{"token" => token}) do
    with {:ok, uid} <- Token.verify(PostandcommentWeb.Endpoint, "somekey", token, max_age: 10800),
    %User{} = user <- Users.get_user_by_id(uid)
    do
      {:ok, _verified_user} = Users.update(user, %{"is_active" => true})
      conn |> put_flash(:info, "Email Verified") |> redirect(to: "/")
    else
      _ -> conn |> put_flash(:error, "NOT ALLOWED") |> redirect(to: "/")
    end
  end
end
