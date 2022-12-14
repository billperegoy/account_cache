defmodule AccountCache.Customer.AccountETS do
  use GenServer

  alias AccountCache.Customer

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  # Server (callbacks)
  @impl true
  def init(_) do
    IO.puts("Initializing Account ETS")
    :ets.new(:accounts, [:set, :public, :named_table])

    Customer.list_accounts()
    |> Enum.each(fn account ->
      :ets.insert(:accounts, {"#{account.id}", account})
    end)

    IO.puts("Done filling accounts ETS")

    {:ok, nil}
  end
end
