defmodule V2020.Day5 do
  @first_seat_id 21
  @input_file_part1 "lib/day5/input.txt"
  @input_file_part2 "lib/day5/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> Enum.map(& calculate_seat(&1))
    |> Enum.max_by(& &1[:id])
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> Enum.map(& calculate_seat(&1)[:id])
    |> Enum.sort()
    |> Enum.with_index(@first_seat_id)
    |> Enum.filter(fn {id, index} -> id != index end)
    |> List.first()
    |> IO.inspect()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(& String.split_at(&1, 7))
  end

  defp calculate_seat({row_letter, column_letter}) do
    {row, _} = row_letter |> row_letter_to_number()
    {column, _} = column_letter |> column_letter_to_number()

    %{
      row: row,
      column: column,
      id: row * 8 + column
    }
  end

  defp row_letter_to_number(row_letters) do
    row_letters
    |> String.replace("F", "0")
    |> String.replace("B", "1")
    |> Integer.parse(2)
  end

  defp column_letter_to_number(column_letters) do
    column_letters
    |> String.replace("L", "0")
    |> String.replace("R", "1")
    |> Integer.parse(2)
  end
end
