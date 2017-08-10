defmodule Chatter.UserController do
  use Chatter.Web, :controller

  def log_in(conn, %{"email" => email, "password" => password}) do
    user = Chatter.User.find_by(:email, email)
    render(conn, "user.json", %{ user: user, token: Phoenix.Token.sign(conn, "UserAuth", user.id) })
  end
end
