defmodule Postandcomment.VerifyEmail do
  import Swoosh.Email
  alias Phoenix.Token

  def verify(user) do
    token = do_generate_token(user.id)
    url = do_generate_link("http", "localhost:4000", token, "verify/user")
    new()
    |> to({"USER", user.email})
    |> from({"ADMIN", "admin@example.com"})
    |> subject("VERIFY YOUR EMAIL")
    |> text_body("Hello, verify your email by clicking the link below\n #{url}")
  end

  defp do_generate_token(uid), do: Token.sign(PostandcommentWeb.Endpoint, "somekey", uid)
  defp do_generate_link(protocol_type, domain, token, path), do: "#{protocol_type}://#{domain}/#{token}/#{path}"
end
