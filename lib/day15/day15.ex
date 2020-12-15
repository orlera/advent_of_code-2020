defmodule V2020.Day15 do
  @input_file_part1 "lib/day15/input.txt"
  @input_file_part2 "lib/day15/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> play_until(2020)
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> play_until(30000000)
    |> IO.inspect()
  end

  defp parse_input(file_path) do
    {turns, [last_turn]} =
      file_path
      |> File.read!()
      |> String.split(",")
      |> Enum.map(& String.to_integer(&1))
      |> Enum.split(-1)

    {turns
     |> Enum.with_index()
     |> Enum.reduce(%{}, fn {n, index}, acc ->
       Map.put(acc, n, index + 1)
     end), last_turn, Enum.count(turns) + 1}
  end

  defp play_until({turns, previously_spoken_number, current_turn}, target_turn)
       when current_turn < target_turn do
    next_number =
      case Map.fetch(turns, previously_spoken_number) do
        {:ok, turn} -> current_turn - turn
        _ -> 0
      end

    updated_turns = turns |> Map.put(previously_spoken_number, current_turn)
    play_until({updated_turns, next_number, current_turn + 1}, target_turn)
  end

  defp play_until({_, previously_spoken_number, _}, _), do: previously_spoken_number
end
