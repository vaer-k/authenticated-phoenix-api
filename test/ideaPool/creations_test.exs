defmodule IdeaPool.CreationsTest do
  use IdeaPool.DataCase

  alias IdeaPool.Creations

  describe "ideas" do
    alias IdeaPool.Creations.Idea

    @valid_attrs %{confidence: 42, content: "some content", ease: 42, impact: 42}
    @update_attrs %{confidence: 43, content: "some updated content", ease: 43, impact: 43}
    @invalid_attrs %{confidence: nil, content: nil, ease: nil, impact: nil}

    def idea_fixture(attrs \\ %{}) do
      {:ok, idea} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Creations.create_idea()

      idea
    end

    test "list_ideas/0 returns all ideas" do
      idea = idea_fixture()
      assert Creations.list_ideas() == [idea]
    end

    test "get_idea!/1 returns the idea with given id" do
      idea = idea_fixture()
      assert Creations.get_idea!(idea.id) == idea
    end

    test "create_idea/1 with valid data creates a idea" do
      assert {:ok, %Idea{} = idea} = Creations.create_idea(@valid_attrs)
      assert idea.confidence == 42
      assert idea.content == "some content"
      assert idea.ease == 42
      assert idea.impact == 42
    end

    test "create_idea/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Creations.create_idea(@invalid_attrs)
    end

    test "update_idea/2 with valid data updates the idea" do
      idea = idea_fixture()
      assert {:ok, %Idea{} = idea} = Creations.update_idea(idea, @update_attrs)
      assert idea.confidence == 43
      assert idea.content == "some updated content"
      assert idea.ease == 43
      assert idea.impact == 43
    end

    test "update_idea/2 with invalid data returns error changeset" do
      idea = idea_fixture()
      assert {:error, %Ecto.Changeset{}} = Creations.update_idea(idea, @invalid_attrs)
      assert idea == Creations.get_idea!(idea.id)
    end

    test "delete_idea/1 deletes the idea" do
      idea = idea_fixture()
      assert {:ok, %Idea{}} = Creations.delete_idea(idea)
      assert_raise Ecto.NoResultsError, fn -> Creations.get_idea!(idea.id) end
    end

    test "change_idea/1 returns a idea changeset" do
      idea = idea_fixture()
      assert %Ecto.Changeset{} = Creations.change_idea(idea)
    end
  end
end
