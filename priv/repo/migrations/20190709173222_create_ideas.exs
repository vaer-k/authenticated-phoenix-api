defmodule IdeaPool.Repo.Migrations.CreateIdeas do
  use Ecto.Migration

  def change do
    create table(:ideas) do
      add :content, :string
      add :impact, :integer
      add :ease, :integer
      add :confidence, :integer
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:ideas, [:user_id])
  end
end
