defmodule IdeaPool.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string

    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password])
    |> validate_required([:email, :name, :password])
    |> put_pass_hash
    |> validate_format(:email, ~r/@/)
    |> format_email
    |> unique_constraint(:email)
  end

  defp format_email(changeset) do
    email =
      get_field(changeset, :email)
      |> String.trim()
      |> String.downcase()

    force_change(changeset, :email, email)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    change(changeset, Bcrypt.add_hash(pass))
  end

  defp put_pass_hash(changeset), do: changeset
end
