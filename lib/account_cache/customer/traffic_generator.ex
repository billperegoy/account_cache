defmodule AccountCache.Customer.TrafficGenerator do
  use GenServer

  alias AccountCache.{Customer, Repo}

  @event_interval Application.fetch_env!(:account_cache, :event_interval)

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  # Server (callbacks)
  @impl true
  def init(_) do
    IO.puts("Initializing Traffic Generator")
    schedule_next()
    {:ok, nil}
  end

  @impl true
  def handle_info(:gen_traffic, _) do
    add_event()
    schedule_next()

    {:noreply, nil}
  end

  defp add_event do
    accounts = Repo.all(Customer.Account)
    account_count = Enum.count(accounts)
    random_index = Enum.random(0..(account_count - 1))

    account = Enum.at(accounts, random_index)

    type_index = Enum.random(0..1)
    type = Enum.at([:credit, :debit], type_index)
    amount = Enum.random(1000..100_000) / 100.0

    {:ok, _event} = Customer.create_event(%{type: type, amount: amount, account_id: account.id})
  end

  defp schedule_next do
    # Schedule every 2 seconds
    Process.send_after(self(), :gen_traffic, @event_interval)
  end
end
