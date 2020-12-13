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
    |> align_schedule(100000000000000)
    |> aligned_schedule_timestamp()
    |> IO.inspect()
  end

  defp parse_input_p1(file_path) do
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

  defp align_schedule(schedule, next_step \\ 1) do
    updated_schedule = Enum.map(schedule, fn {bus_id, offset} -> {bus_id, offset + next_step} end)

    schedule_aligned?(updated_schedule) || align_schedule(updated_schedule)
  end

  defp schedule_aligned?(schedule) do
    case Enum.all?(schedule, fn {bus_id, offset} -> rem(offset, bus_id) == 0 end) do
      true -> schedule
      _ -> nil
    end
  end

  defp aligned_schedule_timestamp(schedule) do
    {_, timestamp} = List.first(schedule)

    timestamp
  end
end
