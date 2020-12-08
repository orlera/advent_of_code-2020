defmodule V2020.Day8 do
  @input_file_part1 "lib/day8/input.txt"
  @input_file_part2 "lib/day8/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> boot_console({0, 0})
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> change_instructions()
    |> IO.inspect()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn instruction_line ->
      {operator, value} =
        instruction_line
        |> String.split()
        |> List.to_tuple()

      %{operator: operator, value: String.to_integer(value)}
    end)
  end

  defp boot_console(instruction_set, {accumulator, position}) do
    case Enum.at(instruction_set, position) do
      nil ->
        accumulator

      %{visited: true} ->
        {:visited, accumulator}

      instruction ->
        boot_console(
          mark_step_as_visited(instruction_set, position),
          execute_instruction(instruction, {accumulator, position})
        )
    end
  end

  defp change_instructions(original_instruction_set) do
    original_instruction_set
    |> Enum.with_index()
    |> Enum.reduce_while(0, fn {_instruction, position}, _ ->
      result_for_step =
        original_instruction_set
        |> List.update_at(position, fn instruction_to_update ->
          instruction_to_update |> change_instruction()
        end)
        |> boot_console({0, 0})

      case result_for_step do
        {:visited, _} -> {:cont, 0}
        accumulator -> {:halt, accumulator}
      end
    end)
  end

  defp execute_instruction(%{operator: "acc", value: value}, {accumulator, position}),
    do: {accumulator + value, position + 1}

  defp execute_instruction(%{operator: "jmp", value: value}, {accumulator, position}),
    do: {accumulator, position + value}

  defp execute_instruction(%{operator: "nop"}, {accumulator, position}),
    do: {accumulator, position + 1}

  defp change_instruction(%{operator: "jmp"} = instruction), do: %{instruction | operator: "nop"}
  defp change_instruction(%{operator: "nop"} = instruction), do: %{instruction | operator: "jmp"}
  defp change_instruction(instruction), do: instruction

  defp mark_step_as_visited(instruction_set, position) do
    instruction_set
    |> List.update_at(position, fn instruction ->
      Map.put(instruction, :visited, true)
    end)
  end
end
