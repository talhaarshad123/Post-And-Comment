defmodule Postandcomment.Model.Post do
  import Ecto.Changeset
  use Ecto.Schema

  schema "posts" do
    field :title, :string
    field :description, :string
    belongs_to :user, Postandcomment.Model.User
    has_many :comments, Postandcomment.Model.Comment
  end


  def changeset(required, given) do
    required
    |> cast(given, [:title, :description])
    |> validate_required([:title, :description])
    |> validate_length(:title, max: 255, message: "should be at most 255 character(s)")
    |> validate_length(:description, max: 255, message: "should be at most 255 character(s)")
  end

end
