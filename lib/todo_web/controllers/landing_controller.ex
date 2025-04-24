defmodule ToDoWeb.LandingController do
  alias ToDo.Accounts
  use ToDoWeb, :controller

  @doc """
  Renders the landing page.
  """
  def home(conn, _params) do
    render(conn, :home, layout: false, changeset: %{})
  end

  @doc """
  Very quick and dirty login function - in a real app this would be handled through Session properly.
  """
  def login(conn, %{"user" => %{"email" => email}}) do
    user = Accounts.get_user_by_email!(email)

    if user do
      conn
      |> put_flash(:info, "Signed in!")
      |> put_session(:user_id, user.id)
      |> put_session(:user_name, user.name)
      |> redirect(to: ~p"/tasks")
    else
      conn
      |> put_flash(:error, "Sorry, the only user is lacks_imagination@hotmail.com")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
