defmodule Four.Game do
  use GenServer

  alias Four.Board

  defstruct uuid: "", players: [], moves: [], active_player: nil, winner: nil

  defmodule Move do
    defstruct player: 0, column: 0
  end

  defmodule Player do
    defstruct player: 0, name: ""
  end

  @ttl 86400 # one day
  @name :games
  @invalid_move "Invalid move"

  def start_game(player1, player2) do
    GenServer.call(__MODULE__, {:new, player1, player2})
  end

  def find(uuid) do
    GenServer.call(__MODULE__, {:find, uuid})
  end

  def move(uuid, move) do
    GenServer.call(__MODULE__, {:move, uuid, move})
  end

  def with_board(game), do: %{ game: game, board: Board.for_game(game) }

  defp initiate_game(player1, player2) do
    uuid = UUID.uuid4()
    create_game(uuid, player1, player2)
    |> insert_game()
  end

  defp create_game(uuid, player1, player2) do
    %__MODULE__{
      uuid: uuid,
      players: [
        %__MODULE__.Player{ player: 1, name: player1 },
        %__MODULE__.Player{ player: 2, name: player2 },
      ],
      active_player: %__MODULE__.Player{ player: 1, name: player1 }
    }
  end

  defp insert_game(game) do
    :ets.insert(@name, {game.uuid, game, expiration()})
    game
  end

  defp expiration do
    :os.system_time(:seconds) + @ttl
  end

  defp find_game(uuid) do
    case :ets.lookup(@name, uuid) do
      [] -> {:error, "No game found"}
      [{^uuid, game, _expiration}] -> {:ok, game}
    end
  end

  defp move_game(_uuid, %{ column: column }) when column > 7, do: {:error, @invalid_move}
  defp move_game(_uuid, %{ column: column }) when column < 1, do: {:error, @invalid_move}
  defp move_game(uuid, %{ player: player, column: column }) do
    case find_game(uuid) do
      {:error, message} -> {:error, message}
      {:ok, game} -> make_move(game, player, column)
    end
  end

  defp make_move(game, player, column) do
    move = %__MODULE__.Move{ player: player, column: column }
    game = %{ game | moves: game.moves ++ [move], active_player: alternate_player(game) }
    if valid_move?(move, game) do
      {:ok, insert_game(game)}
    else
      {:error, @invalid_move}
    end
  end

  defp alternate_player(%{ active_player: %{ player: 1 }, players: players }) do
    Enum.find(players, fn (player) -> player.player == 2 end)
  end
  defp alternate_player(%{ active_player: %{ player: 2 }, players: players }) do
    Enum.find(players, fn (player) -> player.player == 1 end)
  end

  defp valid_move?(move, game) do
    valid_player?(move, game) && valid_column?(move, game)
  end

  defp valid_player?(%{ player: player }, %{ active_player: active_player }), do: player != active_player.player

  defp valid_column?(%{ column: column }, %{ moves: moves }) do
    moves |>
    Enum.filter(fn (move) -> move.column == column end) |>
    length() <= 6
  end

  # GenServer callbacks

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_args) do
    :ets.new(@name, [:named_table, :set, :private])
    {:ok, %{}}
  end

  def handle_call({:new, player1, player2}, _from, state) do
    {:reply, initiate_game(player1, player2), state}
  end
  def handle_call({:find, uuid}, _from, state) do
    {:reply, find_game(uuid), state}
  end
  def handle_call({:move, uuid, move}, _from, state) do
    {:reply, move_game(uuid, move), state}
  end
end

defimpl Phoenix.Param, for: Four.Game do
    def to_param(game), do: game.uuid
end
