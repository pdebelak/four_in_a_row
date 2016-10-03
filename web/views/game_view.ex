defmodule Four.GameView do
  use Four.Web, :view

  alias Four.Game

  def render("show.json", %{game: game}) do
    Game.with_board(game)
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end
end
