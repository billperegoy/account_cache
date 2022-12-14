defmodule AccountCache.Customer do
  alias AccountCache.{Customer, Repo}
  import Ecto.Query, warn: false

  def list_cached_accounts do
    :ets.match(:accounts, :"$1")
    |> Enum.map(fn [{_id, account}] -> account end)
    |> Enum.reject(&(&1.balance == 0.0))
    |> Enum.sort_by(& &1.balance, :desc)
  end

  def list_accounts(ids) do
    from(account in Customer.Account, where: account.id in ^ids)
    |> Repo.all()
    |> Repo.preload(:events)
    |> with_balance()
  end

  def list_accounts do
    Customer.Account
    |> Repo.all()
    |> Repo.preload(:events)
    |> with_balance()
  end

  def create_event(attrs) do
    %Customer.AccountEvent{}
    |> Customer.AccountEvent.changeset(attrs)
    |> Repo.insert()
    |> add_to_ets()
  end

  defp with_balance(accounts) do
    Enum.map(accounts, fn account ->
      credit_events =
        account
        |> Map.get(:events)
        |> Enum.filter(&(&1.type == :credit))
        |> Enum.count()

      debit_events =
        account
        |> Map.get(:events)
        |> Enum.filter(&(&1.type == :debit))
        |> Enum.count()

      %{
        account
        | balance: balance_for(account),
          credit_events: credit_events,
          debit_events: debit_events
      }
    end)
  end

  defp balance_for(%Customer.Account{events: events}) do
    Enum.reduce(events, 0.00, fn
      %{type: type} = event, sum ->
        case type do
          :debit ->
            sum + event.amount

          :credit ->
            sum - event.amount
        end
    end)
    |> Float.round(2)
  end

  defp add_to_ets({:ok, %Customer.AccountEvent{account_id: account_id}} = result) do
    Customer.EventETS.add_event(AccountCache.Customer.EventETS, account_id)

    result
  end
end
