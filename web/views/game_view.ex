defmodule Four.GameView do
  use Four.Web, :view
  @column_size 7

  alias Four.Board

  def render_board(conn, game) do
    Four.BoardView.render_board(conn, game)
  end

  def player_names(game) do
    [player1, player2] = game.players
    "#{player1.name} vs. #{player2.name}"
  end

  def active_player(game) do

  end
end
