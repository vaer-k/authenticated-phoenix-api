defmodule IdeaPoolWeb.UserView do
  use IdeaPoolWeb, :view
  alias IdeaPoolWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      email: user.email,
      name: user.name,
      avatar_url: get_gravatar(user)
    }
  end

  defp get_gravatar(user) do
    email_hash =
      user.email
      |> (&:crypto.hash(:md5, &1)).()
      |> Base.encode16()

    "https://www.gravatar.com/avatar/#{email_hash}?d=mm&s=200"
  end
end
