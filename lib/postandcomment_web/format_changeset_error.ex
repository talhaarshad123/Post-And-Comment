defmodule PostandcommentWeb.FormatChangesetError do

  def format(errors) do
    errors
    |> Enum.map(fn {key, {msg, _}} -> to_string(key) <> msg end)
  end
end
