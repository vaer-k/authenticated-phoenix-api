defmodule IdeaPoolWeb.IdeaControllerTest do
  use IdeaPoolWeb.ConnCase

  alias IdeaPool.Creations
  alias IdeaPool.Creations.Idea

  @create_attrs %{
    confidence: 42,
    content: "some content",
    ease: 42,
    impact: 42
  }
  @update_attrs %{
    confidence: 43,
    content: "some updated content",
    ease: 43,
    impact: 43
  }
  @invalid_attrs %{confidence: nil, content: nil, ease: nil, impact: nil}

  def fixture(:idea) do
    {:ok, idea} = Creations.create_idea(@create_attrs)
    idea
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all ideas", %{conn: conn} do
      conn = get(conn, Routes.idea_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create idea" do
    test "renders idea when data is valid", %{conn: conn} do
      conn = post(conn, Routes.idea_path(conn, :create), idea: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.idea_path(conn, :show, id))

      assert %{
               "id" => id,
               "confidence" => 42,
               "content" => "some content",
               "ease" => 42,
               "impact" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.idea_path(conn, :create), idea: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update idea" do
    setup [:create_idea]

    test "renders idea when data is valid", %{conn: conn, idea: %Idea{id: id} = idea} do
      conn = put(conn, Routes.idea_path(conn, :update, idea), idea: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.idea_path(conn, :show, id))

      assert %{
               "id" => id,
               "confidence" => 43,
               "content" => "some updated content",
               "ease" => 43,
               "impact" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, idea: idea} do
      conn = put(conn, Routes.idea_path(conn, :update, idea), idea: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete idea" do
    setup [:create_idea]

    test "deletes chosen idea", %{conn: conn, idea: idea} do
      conn = delete(conn, Routes.idea_path(conn, :delete, idea))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.idea_path(conn, :show, idea))
      end
    end
  end

  defp create_idea(_) do
    idea = fixture(:idea)
    {:ok, idea: idea}
  end
end
