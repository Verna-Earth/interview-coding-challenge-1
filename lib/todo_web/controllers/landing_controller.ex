defmodule ToDoWeb.LandingController do
  alias ToDo.Accounts
  use ToDoWeb, :controller

  @doc """
  Renders the landing page.
  """
  def home(conn, _params) do
    render(conn, :home, layout: false, changeset: %{})
  end

  def login(conn, %{"user" => %{"email" => email}}) do
    user = Accounts.user_exists?(email) |> IO.inspect()

    if user do
      conn
      |> put_flash(:info, "That works!")
      |> redirect(to: ~p"/")
    else
      conn
      |> put_flash(:error, "Sorry, the only user is lacks_imagination@hotmail.com")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
