defmodule IdeaPoolWeb.TokenView do
  use IdeaPoolWeb, :view
  alias IdeaPoolWeb.TokenView

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

  def render("refresh.json", %{refresh_token: token}) do
    %{refresh_token: token}
  end

  def render("tokens.json", %{jwt: jwt, refresh_token: refresh_token}) do
    %{jwt: jwt, refresh_token: refresh_token}
  end
end
