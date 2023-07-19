defmodule Postandcomment.Model.Post do
  import Ecto.Changeset
  use Ecto.Schema

  schema "posts" do
    field :title, :string
    field :description, :string
    belongs_to :user, Postandcomment.Model.User
  end


  def changeset(required, given) do
    required
    |> cast(given, [:title, :description])
    |> validate_required([:title, :description])
    |> validate_length(:title, max: 255)
    |> validate_length(:description, max: 255)
  end

end
