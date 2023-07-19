defmodule Postandcomment.Model.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Argon2


  schema "users" do
    field :email, :string
    field :password, :string
    field :date_of_birth, :date
    field :profession, :string
    field :phone_number, :string
    field :gender, :string
    field :is_active, :boolean
  end


  def changeset(required, given \\ %{}) do
    required
    |> cast(given, [:email, :password, :phone_number, :date_of_birth, :profession, :gender, :is_active])
    |> validate_required([:email, :password, :phone_number, :date_of_birth, :profession, :gender])
    |> validate_length(:phone_number, max: 11)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:phone_number)
    |> add_pass_hash()
  end


  defp add_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: hash_pwd_salt(password))
  end

  defp add_pass_hash(changeset), do: changeset



end
