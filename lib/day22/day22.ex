defmodule V2020.Day22 do
  @input_file_part1 "lib/day22/input.txt"
  @input_file_part2 "lib/day22/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> play_round()
    |> calculate_score(0)
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
    |> String.trim_leading("Player 1:\n")
    |> String.split("\n\nPlayer 2:\n")
    |> Enum.map(&(String.split(&1, "\n") |> Enum.map(fn card -> String.to_integer(card) end)))
    |> List.to_tuple()
  end

  defp play_round({first, []}), do: first
  defp play_round({[], second}), do: second

  defp play_round({first, second}) do
    {card_first, rest_first} = List.pop_at(first, 0)
    {card_second, rest_second} = List.pop_at(second, 0)

    case card_first > card_second do
      true -> {rest_first ++ [card_first, card_second], rest_second}
      _ -> {rest_first, rest_second ++ [card_second, card_first]}
    end
    |> play_round()
  end

  defp calculate_score([top_card], accumulator), do: accumulator + top_card

  defp calculate_score([top_card | rest] = deck, accumulator),
    do: calculate_score(rest, accumulator + top_card * Enum.count(deck))
end
