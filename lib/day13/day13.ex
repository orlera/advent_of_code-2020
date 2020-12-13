defmodule V2020.Day13 do
  @input_file_part1 "lib/day13/input.txt"
  @input_file_part2 "lib/day13/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input_p1()
    |> next_bus()
    |> multiply()
    |> IO.puts()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input_p2()
    |> align_schedule()
    |> IO.puts()
  end

  defp parse_input_p1(file_path) do
    rules =
      file_path
      |> File.read!()
      |> String.split("\n")

    {Enum.at(rules, 0) |> String.to_integer(),
     Enum.at(rules, 1)
     |> String.split(",")
     |> Enum.reject(&(&1 == "x"))
     |> Enum.map(&String.to_integer(&1))}
  end

  defp next_bus({start_time, schedule}) do
    schedule
    |> Enum.map(&{&1, rem(start_time, &1)})
    |> Enum.max_by(fn {_, minutes} -> minutes end)
  end

  defp multiply({bus_id, minutes}), do: bus_id * (bus_id - minutes)

  defp parse_input_p2(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.at(1)
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.reject(fn {bus_id, _} -> bus_id == "x" end)
    |> Enum.map(fn {bus_id, index} -> {bus_id |> String.to_integer(), index} end)
  end

  defp align_schedule(schedule) do
    {timestamp, _} = Enum.reduce(schedule, {0, 1}, &align_with_previous_busses/2)
    timestamp
  end

  defp align_with_previous_busses(bus, {timestamp, next_step} = current_alignment) do
    bus_aligned?(bus, current_alignment) ||
      align_with_previous_busses(bus, {timestamp + next_step, next_step})
  end

  defp bus_aligned?({bus_id, index}, {timestamp, next_step}) do
    case rem(timestamp + index, bus_id) do
      0 -> {timestamp, least_common_multiple(next_step, bus_id)}
      _ -> nil
    end
  end

  defp least_common_multiple(a, b), do: div(a * b, Integer.gcd(a, b))
end
