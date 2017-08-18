defmodule Chatter.UserController do
  use Chatter.Web, :controller
  use Coherence.Config
  alias Chatter.User

  def log_in(conn, %{"email" => email, "password" => password}) do
    user = User.find_by(:email, email)
    if user do
      if valid_user_login?(user, password) do
        conn
          |> put_status(:ok)
          |> render("user.json", authenticated_user(user, conn))
      else
        conn
          |> put_status(:unauthorized)
          |> render("error.json")
      end
    else
      conn
        |> put_status(:unauthorized)
        |> render("error.json")
    end
  end


  defp valid_user_login?(user, password) do
    user.__struct__.checkpw(password, Map.get(user, Config.password_hash()))
  end

  defp authenticated_user(user, conn) do
    %{user | token: Phoenix.Token.sign(conn, "UserAuth", user.id)}
  end
end
