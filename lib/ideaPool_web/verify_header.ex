defmodule Guardian.Plug.VerifyCustomHeader do
  alias Guardian.Plug.Pipeline

  import Plug.Conn

  @behaviour Plug

  @impl Plug
  @spec init(opts :: Keyword.t()) :: Keyword.t()
  def init(opts \\ []) do
    realm = Keyword.get(opts, :realm, "Bearer")

    case realm do
      "" ->
        opts

      :none ->
        opts

      _realm ->
        {:ok, reg} = Regex.compile("#{realm}\:?\s+(.*)$", "i")
        Keyword.put(opts, :realm_reg, reg)
    end
  end

  @impl Plug
  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(conn, opts) do
    with nil <- Guardian.Plug.current_token(conn, opts),
         {:ok, token} <- fetch_token_from_header(conn, opts),
         module <- Pipeline.fetch_module!(conn, opts),
         claims_to_check <- Keyword.get(opts, :claims, %{}),
         key <- storage_key(conn, opts),
         {:ok, claims} <- Guardian.decode_and_verify(module, token, claims_to_check, opts) do
      conn
      |> Guardian.Plug.put_current_token(token, key: key)
      |> Guardian.Plug.put_current_claims(claims, key: key)
    else
      :no_token_found ->
        conn

      {:error, reason} ->
        conn
        |> Pipeline.fetch_error_handler!(opts)
        |> apply(:auth_error, [conn, {:invalid_token, reason}, opts])
        |> halt()

      _ ->
        conn
    end
  end

  @spec fetch_token_from_header(Plug.Conn.t(), Keyword.t()) ::
          :no_token_found
          | {:ok, String.t()}
  defp fetch_token_from_header(conn, opts) do
    header_name = Keyword.get(opts, :header_name, "authorization")
    headers = get_req_header(conn, header_name)
    fetch_token_from_header(conn, opts, headers)
  end

  @spec fetch_token_from_header(Plug.Conn.t(), Keyword.t(), Keyword.t()) ::
          :no_token_found
          | {:ok, String.t()}
  defp fetch_token_from_header(_, _, []), do: :no_token_found

  defp fetch_token_from_header(conn, opts, [token | tail]) do
    reg = Keyword.get(opts, :realm_reg, ~r/^(.*)$/)
    trimmed_token = String.trim(token)

    case Regex.run(reg, trimmed_token) do
      [_, match] -> {:ok, String.trim(match)}
      _ -> fetch_token_from_header(conn, opts, tail)
    end
  end

  @spec storage_key(Plug.Conn.t(), Keyword.t()) :: String.t()
  defp storage_key(conn, opts), do: Pipeline.fetch_key(conn, opts)
end
