defmodule AccountCache.Customer.EventETS do
  use GenServer

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def add_event(_pid, account_id) do
    :ets.insert(:events, {"#{account_id}", nil})
  end

  # Server (callbacks)
  @impl true
  def init(_) do
    # FIXME - why public?
    IO.puts("Initializing Event ETS")
    :ets.new(:events, [:set, :public, :named_table])

    {:ok, nil}
  end
end
