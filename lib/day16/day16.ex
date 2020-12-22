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
    |> discard_invalid_tickets()
    |> determine_fields_possible_positions()
    |> remove_duplicate_positions()
    |> my_ticket_stats()
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
    {field_name, %{"validation" => field_ranges |> to_validation_function()}}
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
    |> Enum.sum()
  end

  defp field_valid?(field, validations) do
    validations
    |> Map.values()
    |> Enum.any?(& &1["validation"].(field))
  end

  defp discard_invalid_tickets({validations, my_ticket, scanned_tickets}) do
    valid_tickets = Enum.reject(scanned_tickets, &(ticket_error_rate(&1, validations) > 0))

    {validations, my_ticket, valid_tickets}
  end

  defp determine_fields_possible_positions({fields_data, my_ticket, scanned_tickets}) do
    updated_fields_data =
      fields_data
      |> Enum.map(fn {field_name, %{"validation" => validation} = field_data} ->
        possible_positions =
          my_ticket
          |> Enum.with_index()
          |> Enum.reduce([], fn {_, index}, acc ->
            acc ++ [{Enum.all?(scanned_tickets, &validation.(Enum.at(&1, index))), index}]
          end)
          |> IO.inspect(label: field_name)
          |> Enum.filter(fn {possible, _} -> possible end)
          |> Enum.map(&elem(&1, 1))

        {field_name, Map.put(field_data, "possible_positions", possible_positions)}
      end)
      |> Enum.sort_by(fn {_, %{"possible_positions" => possible_positions}} ->
        Enum.count(possible_positions)
      end)

    {updated_fields_data, my_ticket, scanned_tickets}
  end

  defp remove_duplicate_positions({fields_data, my_ticket, scanned_tickets}) do
    updated_fields_data =
      fields_data
      |> Enum.with_index()
      |> Enum.reduce(fields_data, fn {_, index}, acc ->
        possible_positions = Enum.at(acc, index) |> elem(1) |> Map.get("possible_positions")

        case Enum.count(possible_positions) do
          1 -> remove_position_from_rest(Enum.at(possible_positions, 0), acc, index + 1)
          _ -> acc
        end
      end)

    {updated_fields_data, my_ticket, scanned_tickets}
  end

  defp remove_position_from_rest(position, fields_data, from) do
    fields_data
    |> Enum.with_index()
    |> Enum.map(fn {{field_name, %{"possible_positions" => possible_positions} = field_data},
                    index} ->
      cond do
        index >= from ->
          {field_name,
           %{
             field_data
             | "possible_positions" => Enum.reject(possible_positions, &(&1 == position))
           }}

        true ->
          {field_name, field_data}
      end
    end)
  end

  defp my_ticket_stats({fields_data, my_ticket, _}) do
    positions =
      fields_data
      |> Enum.filter(fn {name, _} -> String.starts_with?(name, "departure") end)
      |> Enum.map(fn {_, %{"possible_positions" => positions}} -> positions end)
      |> List.flatten()

    my_ticket
    |> Enum.with_index()
    |> Enum.reduce(1, fn {value, index}, acc ->
      cond do
        Enum.member?(positions, index) -> acc * value
        true -> acc
      end
    end)
  end
end
