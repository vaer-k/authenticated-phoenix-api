defmodule IdeaPoolWeb.TokenController do
  use IdeaPoolWeb, :controller

  alias IdeaPool.Tokens
  alias IdeaPool.Accounts
  alias IdeaPool.Accounts.User
  alias IdeaPool.Accounts.Guardian

  action_fallback IdeaPoolWeb.FallbackController

  def login(conn, %{"email" => email, "password" => pass}) do
    case Accounts.authenticate_user(email, pass) do
      {:ok, user} ->
        tokens = create_pair(user)

        conn
        |> put_status(201)
        |> render("tokens.json", tokens)

      {:error, _} ->
        {:error, :unauthorized}
    end
  end

  def logout(conn, %{"refresh_token" => token}) do
    Tokens.delete(Tokens, token)
    send_resp(conn, 204, "")
  end

  def refresh(conn, %{"refresh_token" => token}) do
    case lookup_refresh(token) do
      {:ok, user_id} ->
        user = Accounts.get_user!(user_id)
        jwt = create_access(user)
        render(conn, "jwt.json", jwt: jwt)

      :error ->
        {:error, :unauthorized}
    end
  end

  def create_access(%User{} = user) do
    {:ok, jwt, _claims} = Guardian.encode_and_sign(user, %{}, ttl: {10, :weeks})
    jwt
  end

  def create_refresh(%User{} = user) do
    {:ok, token, _claims} =
      Guardian.encode_and_sign(user, %{}, token_type: "refresh", ttl: {2, :weeks})

    Tokens.create(Tokens, {token, user.id})
    token
  end

  def lookup_refresh(refresh_token) do
    Tokens.lookup(Tokens, refresh_token)
  end

  def create_pair(%User{} = user) do
    %{jwt: create_access(user), refresh_token: create_refresh(user)}
  end
end
