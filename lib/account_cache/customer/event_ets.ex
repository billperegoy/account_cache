defmodule AccountCache.Customer.EventETS do
  use GenServer

  alias AccountCache.{Customer, Repo}

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def add_event(pid, account_id) do
    IO.puts("In add_event with #{account_id}")
    :ets.insert(:events, {"#{account_id}", nil})

    :ets.match(:events, :"$1")
    |> IO.inspect(label: "event accounts")
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
