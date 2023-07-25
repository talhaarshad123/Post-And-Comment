defmodule PostandcommentWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller


  def init(_) do
  end

  def call(conn, _params) do
   if conn.assigns[:user] do
    conn
   else
    conn |> put_flash(:error, "login require") |> redirect(to: "/login") |> halt()
   end
  end
end
