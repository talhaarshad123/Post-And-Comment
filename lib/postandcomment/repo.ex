defmodule Postandcomment.Repo do
  use Ecto.Repo,
    otp_app: :postandcomment,
    adapter: Ecto.Adapters.Postgres
end
