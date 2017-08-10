defmodule Chatter.UserView do
  use Chatter.Web, :view

  def render("show.json", %{user: user, token: token}) do
    %{data: render_one(user, token, Chatter.UserView, "user.json")}
  end

  def render("user.json", %{user: user, token: token}) do
    %{id: user.id,
      name: user.name,
      last_name: user.last_name,
      email: user.email,
      token: token}
  end
end
