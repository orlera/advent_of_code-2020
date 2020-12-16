defmodule V2020.Day16 do
  @input_file_part1 "lib/day16/input.txt"
  @input_file_part2 "lib/day16/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> validate_scanned_tickets()
    |> IO.inspect()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> IO.inspect()
  end

  defp parse_input(file_path) do
    input_sections =
      file_path
      |> File.read!()
      |> String.split("\n\n")

    {input_sections |> Enum.at(0) |> parse_rules(),
     input_sections |> Enum.at(1) |> String.trim_leading("your ticket:\n") |> parse_ticket(),
     input_sections
     |> Enum.at(2)
     |> String.trim_leading("nearby tickets:\n")
     |> String.split("\n")
     |> Enum.map(&parse_ticket(&1))}
  end

  defp parse_rules(rules_string) do
    rules_string
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, ": ") |> to_range_tuple()))
    |> Enum.into(%{})
  end

  defp to_range_tuple([field_name | [field_ranges]]) do
    {field_name, field_ranges |> to_validation_function()}
  end

  defp to_validation_function(ranges) do
    ranges
    |> String.split(" or ")
    |> Enum.map(fn string_range ->
      [low | [high]] =
        string_range
        |> String.split("-")
        |> Enum.map(&String.to_integer(&1))

      low..high
    end)
    |> build_validation_function()
  end

  defp build_validation_function(ranges) do
    fn value -> Enum.any?(ranges, &(value in &1)) end
  end

  defp parse_ticket(ticket_string),
    do: String.split(ticket_string, ",") |> Enum.map(&String.to_integer(&1))

  defp validate_scanned_tickets({validations, _, scanned_tickets}) do
    scanned_tickets
    |> Enum.map(&ticket_error_rate(&1, validations))
    |> List.flatten()
    |> Enum.sum()
  end

  defp ticket_error_rate(ticket, validations) do
    ticket
    |> Enum.map(
      &case field_valid?(&1, validations) do
        false -> &1
        _ -> 0
      end
    )
  end

  defp field_valid?(field, validations) do
    validations
    |> Map.values()
    |> Enum.any?(& &1.(field))
  end
end
