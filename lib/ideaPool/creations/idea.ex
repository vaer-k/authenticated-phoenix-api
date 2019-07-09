defmodule IdeaPool.Creations.Idea do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ideas" do
    field :confidence, :integer
    field :content, :string
    field :ease, :integer
    field :impact, :integer

    belongs_to :user, IdeaPool.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(idea, attrs) do
    idea
    |> cast(attrs, [:content, :impact, :ease, :confidence])
    |> validate_required([:content, :impact, :ease, :confidence])
    |> validate_length(:content, max: 255)
    |> validate_between_one_ten([:confidence, :ease, :impact])
  end

  defp validate_between_one_ten(changeset, fields) do
    Enum.reduce(fields, changeset, validate_between(1, 10))
  end

  defp validate_between(min, max) do
    fn field, changeset ->
      validate_number(changeset, field, greater_than_or_equal_to: min, less_than_or_equal_to: max)
    end
  end
end
