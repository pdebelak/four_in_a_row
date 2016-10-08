defmodule Four.BoardView do
  use Four.Web, :view
  @column_size 7

  alias Four.Board

  def render_board(conn, game) do
    game |>
    Board.for_game() |>
    pad_board() |>
    board_to_html(conn, game)
  end

  defp pad_board(board) do
    board |>
    Enum.map(&pad_column/1)
  end

  defp pad_column(col) do
    padding = @column_size - length(col)
    col ++ List.duplicate(nil, padding)
  end

  defp board_to_html(board, conn, game) do
    content_tag :div, class: board_class(conn, game) do
      board |>
      Enum.map(&col_to_html/1)
    end
  end

  defp board_class(conn, game) do
    if is_active?(conn, game) do
      "board active"
    else
      "board"
    end
  end

  defp is_active?(conn, game) do
    Plug.Conn.get_session(conn, :username) == game.active_player.name
  end

  defp col_to_html(col) do
    content_tag :div, class: "board--col" do
      for space <- col do
        content_tag :div, "", class: item_class(space)
      end
    end
  end

  defp item_class(space) do
    default_class = "board--item"
    case space do
      1 -> "#{default_class} #{default_class}__player-1"
      2 -> "#{default_class} #{default_class}__player-2"
      nil -> default_class
    end
  end
end
