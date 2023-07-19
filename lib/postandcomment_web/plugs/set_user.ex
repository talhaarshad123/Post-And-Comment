defmodule PostandcommentWeb.Plugs.SetUser do
  import Plug.Conn
  alias Phoenix.Token
  alias Postandcomment.Context.Users


  def init(_) do
  end


  def call(conn, _params) do
    case get_session(conn, :auth_key) do
      nil ->
        conn
      token ->
        case Token.verify(PostandcommentWeb.Endpoint, "somekey", token, max_age: 10800) do
          {:ok, user_id} ->
            case Users.get_user_by_id(user_id) do
              nil ->
                conn
              user ->
                conn |> assign(:user, user)
            end
          {:error, _} ->
            conn

        end
    end

  end
end
