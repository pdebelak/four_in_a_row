defmodule ConnectFour.BoardTest do
  use ExUnit.Case, async: true

  alias ConnectFour.Game
  alias ConnectFour.Board

  test "for game is 7 empty lists for new game" do
    game = Game.start_game("foo", "bar")
    board = Board.for_game(game)
    assert [[],[],[],[],[],[],[]] == board
    assert 7 == length(board)
  end

  test "for game with one move" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    Game.move(uuid, %{ player: 1, column: 2 })
    {:ok, game} = Game.find(uuid)
    board = Board.for_game(game)
    assert [[],[1],[],[],[],[],[]] == board
  end

  test "for game with two moves" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    Game.move(uuid, %{ player: 1, column: 2 })
    Game.move(uuid, %{ player: 2, column: 2 })
    {:ok, game} = Game.find(uuid)
    board = Board.for_game(game)
    assert [[],[1, 2],[],[],[],[],[]] == board
  end

  test "winner with no winner" do
    game = Game.start_game("foo", "bar")
    board = Board.for_game(game)
    assert nil == Board.winner(board)
  end

  test "winner with vertical win" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    Game.move(uuid, %{ player: 1, column: 2 })
    Game.move(uuid, %{ player: 2, column: 3 })
    Game.move(uuid, %{ player: 1, column: 2 })
    Game.move(uuid, %{ player: 2, column: 3 })
    Game.move(uuid, %{ player: 1, column: 2 })
    Game.move(uuid, %{ player: 2, column: 3 })
    Game.move(uuid, %{ player: 1, column: 2 })
    {:ok, game} = Game.find(uuid)
    winner = Board.for_game(game) |> Board.winner()
    assert 1 == winner
  end

  test "winner with horizontal win" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    Game.move(uuid, %{ player: 1, column: 1 })
    Game.move(uuid, %{ player: 2, column: 2 })
    Game.move(uuid, %{ player: 1, column: 1 })
    Game.move(uuid, %{ player: 2, column: 3 })
    Game.move(uuid, %{ player: 1, column: 2 })
    Game.move(uuid, %{ player: 2, column: 4 })
    Game.move(uuid, %{ player: 1, column: 3 })
    Game.move(uuid, %{ player: 2, column: 5 })
    {:ok, game} = Game.find(uuid)
    winner = Board.for_game(game) |> Board.winner()
    assert 2 == winner
  end
end
