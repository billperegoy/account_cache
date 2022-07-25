defmodule AccountCacheWeb.AccountController do
  use AccountCacheWeb, :controller

  alias AccountCache.{Customer, Repo}

  def index(conn, _params) do
    accounts = Customer.list_accounts()
    render(conn, "index.html", accounts: accounts)
  end
end
