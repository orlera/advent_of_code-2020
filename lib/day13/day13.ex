defmodule V2020.Day13 do
  @input_file_part1 "lib/day13/input.txt"
  @input_file_part2 "lib/day13/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> next_bus()
    |> multiply()
    |> IO.puts()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
  end

  defp parse_input(file_path) do
    rules =
      file_path
      |> File.read!()
      |> String.split("\n")

    {Enum.at(rules, 0) |> String.to_integer(),
    Enum.at(rules, 1) |> String.split(",") |> Enum.reject(& &1 == "x") |> Enum.map(& String.to_integer(&1))}
  end

  defp next_bus({start_time, schedule}) do
    schedule
    |> Enum.map(& {&1, rem(start_time, &1)})
    |> Enum.max_by(fn {_, minutes} -> minutes end)
  end

  defp multiply({bus_id, minutes}), do: bus_id * (bus_id - minutes)
end
