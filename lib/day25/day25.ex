defmodule V2020.Day25 do
  @input_file_part1 "lib/day25/input.txt"
  @input_file_part2 "lib/day25/input.txt"

  @base_subject_number 7
  @limit 20201227

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> find_loop_sizes()
    |> find_encryption_keys()
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
    |> String.split("\n")
    |> Enum.map(& String.to_integer(&1))
    |> List.to_tuple()
  end

  defp find_loop_sizes({card_public_key, door_public_key}) do
    {{card_public_key, find_loop_size(card_public_key, 1)},
    {door_public_key, find_loop_size(door_public_key, 1)}}
  end

  defp find_loop_size(public_key, base, loop \\ 1) do
    case rem(base * @base_subject_number, @limit) do
      ^public_key -> loop
      new_base -> find_loop_size(public_key, new_base, loop + 1)
    end
  end

  defp find_encryption_keys({{card_public_key, card_loop_size}, {door_public_key, door_loop_size}}) do
    {transform_number(card_public_key, card_public_key, door_loop_size), transform_number(door_public_key, door_public_key, card_loop_size)}
  end

  defp transform_number(subject_number, base, times) do
    case times do
      1 -> base
      _ -> transform_number(subject_number, rem(base * subject_number, @limit), times - 1)
    end
  end
end
