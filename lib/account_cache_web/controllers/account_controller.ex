defmodule AccountCacheWeb.AccountController do
  use AccountCacheWeb, :controller

  alias AccountCache.Customer

  def index(conn, _params) do
    accounts = Customer.list_cached_accounts()

    render(conn, "index.html", accounts: accounts)
  end
end
