defmodule IdeaPoolWeb.UserController do
  use IdeaPoolWeb, :controller

  alias IdeaPool.Accounts
  alias IdeaPool.Accounts.User
  alias IdeaPoolWeb.TokenController

  action_fallback IdeaPoolWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         tokens <- TokenController.create_pair(user) do
      conn
      |> put_status(:created)
      |> put_view(IdeaPoolWeb.TokenView)
      |> render("tokens.json", tokens)
    end
  end

  def show(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
