defmodule V2020.Day7 do
  @bag_colors_regex ~r/(\w+\s\w+) bags/
  @my_bag_color "shiny gold"
  @input_file_part1 "lib/day7/input.txt"
  @input_file_part2 "lib/day7/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> search_possible_containers(@my_bag_color)
    |> Enum.count()
    |> IO.puts()
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
    |> Enum.map(fn rule ->
      Regex.scan(~r/(\w+\s\w+) bag/, rule)
      |> Enum.map(& Enum.slice(&1, -1..-1))
      |> List.flatten()
    end)
    |> Enum.reduce(%{}, fn bags, acc ->
      Map.put(acc, List.first(bags), Enum.drop(bags, 1))
    end)
  end

  defp search_possible_containers(rules, color) do
    []
  end
end
