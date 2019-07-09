defmodule IdeaPool.Repo do
  use Ecto.Repo,
    otp_app: :ideaPool,
    adapter: Ecto.Adapters.Postgres
end
