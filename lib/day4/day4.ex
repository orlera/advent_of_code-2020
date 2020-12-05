defmodule V2020.Day4 do
  @required_fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  @input_file_part1 "lib/day4/input.txt"
  @input_file_part2 "lib/day4/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> Enum.map(& passport_valid?(&1))
    |> Enum.count(& &1)
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    # |> IO.inspect()
  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.map(& build_passport(&1))
  end

  defp build_passport(passport_string) do
    passport_string
    |> String.split(~r/\n|\s/)
    |> Enum.reduce(%{}, fn field, acc ->
      key_value =
        field
        |> String.split(":")

      acc
      |> Map.put(
        Enum.at(key_value, 0),
        Enum.at(key_value, 1)
      )
    end)
  end

  defp passport_valid?(passport) do
    passport_fields = passport |> Map.keys()

    @required_fields
    |> Enum.all?(& passport_fields |> Enum.member?(&1))
  end
end
