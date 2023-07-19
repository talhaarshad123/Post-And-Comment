defmodule Postandcomment.Context.Users do
  alias Postandcomment.Repo
  alias Postandcomment.Model.User

  def create(user) do
    %User{}
    |> User.changeset(user)
    |> Repo.insert()
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email )
  end

  def get_user_by_id(id) do
    Repo.get(User, id)
  end

  def update(current_user, updated_user) do
    current_user
    |> User.changeset(updated_user)
    |> Repo.update()
  end
end
