defmodule BulletWeb.PageController do
  use BulletWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: ~p"/goals")
    |> halt()
  end
end
