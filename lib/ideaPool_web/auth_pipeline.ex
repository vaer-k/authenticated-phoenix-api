defmodule IdeaPoolWeb.Accounts.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :ideaPool,
    error_handler: IdeaPool.Accounts.AuthErrorHandler,
    module: IdeaPool.Accounts.Guardian

  plug Guardian.Plug.VerifyCustomHeader,
    header_name: "x-access-token",
    realm: :none,
    claims: %{"typ" => "access"}

  plug Guardian.Plug.LoadResource
end
