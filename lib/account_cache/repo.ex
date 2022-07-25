defmodule AccountCache.Repo do
  use Ecto.Repo,
    otp_app: :account_cache,
    adapter: Ecto.Adapters.Postgres
end
