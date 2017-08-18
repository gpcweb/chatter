defmodule Chatter.UserView do
  use Chatter.Web, :view

  def render("user.json", user) do
    %{ id: user.id,
       name: user.name,
       last_name: user.last_name,
       email: user.email,
       token: user.token }
  end

  def render("error.json", _assigns) do
    %{ message: "Unable to authenticate, please check email and password." }
  end
end
