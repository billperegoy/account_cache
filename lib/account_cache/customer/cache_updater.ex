defmodule AccountCache.Customer.CacheUpdater do
  use GenServer

  alias AccountCache.{Customer, Repo}

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  # Server (callbacks)
  @impl true
  def init(_) do
    IO.puts("Initializing Cache Updater")
    schedule_next()
    {:ok, nil}
  end

  @impl true
  def handle_info(:update_cache, _) do
    update_cache()
    schedule_next()

    {:noreply, nil}
  end

  defp update_cache do
    IO.puts("updating accounts cache")
    events = :ets.match(:events, :"$1")

    :ets.delete_all_objects(:events)
    # TODO - Update the cache for only the accounts with events
    events
    |> Enum.map(fn [{id, _}] -> id end)
    |> Customer.list_accounts()
    |> Enum.each(fn account ->
      :ets.insert(:accounts, {"#{account.id}", account})
    end)
  end

  defp schedule_next do
    # Schedule every 2 minutes
    Process.send_after(self(), :update_cache, 2 * 60 * 1000)
  end
end
