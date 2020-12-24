defmodule V2020.Day24 do
  @input_file_part1 "lib/day24/input.txt"
  @input_file_part2 "lib/day24/input.txt"
  @empty_directions %{"e" => 0, "ne" => 0, "se" => 0, "w" => 0, "nw" => 0, "sw" => 0}

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> normalize_tiles()
    |> black_tiles()
    |> length()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> normalize_tiles()
    |> black_tiles()
    |> flip_tiles()
    |> length()
    |> IO.inspect()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn tile ->
      parse_tile(tile, @empty_directions)
    end)
  end

  defp parse_tile("", directions), do: directions

  defp parse_tile("e" <> rest, directions),
    do: update_directions_map(directions, "e") |> (&parse_tile(rest, &1)).()

  defp parse_tile("w" <> rest, directions),
    do: update_directions_map(directions, "w") |> (&parse_tile(rest, &1)).()

  defp parse_tile("sw" <> rest, directions),
    do: update_directions_map(directions, "sw") |> (&parse_tile(rest, &1)).()

  defp parse_tile("se" <> rest, directions),
    do: update_directions_map(directions, "se") |> (&parse_tile(rest, &1)).()

  defp parse_tile("nw" <> rest, directions),
    do: update_directions_map(directions, "nw") |> (&parse_tile(rest, &1)).()

  defp parse_tile("ne" <> rest, directions),
    do: update_directions_map(directions, "ne") |> (&parse_tile(rest, &1)).()

  defp update_directions_map(map, direction), do: Map.update(map, direction, 1, &(&1 + 1))

  defp normalize_tiles(tiles) do
    Enum.map(tiles, fn directions ->
      {directions["ne"] - directions["sw"] + directions["e"] - directions["w"],
       directions["se"] - directions["nw"] + directions["e"] - directions["w"]}
    end)
  end

  defp black_tiles(tiles) do
    tiles
    |> Enum.frequencies()
    |> Enum.filter(&(elem(&1, 1) |> rem(2) != 0))
    |> Enum.map(& elem(&1, 0))
  end

  defp flip_tiles(black_tiles, day \\ 0) do
    case day do
      100 -> black_tiles
      _ -> do_flip_tiles(black_tiles, day)
    end
  end

  defp do_flip_tiles(black_tiles, day) do
    boundaries(black_tiles)
    |> create_floor()
    |> change_tiles(black_tiles)
    |> flip_tiles(day + 1)
  end

  defp boundaries(tiles), do: {Enum.map(tiles, & elem(&1, 0)) |> Enum.min_max(), Enum.map(tiles, & elem(&1, 1)) |> Enum.min_max()}

  defp create_floor({{minx, maxx}, {miny, maxy}}), do: for x <- minx-1..maxx+1, y <- miny-1..maxy+1, do: {x, y}

  defp change_tiles(floor, black_tiles), do: Enum.filter(floor, & black_after_change?(&1, black_tiles))

  defp black_after_change?(tile, black_tiles) do
    case is_black?(tile, black_tiles) do
      true -> case black_neighbours(tile, black_tiles) do
        flip when flip == 0 or flip > 2 -> false
        _ -> true
      end
      false -> case black_neighbours(tile, black_tiles) do
        2 -> true
        _ -> false
      end
    end
  end

  defp is_black?(tile, black_tiles), do: Enum.member?(black_tiles, tile)

  defp black_neighbours(tile, black_tiles) do
    tile
    |> neighbouring_tiles()
    |> Enum.count(& Enum.member?(black_tiles, &1))
  end

  defp neighbouring_tiles({x, y}), do: [{x-1, y-1}, {x-1, y}, {x, y-1}, {x, y+1}, {x+1, y}, {x+1, y+1}]
end
