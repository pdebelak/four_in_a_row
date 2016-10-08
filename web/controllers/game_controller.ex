defmodule Four.GameController do
  use Four.Web, :controller
  plug :assign_player

  alias Four.Game

  def create(conn, _params) do
    game = Game.start_game("foo", "bar")
    conn |>
    put_session(:username, "foo") |>
    redirect(to: game_path(conn, :show, game))
  end

  def show(conn, %{"id" => id}) do
    conn = case !!conn.assigns[:player].name do
      false -> put_session(conn, :username, "bar") |> assign_player(nil)
      true -> conn
    end

    case Game.find(id) do
      {:ok, game} ->
        conn |>
        put_session(:player_num, Enum.find(game.players, fn (player) -> player.name == conn.assigns[:player].name end).player) |>
        render("show.html", game: game)
      {:error, _message} ->
        raise __MODULE__.NoGameError
    end
  end

  def update(conn, %{"id" => id, "column" => column}) do
    case Game.move(id, %{column: column, player: conn.assigns[:player].player}) do
      {:ok, game} ->
        Four.Endpoint.broadcast! "game:#{id}", "new_move", Game.with_board(game)
        render(conn, "show.html", game: game)
      {:error, _message} ->
        raise __MODULE__.InvalidMoveError
    end
  end

  defp assign_player(conn, _) do
    if conn.assigns[:player] do
      conn
    else
      assign conn, :player, %{ name: get_session(conn, :username), player: get_session(conn, :player_num)}
    end
  end

  defmodule NoGameError do
    @moduledoc """
    Exception raised when no game is found.
    """
    defexception plug_status: 404, message: "no game found", conn: nil, router: nil

    def exception(_opts) do
      %NoGameError{message: "no game found"}
    end
  end

  defmodule InvalidMoveError do
    @moduledoc """
    Exception raised when an invalid move is made.
    """

    defexception plug_status: 500, message: "Invalid move", conn: nil, router: nil

    def exception(_opts) do
      %InvalidMoveError{message: "Invalid Move"}
    end
  end
end

defimpl Plug.Exception, for: Four.GameController.NoGameError do
  def status(_exception), do: 404
end

defimpl Plug.Exception, for: Four.GameController.InvalidMoveError do
  def status(_exception), do: 500
end
