defmodule Rubyday.PageController do
  use Rubyday.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
