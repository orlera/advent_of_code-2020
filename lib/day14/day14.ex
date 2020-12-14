defmodule V2020.Day14 do
  use Bitwise, only_operators: true
  @input_file_part1 "lib/day14/input.txt"
  @input_file_part2 "lib/day14/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> initialize_program(&decoder_chip_v1/2)
    |> sum_memory_values()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input(false)
    |> initialize_program(&decoder_chip_v2/2)
    |> sum_memory_values()
    |> IO.inspect()
  end

  defp parse_input(file_path, skip_x \\ true) do
    file_path
    |> File.read!()
    |> String.split("\nmask = ")
    |> Enum.map(fn instruction ->
      [mask | memory_instructions] =
        instruction |> String.trim_leading("mask = ") |> String.split("\n")

      {parse_mask(mask, skip_x), Enum.map(memory_instructions, &parse_memory_instruction(&1))}
    end)
  end

  defp parse_mask(mask, skip_x) do
    mask
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reject(fn {bitmask, _} -> skip_x && bitmask == "X" end)
  end

  defp parse_memory_instruction(memory_instruction) do
    Regex.run(~r/mem\[([0-9]+)\] = ([0-9]+)/, memory_instruction)
    |> Enum.drop(1)
    |> Enum.map(&String.to_integer(&1))
    |> List.to_tuple()
  end

  defp initialize_program(mask_groups, decoder_chip) do
    mask_groups
    |> Enum.reduce(%{}, fn mask_group, acc ->
      {mask, memory_intructions} = mask_group

      decoder_chip.(memory_intructions, mask)
      |> Enum.reduce(acc, fn {address, value}, memory ->
        Map.put(memory, address, value)
      end)
    end)
  end

  defp decoder_chip_v1(memory_intructions, mask) do
    memory_intructions
    |> Enum.map(fn {address, value} ->
      {address, mask_number(value, mask) |> String.to_integer(2)}
    end)
  end

  defp mask_number(number, mask, masking_algorithm \\ &apply_overwrite_mask/2) do
    number
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.graphemes()
    |> masking_algorithm.(mask)
  end

  defp apply_overwrite_mask(number, mask) do
    mask
    |> Enum.reduce(number, fn {bit, index}, acc ->
      acc |> List.replace_at(index, bit)
    end)
    |> List.to_string()
  end

  defp decoder_chip_v2(memory_intructions, mask) do
    {floating_bits, masked_bits} = Enum.split_with(mask, fn {bitmask, _} -> bitmask == "X" end)

    Enum.map(memory_intructions, fn {address, value} ->
      address
      |> mask_number(masked_bits, &apply_or_mask/2)
      |> String.to_integer(2)
      |> combinations(floating_bits)
      |> Enum.map(&{&1, value})
    end)
    |> List.flatten()
  end

  defp apply_or_mask(number, mask) do
    mask
    |> Enum.reduce(number |> Enum.map(&String.to_integer(&1)), fn {bit, index}, acc ->
      acc |> List.update_at(index, &(&1 ||| String.to_integer(bit)))
    end)
    |> Enum.join()
  end

  defp combinations(number, floating_bits) do
    floating_bits
    |> Enum.reduce([number], fn {_, index}, acc ->
      acc
      |> Enum.map(fn n ->
        mask_number(n, index, &apply_floating_mask/2)
      end)
      |> List.flatten()
      |> Enum.map(&String.to_integer(&1, 2))
    end)
  end

  defp apply_floating_mask(number, index) do
    [
      number |> List.replace_at(index, "0") |> List.to_string(),
      number |> List.replace_at(index, "1") |> List.to_string()
    ]
  end

  defp sum_memory_values(memory) do
    memory
    |> Map.values()
    |> Enum.sum()
  end
end
