defmodule V2020.Day3 do
  @line_length 31
  @input_file_part1 "lib/day3/input.txt"
  @input_file_part2 "lib/day3/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> calculate_trees_in_slope({3, 1})
    |> IO.inspect()
  end

  def solution_part2() do
    slope =
    @input_file_part2
    |> parse_input()

    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(& slope |> calculate_trees_in_slope(&1))
    |> Enum.reduce(1, fn {trees, _}, acc -> trees * acc end)
    |> IO.puts()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
  end

  def calculate_trees_in_slope(slope, {right_steps, down_steps}) do
    slope
    |> Enum.with_index()
    |> Enum.reduce({0, 0}, fn {element, y_position}, {_tree_number, x_position} = acc ->
      if rem(y_position, down_steps) == 0 do
        element
        |> String.at(x_position |> rem(@line_length))
        |> maybe_add_tree(acc, right_steps)
      else
        acc
      end
    end)
  end

  defp maybe_add_tree("#", {trees, x_position}, right_steps), do: {trees + 1, x_position + right_steps}
  defp maybe_add_tree(_, {trees, x_position}, right_steps), do: {trees, x_position + right_steps}
end
