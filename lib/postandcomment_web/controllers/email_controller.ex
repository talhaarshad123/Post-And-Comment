defmodule PostandcommentWeb.EmailController do
  use PostandcommentWeb, :controller
  alias Postandcomment.Context.Users
  alias Postandcomment.Model.User
  alias Phoenix.Token

  def verify(conn, %{"token" => token}) do
    with {:ok, uid} <- Token.verify(PostandcommentWeb.Endpoint, "somekey", token, max_age: 3600),
    %User{is_active: false} = user <- Users.get_user_by_id(uid)
    do
      {:ok, _verified_user} = Users.update(user, %{"is_active" => true})
      conn |> put_flash(:info, "Email Verified") |> redirect(to: "/login")
    else
      _ -> conn |> put_flash(:error, "Not Allowed") |> redirect(to: "/login")
    end
  end
end
