defmodule AccountCache.Customer.Account do
  use Ecto.Schema

  alias AccountCache.Customer

  schema "accounts" do
    field :name, :string
    field :balance, :float, virtual: true
    field :debit_events, :integer, virtual: true
    field :credit_events, :integer, virtual: true

    has_many :events, Customer.AccountEvent

    timestamps(type: :utc_datetime_usec)
  end
end
