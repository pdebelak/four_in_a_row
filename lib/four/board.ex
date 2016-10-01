defmodule Four.Board do
  def for_game(%{ moves: moves }) do
    for column <- 1..7 do
      moves_for_column(moves, column)
    end
  end

  defp moves_for_column(moves, column) do
    moves |>
    Enum.filter(fn (move) -> move.column == column end) |>
    Enum.map(fn (move) -> move.player end)
  end

  def winner(board) do
    vertical_winner(board) || horizontal_winner(board)
  end

  defp vertical_winner(board) do
    find_winner(board)
  end

  defp find_winner(collection) do
    winning_list = collection |>
    Enum.map(&collection_has_winner/1) |>
    Enum.find(&(&1))
    if winning_list do
      List.first(winning_list)
    end
  end

  defp collection_has_winner(col) do
    col |>
    Enum.chunk(4, 1) |>
    Enum.find(fn (items) ->
      Enum.dedup(items) |> length() == 1
    end)
  end

  defp horizontal_winner(board) do
    for row <- 0..5 do
      Enum.map(board, &Enum.at(&1, row))
    end |>
    find_winner()
  end
end
