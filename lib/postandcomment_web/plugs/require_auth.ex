defmodule PostandcommentWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller
  alias Phoenix.Token
  alias Postandcomment.Context.Users


  def init(_) do
  end

  def call(conn, _params) do
   if conn.assigns.user === nil do
    conn |> put_flash(:error, "login require") |> redirect(to: "/") |> halt()
   else
    conn
   end
  end
end
