defmodule V2020.Day3 do
  @line_length 31
  @input_file_part1 "lib/day3/input.txt"
  @input_file_part2 "lib/day3/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> Enum.reduce({0, 0}, fn element, {_tree_number, x_position} = acc ->
      element
      |> String.at(x_position |> rem(@line_length))
      |> maybe_add_tree(acc)
    end)
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> Enum.count()
    |> IO.puts()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
  end

  defp maybe_add_tree("#", {trees, x_position}) do
    {trees + 1, x_position + 3}
  end
  defp maybe_add_tree(_, {trees, x_position}), do: {trees, x_position + 3}
end
