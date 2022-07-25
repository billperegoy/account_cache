defmodule AccountCache.Customer.AccountEvent do
  use Ecto.Schema
  import Ecto.Changeset

  alias AccountCache.Customer

  schema "account_events" do
    field :type, Ecto.Enum, values: [:credit, :debit]
    field :amount, :float

    belongs_to :account, Customer.Account

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(event, attrs) do
    required = [:type, :amount, :account_id]

    event
    |> cast(attrs, required)
    |> validate_required(required)
  end
end
