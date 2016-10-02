defmodule Four.GameView do
  use Four.Web, :view

  alias Four.Board

  def render("show.json", %{game: game}) do
    %{game: game, board: Board.for_game(game)}
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end
end
