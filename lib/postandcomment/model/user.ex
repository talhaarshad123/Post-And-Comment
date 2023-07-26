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
    has_many :posts, Postandcomment.Model.Post
    has_many :comments, Postandcomment.Model.Comment
    has_many :replies, Postandcomment.Model.Reply
  end


  def changeset(required, given \\ %{}) do
    required
    |> cast(given, [:email, :password, :phone_number, :date_of_birth, :profession, :gender, :is_active])
    |> validate_required([:email, :password, :phone_number, :date_of_birth, :profession, :gender])
    |> validate_length(:phone_number,is: 11, message: "should be 11 character(s)")
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:phone_number)
    |> validate_length(:profession, max: 255, message: "should be at most 255 character(s)")
    |> add_pass_hash()
    |> number_validation()
  end


  defp add_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: hash_pwd_salt(password))
  end

  defp add_pass_hash(changeset), do: changeset

  defp number_validation(%Ecto.Changeset{valid?: true, changes: %{phone_number: phone_number}} = changeset) do
    phone_number
    |> String.split("", trim: true)
    |> Enum.all?(fn char -> char >= "0" and char <= "9" end)
    |> case do
      true -> changeset
      false -> %Ecto.Changeset{changeset | valid?: false, errors: [{:phone_number, {"All letters must be between 0-9", []}} | changeset.errors]}
    end
  end

  defp number_validation(changeset), do: changeset


end
