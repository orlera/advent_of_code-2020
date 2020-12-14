defmodule V2020.Day14 do
  @input_file_part1 "lib/day14/input.txt"
  @input_file_part2 "lib/day14/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> IO.inspect()
    |> initialize_program()
    |> sum_memory_values()
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
    |> String.split("\nmask = ")
    |> Enum.map(fn instruction ->
      [mask | memory_instructions] = instruction |> String.trim_leading("mask = ") |> String.split("\n")
      {parse_mask(mask), Enum.map(memory_instructions, & parse_memory_instruction(&1))}
    end)
  end

  defp parse_mask(mask) do
    mask
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reject(fn {bitmask, _} -> bitmask == "X" end)
  end

  defp parse_memory_instruction(memory_instruction) do
    Regex.run(~r/mem\[([0-9]+)\] = ([0-9]+)/, memory_instruction)
    |> Enum.drop(1)
    |> Enum.map(& String.to_integer(&1))
    |> List.to_tuple()
  end

  defp initialize_program(mask_groups) do
    mask_groups
    |> Enum.reduce(%{}, fn mask_group, acc ->
      {mask, memory_intructions} = mask_group
      Enum.map(memory_intructions, fn {address, value} ->
        {address, mask_number(value, mask)}
      end)
      |> Enum.reduce(acc, fn {address, value}, memory ->
        Map.put(memory, address, value)
      end)
    end)
  end

  defp mask_number(number, mask) do
    number
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> apply_mask(mask)
  end

  defp apply_mask(number, mask) do
    mask
    |> Enum.reduce(String.graphemes(number), fn {bit, index}, acc ->
      acc |> List.replace_at(index, bit)
    end)
    |> List.to_string()
    |> String.to_integer(2)
  end

  defp sum_memory_values(memory) do
    memory
    |> Map.values()
    |> Enum.sum()
  end
end
