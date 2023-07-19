defmodule Postandcomment.Model.Comment do
  import Ecto.Changeset
  use Ecto.Schema

  schema "comments" do
    field :content, :string
    belongs_to :user, Postandcomment.Model.User
    belongs_to :post, Postandcomment.Model.Post
    has_many :replies, Postandcomment.Model.Reply
  end


  def changeset(required, given) do
    required
    |> cast(given, [:content])
    |> validate_required([:content])
  end

end
