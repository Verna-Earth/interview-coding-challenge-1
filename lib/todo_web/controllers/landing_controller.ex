defmodule ToDoWeb.LandingController do
  alias ToDo.User
  alias ToDo.Repo
  use ToDoWeb, :controller
  import Ecto.Query, only: [from: 2]

  @doc """
  Renders the landing page.
  """
  def home(conn, _params) do
    render(conn, :home, layout: false, changeset: %{})
  end

  def login(conn, %{"user" => %{"email" => email}}) do
    user = ToDo.User.exists?(email)

    if user do
      conn
      |> Controller.put_flash(:info, "That works!")
      |> Controller.redirect(to: ~p"/")
    else
      conn
      |> Controller.put_flash(:error, "Sorry, the only user is lacks_imagination@hotmail.com")
      |> Controller.redirect(to: ~p"/")
      |> halt()
    end
  end
end
