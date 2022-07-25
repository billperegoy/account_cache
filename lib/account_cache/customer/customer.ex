defmodule AccountCache.Customer do
  alias AccountCache.{Customer, Repo}

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
  end

  defp with_balance(accounts) do
    Enum.map(accounts, fn account ->
      %{account | balance: balance_for(account)}
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
end
