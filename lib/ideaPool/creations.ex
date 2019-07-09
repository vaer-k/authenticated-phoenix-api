defmodule IdeaPool.Creations do
  @moduledoc """
  The Creations context.
  """

  import Ecto.Query, warn: false
  alias IdeaPool.Repo

  alias IdeaPool.Accounts
  alias IdeaPool.Creations.Idea

  @doc """
  Returns the list of ideas.

  ## Examples

      iex> list_ideas()
      [%Idea{}, ...]

  """
  def list_ideas do
    Repo.all(Idea)
  end

  def list_user_ideas(%Accounts.User{} = user) do
    Idea
    |> user_ideas_query(user)
    |> Repo.all()
  end

  defp user_ideas_query(query, %Accounts.User{id: user_id}) do
    from(v in query, where: v.user_id == ^user_id)
  end

  @doc """
  Gets a single idea.

  Raises `Ecto.NoResultsError` if the Idea does not exist.

  ## Examples

      iex> get_idea!(123)
      %Idea{}

      iex> get_idea!(456)
      ** (Ecto.NoResultsError)

  """
  def get_idea!(id), do: Repo.get!(Idea, id)

  def get_idea_by(params) do
    Repo.get_by(Idea, params)
  end

  def create_idea(%Accounts.User{} = user, attrs \\ %{}) do
    %Idea{}
    |> Idea.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a idea.

  ## Examples

      iex> update_idea(idea, %{field: new_value})
      {:ok, %Idea{}}

      iex> update_idea(idea, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_idea(%Idea{} = idea, attrs) do
    idea
    |> Idea.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Idea.

  ## Examples

      iex> delete_idea(idea)
      {:ok, %Idea{}}

      iex> delete_idea(idea)
      {:error, %Ecto.Changeset{}}

  """
  def delete_idea(%Idea{} = idea) do
    Repo.delete(idea)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking idea changes.

  ## Examples

      iex> change_idea(idea)
      %Ecto.Changeset{source: %Idea{}}

  """
  def change_idea(%Idea{} = idea) do
    Idea.changeset(idea, %{})
  end
end
