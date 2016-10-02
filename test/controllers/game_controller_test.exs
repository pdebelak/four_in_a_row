defmodule Four.GameControllerTest do
  use Four.ConnCase

  alias Four.Game

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "shows chosen game", %{conn: conn} do
    game = Game.start_game("foo", "bar")
    conn = get conn, "/games/#{game.uuid}"
    assert json_response(conn, 200)["game"]["uuid"] == game.uuid
  end

  test "404s with error when game not found", %{conn: conn} do
    conn = get conn, "/games/blah"
    assert json_response(conn, 404)["error"] == "No game found"
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, "/games"
    assert json_response(conn, 201)["game"]["uuid"]
  end

  test "makes a move with valid move", %{conn: conn} do
    game = Game.start_game("foo", "bar")
    conn = put conn, "/games/#{game.uuid}", %{ "column": 1, "player": game.active_player }
    assert json_response(conn, 200)["game"]["uuid"] == game.uuid
    assert json_response(conn, 200)["board"] == [[1], [], [], [], [], [], []]
  end

  test "gives error message with invalid move", %{conn: conn} do
    game = Game.start_game("foo", "bar")
    conn = put conn, "/games/#{game.uuid}", %{ "column": 1, "player": game.active_player + 1 }
    assert json_response(conn, 400)["error"] == "Invalid move"
  end
end
