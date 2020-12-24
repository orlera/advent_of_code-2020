defmodule V2020.Day24 do
  @input_file_part1 "lib/day24/input.txt"
  @input_file_part2 "lib/day24/input.txt"
  @empty_directions %{"e" => 0, "ne" => 0, "se" => 0, "w" => 0, "nw" => 0, "sw" => 0}

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> normalize_tiles()
    |> Enum.frequencies()
    |> Enum.filter(&(elem(&1, 1) |> rem(2) != 0))
    |> length()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
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
end
