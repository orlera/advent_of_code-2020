defmodule V2020.Day23 do
  @input_file_part1 "lib/day23/input.txt"
  @input_file_part2 "lib/day23/input.txt"
  @target_round 100
  @target_round_p2 10000000
  @cup_number 9
  @cup_number_p2 1000000
  @pick_up_cups 3

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> play_round()
    |> label_order()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> add_missing_cups(10..@cup_number_p2)
    |> link_cups()
    |> (fn cups -> play_round_linked(cups, 6) end).()
    |> find_cups_with_star()
    |> (fn {first, second} -> first * second end).()
    |> IO.inspect()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.graphemes()
    |> Enum.map(&String.to_integer(&1))
  end

  defp play_round(cups, current_cup_index \\ 0, current_round \\ 0) do
    case current_round do
      @target_round -> cups
      _ -> do_play_round(cups, current_cup_index, current_round)
    end
  end

  defp do_play_round(cups, current_cup_index, current_round) do
    current_cup = Enum.at(cups, current_cup_index)
    {picked_up, rest} = split_cups(cups, current_cup_index)
    destination_cup = find_destination_cup(rest, current_cup - 1)

    new_cups = insert_cups(rest, picked_up, destination_cup)
    play_round(new_cups, rem(Enum.find_index(new_cups, & &1 == current_cup) + 1, @cup_number), current_round + 1)
  end

  defp split_cups(cups, current_cup_index) do
    Enum.reduce(1..@pick_up_cups, {[], cups}, fn elem, {taken, remaining} ->
      cup_to_take = Enum.at(cups, rem(current_cup_index + elem, @cup_number))
      {taken ++ [cup_to_take], List.delete(remaining, cup_to_take)}
    end)
  end

  defp find_destination_cup(cups, current_cup) do
    cup_to_find = if current_cup == 0, do: @cup_number, else: current_cup
    Enum.find(cups, & &1 == cup_to_find)
    || find_destination_cup(cups, cup_to_find - 1)
  end

  defp insert_cups(cups, cups_to_insert, destination) do
    destination_index = Enum.find_index(cups, & &1 == destination)
    List.insert_at(cups, destination_index + 1, cups_to_insert) |> List.flatten()
  end

  defp label_order(cups) do
    first_cup_index = Enum.find_index(cups, & &1 == 1)
    Enum.reduce(1..@cup_number - 1, "", fn elem, acc ->
      acc <> (Enum.at(cups, rem(first_cup_index + elem, @cup_number)) |> Integer.to_string())
    end)
  end

  defp add_missing_cups(cups, range_to_add) do
    cups ++ Enum.to_list(range_to_add)
  end

  defp link_cups(cups) do
    Enum.chunk_every(cups, 2, 1, :discard)
    |> Enum.map(& List.to_tuple(&1))
    |> (fn linked_list -> linked_list ++ [{List.last(cups), List.first(cups)}] end).()
    |> Enum.into(%{})
  end

  defp play_round_linked(cups, current_cup, round \\ 0) do
    case round do
      @target_round_p2 -> cups
      round -> do_play_round_linked(cups, current_cup, round)
    end
  end

  defp do_play_round_linked(cups, current_cup, round) do
    next_cup = cups[current_cup]
    second_cup = cups[next_cup]
    third_cup = cups[second_cup]
    destination_cup = find_linked_destination_cup(current_cup - 1, [next_cup, second_cup, third_cup])

    cups
    |> Map.put(current_cup, cups[third_cup])
    |> Map.put(destination_cup, next_cup)
    |> Map.put(third_cup, cups[destination_cup])
    |> play_round_linked(cups[third_cup], round + 1)
  end

  defp find_linked_destination_cup(current_cup, ingored_cups) do
    cond do
      current_cup < 1 -> find_linked_destination_cup(@cup_number_p2, ingored_cups)
      Enum.member?(ingored_cups, current_cup) -> find_linked_destination_cup(current_cup - 1, ingored_cups)
      true -> current_cup
    end
  end

  defp find_cups_with_star(cups) do
    {cups[1], cups[cups[1]]}
  end
end
