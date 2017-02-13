defmodule Chatter.ChattController do
  use Chatter.Web, :controller

  def lobby(conn, _params) do
    render conn, "lobby.html"
  end
end
