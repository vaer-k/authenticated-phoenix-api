defmodule IdeaPoolWeb.IdeaController do
  use IdeaPoolWeb, :controller

  alias IdeaPool.Creations
  alias IdeaPool.Creations.Idea

  action_fallback IdeaPoolWeb.FallbackController

  def index(conn, %{"page" => page}) do
    user = Guardian.Plug.current_resource(conn)
    ideas = Creations.list_user_ideas(user)
    page = String.to_integer(page) - 1

    render(conn, "index.json", ideas: ideas, page: page)
  end

  def index(conn, params) do
    params = Map.put(params, "page", "1")
    index(conn, params)
  end

  def create(conn, idea_params) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %Idea{} = idea} <- Creations.create_idea(user, idea_params) do
      conn
      |> put_status(:created)
      |> render("show.json", idea: idea, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    idea = Creations.get_idea!(id)
    render(conn, "show.json", idea: idea)
  end

  def update(conn, %{"id" => id} = idea_params) do
    idea = Creations.get_idea!(id)
    idea_params = Map.delete(idea_params, "id")

    with {:ok, %Idea{} = idea} <- Creations.update_idea(idea, idea_params) do
      render(conn, "show.json", idea: idea)
    end
  end

  def delete(conn, %{"id" => id}) do
    idea = Creations.get_idea_by(id: id)

    if idea do
      {:ok, %Idea{}} = Creations.delete_idea(idea)
    end

    send_resp(conn, :no_content, "")
  end
end
