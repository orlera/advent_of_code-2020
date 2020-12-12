defmodule V2020.Day12 do
  @input_file_part1 "lib/day12/input.txt"
  @input_file_part2 "lib/day12/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> follow_route({0, 0, "E"})
    |> manhattan_distance()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      {String.first(line), String.slice(line, 1, 4) |> String.to_integer()}
    end)
  end

  defp follow_route([step | rest], current_position) do
    next_position = execute_step(step, current_position)
    follow_route(rest, next_position)
  end

  defp follow_route([], current_position) do
    current_position
  end

  defp execute_step({"E", value}, {x, y, direction}), do: {x + value, y, direction}
  defp execute_step({"W", value}, {x, y, direction}), do: {x - value, y, direction}
  defp execute_step({"N", value}, {x, y, direction}), do: {x, y + value, direction}
  defp execute_step({"S", value}, {x, y, direction}), do: {x, y - value, direction}
  defp execute_step({"F", value}, {_, _, direction} = current_position), do: execute_step({direction, value}, current_position)
  defp execute_step(instruction, {x, y, current_direction}), do: {x, y, calculate_direction(instruction, current_direction)}

  defp calculate_direction({"L", 90}, "N"), do: "W"
  defp calculate_direction({"L", 180}, "N"), do: "S"
  defp calculate_direction({"L", 270}, "N"), do: "E"
  defp calculate_direction({"R", 90}, "N"), do: "E"
  defp calculate_direction({"R", 180}, "N"), do: "S"
  defp calculate_direction({"R", 270}, "N"), do: "W"

  defp calculate_direction({"L", 90}, "E"), do: "N"
  defp calculate_direction({"L", 180}, "E"), do: "W"
  defp calculate_direction({"L", 270}, "E"), do: "S"
  defp calculate_direction({"R", 90}, "E"), do: "S"
  defp calculate_direction({"R", 180}, "E"), do: "W"
  defp calculate_direction({"R", 270}, "E"), do: "N"

  defp calculate_direction({"L", 90}, "W"), do: "S"
  defp calculate_direction({"L", 180}, "W"), do: "E"
  defp calculate_direction({"L", 270}, "W"), do: "N"
  defp calculate_direction({"R", 90}, "W"), do: "N"
  defp calculate_direction({"R", 180}, "W"), do: "E"
  defp calculate_direction({"R", 270}, "W"), do: "S"

  defp calculate_direction({"L", 90}, "S"), do: "E"
  defp calculate_direction({"L", 180}, "S"), do: "N"
  defp calculate_direction({"L", 270}, "S"), do: "W"
  defp calculate_direction({"R", 90}, "S"), do: "W"
  defp calculate_direction({"R", 180}, "S"), do: "N"
  defp calculate_direction({"R", 270}, "S"), do: "E"

  defp manhattan_distance({x, y, _}) do
    abs(x) + abs(y)
  end
end
