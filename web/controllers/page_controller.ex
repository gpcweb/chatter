defmodule Chatter.PageController do
  use Chatter.Web, :controller

  plug Coherence.Authentication.Session, [protected: true] when action == :index

  def welcome(conn, _params) do
    render conn, "welcome.html"
  end

  def index(conn, _params) do
    render conn, "index.html"
  end
end
