defmodule Four.GameController do
  use Four.Web, :controller

  alias Four.Game

  def create(conn, _params) do
    game = Game.start_game("foo", "bar")
    conn |>
    put_status(:created) |>
    render("show.json", game: game)
  end

  def show(conn, %{"id" => id}) do
    case Game.find(id) do
      {:ok, game} -> render(conn, "show.json", game: game)
      {:error, message} ->
        conn |>
        put_status(:not_found) |>
        render("error.json", message: message)
    end
  end

  def update(conn, %{"id" => id, "column" => column, "player" => player}) do
    case Game.move(id, %{column: column, player: player}) do
      {:ok, game} -> render(conn, "show.json", game: game)
      {:error, message} ->
        conn |>
        put_status(:bad_request) |>
        render("error.json", message: message)
    end
  end
end
