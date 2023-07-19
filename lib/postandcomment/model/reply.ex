defmodule Postandcomment.Model.Reply do
  import Ecto.Changeset
  use Ecto.Schema


  schema "replies" do
    field :content, :string
    belongs_to :comment, Postandcomment.Model.Comment
    belongs_to :user, Postandcomment.Model.User
  end

  def changeset(required, given) do
    required
    |> cast(given, [:content])
    |> validate_required([:content])
  end

end
