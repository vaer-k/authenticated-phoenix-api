defmodule IdeaPool.Tokens do
  use GenServer

  def start_link(opts) do
    server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, server, opts)
  end

  def create(server, {token, user_id}) do
    GenServer.call(server, {:create, {token, user_id}})
  end

  def delete(server, token) do
    GenServer.call(server, {:delete, token})
  end

  def lookup(server, token) do
    case :ets.lookup(server, token) do
      [{^token, user_id}] -> {:ok, user_id}
      [] -> :error
    end
  end

  def init(table) do
    tokens = :ets.new(table, [:named_table, read_concurrency: true])
    {:ok, tokens}
  end

  def handle_call({:create, {token, user_id}}, _from, tokens) do
    case lookup(tokens, token) do
      {:ok, user_id} ->
        {:reply, {:ok, user_id}, tokens}

      :error ->
        :ets.insert(tokens, {token, user_id})
        {:reply, {:ok, user_id}, tokens}
    end
  end

  def handle_call({:delete, token}, _from, tokens) do
    :ets.delete(tokens, token)
    {:reply, :ok, tokens}
  end
end
