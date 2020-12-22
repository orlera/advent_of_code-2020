defmodule V2020.Day22 do
  @input_file_part1 "lib/day22/input.txt"
  @input_file_part2 "lib/day22/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> combat()
    |> calculate_score(0)
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> recursive_combat()
    |> elem(1)
    |> calculate_score(0)
    |> IO.inspect()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.trim_leading("Player 1:\n")
    |> String.split("\n\nPlayer 2:\n")
    |> Enum.map(&(String.split(&1, "\n") |> Enum.map(fn card -> String.to_integer(card) end)))
    |> List.to_tuple()
  end

  defp combat({first, []}), do: first
  defp combat({[], second}), do: second
  defp combat({[top_first | rest_first], [top_second | rest_second]}) when top_first > top_second, do: combat({rest_first ++ [top_first, top_second], rest_second})
  defp combat({[top_first | rest_first], [top_second | rest_second]}) when top_first < top_second, do: combat({rest_first, rest_second ++ [top_second, top_first]})

  defp recursive_combat({first, second}), do: play_round({first, second}, MapSet.new())

  defp play_round({first, second}, previous_rounds) do
    cond do
      MapSet.member?(previous_rounds, {first, second}) -> {:first, first}
      Enum.empty?(second) -> {:first, first}
      Enum.empty?(first) -> {:second, second}
      hd(first) <= length(tl(first)) and hd(second) <= length(tl(second)) ->
        case recursive_combat({Enum.take(tl(first), hd(first)), Enum.take(tl(second), hd(second))}) do
          {:first, _} -> play_round({tl(first) ++ [hd(first), hd(second)], tl(second)}, MapSet.put(previous_rounds, {first, second}))
          {:second, _} -> play_round({tl(first), tl(second) ++ [hd(second), hd(first)]}, MapSet.put(previous_rounds, {first, second}))
        end
      hd(first) > hd(second) -> play_round({tl(first) ++ [hd(first), hd(second)], tl(second)}, MapSet.put(previous_rounds, {first, second}))
      hd(first) < hd(second) -> play_round({tl(first), tl(second) ++ [hd(second), hd(first)]}, MapSet.put(previous_rounds, {first, second}))
    end
  end

  defp calculate_score([top_card], accumulator), do: accumulator + top_card

  defp calculate_score([top_card | rest] = deck, accumulator),
    do: calculate_score(rest, accumulator + top_card * length(deck))
  defp calculate_score({_, [top_card | rest] = deck}, accumulator),
    do: calculate_score(rest, accumulator + top_card * length(deck))
end
