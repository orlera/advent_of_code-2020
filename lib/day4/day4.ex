defmodule V2020.Day4 do
  @required_fields ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
  @input_file_part1 "lib/day4/input.txt"
  @input_file_part2 "lib/day4/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> Enum.map(& passport_has_required_fields?(&1))
    |> Enum.count(& &1)
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> Enum.map(& passport_valid?(&1))
    |> Enum.count(& &1)
    |> IO.puts()
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

  defp passport_has_required_fields?(passport) do
    passport_fields = passport |> Map.keys()

    @required_fields
    |> Enum.all?(& passport_fields |> Enum.member?(&1))
  end

  defp passport_valid?(passport) do
    @required_fields
    |> Enum.all?(& passport_field_valid?(passport, &1))
  end

  defp passport_field_valid?(passport, "byr" = key) do
    Map.get(passport, key) |> string_to_int() |> num_in_range?(1920, 2002)
  end

  defp passport_field_valid?(passport, "iyr" = key) do
    Map.get(passport, key) |> string_to_int() |> num_in_range?(2010, 2020)
  end

  defp passport_field_valid?(passport, "eyr" = key) do
    Map.get(passport, key) |> string_to_int() |> num_in_range?(2020, 2030)
  end

  defp passport_field_valid?(passport, "hgt" = key) do
    value = Map.get(passport, key)
    cond do
      is_nil(value) -> false
      String.match?(value, ~r/in/) -> value |> String.trim_trailing("in") |> string_to_int() |> num_in_range?(59, 76)
      String.match?(value, ~r/cm/) -> value |> String.trim_trailing("cm") |> string_to_int() |> num_in_range?(150, 193)
      true -> false
    end
  end

  defp passport_field_valid?(passport, "hcl" = key) do
    value = Map.get(passport, key)
    value && String.match?(value, ~r/^#[0-9a-f]{6}$/i)
  end

  defp passport_field_valid?(passport, "ecl" = key) do
    ~w(amb blu brn gry grn hzl oth) |> Enum.member?(Map.get(passport, key))
  end

  defp passport_field_valid?(passport, "pid" = key) do
    value = Map.get(passport, key)
    value && String.length(value) == 9 && string_to_int(value)
  end

  defp string_to_int(nil), do: nil
  defp string_to_int(string), do: string |> String.to_integer()

  defp num_in_range?(nil, _, _), do: false
  defp num_in_range?(num, left, right) do
    num >= left && num <= right
  end
end
