defmodule AccountCache.Customer do
  alias AccountCache.{Customer, Repo}

  def list_accounts do
    Customer.Account
    |> Repo.all()
    |> Repo.preload(:events)
    |> with_balance()
  end

  defp with_balance(accounts) do
    Enum.map(accounts, fn account ->
      %{account | balance: balance_for(account)}
    end)
  end

  defp balance_for(%Customer.Account{events: events}) do
    Enum.reduce(events, 0.00, fn event, sum ->
      sum + event.amount
    end)
  end
end
