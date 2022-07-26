defmodule AccountCache.Customer.CacheUpdater do
  use GenServer

  alias AccountCache.Customer

  @cache_update_interval Application.fetch_env!(:account_cache, :cache_update_interval)

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
    IO.puts("Updating accounts cache")
    events = :ets.match(:events, :"$1")

    :ets.delete_all_objects(:events)

    events
    |> Enum.map(fn [{id, _}] -> id end)
    |> Customer.list_accounts()
    |> Enum.each(fn account ->
      :ets.insert(:accounts, {"#{account.id}", account})
    end)
  end

  defp schedule_next do
    # Schedule every 2 minutes
    Process.send_after(self(), :update_cache, @cache_update_interval)
  end
end
