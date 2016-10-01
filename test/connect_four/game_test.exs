defmodule Four.GameTest do
  use ExUnit.Case, async: true

  alias Four.Game

  test "it starts a game with uuid and player names" do
    player1_name = "foo"
    player2_name = "bar"
    %{uuid: uuid, players: [player1, player2]} = Game.start_game(player1_name, player2_name)
    assert uuid
    assert player1.player == 1
    assert player1.name == player1_name
    assert player2.player == 2
    assert player2.name == player2_name
  end

  test "it can look up a game" do
    player1_name = "foo"
    player2_name = "bar"
    %{uuid: uuid} = Game.start_game(player1_name, player2_name)
    {:ok, game} = Game.find(uuid)
    [player1, player2] = game.players
    assert player1.player == 1
    assert player1.name == player1_name
    assert player2.player == 2
    assert player2.name == player2_name
  end

  test "it replies with error if no game found" do
    assert {:error, "No game found"} == Game.find("bad-uuid")
  end

  test "starts with player 1 as active player" do
    %{ active_player: active_player } = Game.start_game("foo", "bar")
    assert active_player == 1
  end

  test "it can move" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    {:ok, game} = Game.move(uuid, %{ player: 1, column: 2 })
    [move] = game.moves
    assert move.player == 1
    assert move.column == 2
  end

  test "saves the move in storage" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    Game.move(uuid, %{ player: 1, column: 2 })
    {:ok, game} = Game.find(uuid)
    [move] = game.moves
    assert move.player == 1
    assert move.column == 2
  end

  test "it changes the active player" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    {:ok, game} = Game.move(uuid, %{ player: 1, column: 2 })
    assert game.active_player == 2
  end

  test "move with bad uuid" do
    assert {:error, "No game found"} == Game.move("foo", %{ player: 1, column: 2 })
  end

  test "column does not exist (too high)" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    assert {:error, "Invalid move"} == Game.move(uuid, %{ player: 1, column: 8 })
  end

  test "column does not exist (too low)" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    assert {:error, "Invalid move"} == Game.move(uuid, %{ player: 1, column: 0 })
  end

  test "when non-active player tries to move" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    assert {:error, "Invalid move"} == Game.move(uuid, %{ player: 2, column: 2 })
  end

  test "when trying to move into full column" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    for num <- 1..6 do
      {:ok, _} = Game.move(uuid, %{ player: rem(num + 1, 2) + 1, column: 2 })
    end
    assert {:error, "Invalid move"} == Game.move(uuid, %{ player: 1, column: 2 })
  end

  test "it doesn't save invalid moves" do
    %{ uuid: uuid } = Game.start_game("foo", "bar")
    for num <- 1..6 do
      {:ok, _} = Game.move(uuid, %{ player: rem(num + 1, 2) + 1, column: 2 })
    end
    {:ok, game} = Game.find(uuid)
    assert length(game.moves) == 6
    Game.move(uuid, %{ player: 1, column: 2 })
    {:ok, game} = Game.find(uuid)
    assert length(game.moves) == 6
  end
end
