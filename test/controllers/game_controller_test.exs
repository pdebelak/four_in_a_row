defmodule Four.GameControllerTest do
  use Four.ConnCase

  alias Four.Game

  test "shows chosen game", %{conn: conn} do
    game = Game.start_game("foo", "bar")
    conn = conn |>
    assign(:player, %{ name: "foo", player: 1 }) |>
    get("/games/#{game.uuid}")
    assert html_response(conn, 200) =~ hd(game.players).name
  end

  test "404s with error when game not found", %{conn: conn} do
    assert_raise Four.GameController.NoGameError, fn -> get conn, "/games/blah" end
  end

  test "creates and redirects to show", %{conn: conn} do
    conn = post conn, "/games"
    assert redirected_to(conn) =~ "/games/"
  end

  test "makes a move with valid move", %{conn: conn} do
    game = Game.start_game("foo", "bar")
    conn = conn |>
    assign(:player, %{ name: "foo", player: 1 }) |>
    put("/games/#{game.uuid}", %{ "column" => 1  })
    assert html_response(conn, 200) =~ hd(game.players).name
  end

  test "gives error with invalid move", %{conn: conn} do
    game = Game.start_game("foo", "bar")
    assert_raise Four.GameController.InvalidMoveError, fn -> put conn, "/games/#{game.uuid}", %{ "column": 8 } end
  end
end
