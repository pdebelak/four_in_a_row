defmodule Four.PageControllerTest do
  use Four.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Four"
  end
end
