defmodule AccountCache.Repo.Migrations.AccountsAndEvents do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      timestamps type: :utc_datetime_usec
    end

    create table(:account_events) do
      add :type, :string, null: false
      add :amount, :float, null: false
      add :account_id, references(:accounts)

      timestamps type: :utc_datetime_usec
    end
  end
end
