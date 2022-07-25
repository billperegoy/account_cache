defmodule AccountCacheWeb.PageController do
  use AccountCacheWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
