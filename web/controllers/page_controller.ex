defmodule Four.PageController do
  use Four.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
