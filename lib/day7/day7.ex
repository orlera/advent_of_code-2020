defmodule V2020.Day7 do
  @bag_colors_regex ~r/(\w+\s\w+) bag/
  @my_bag_color "shiny gold"
  @input_file_part1 "lib/day7/input.txt"
  @input_file_part2 "lib/day7/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> reverse_graph()
    |> recursive_containers_for(@my_bag_color, [@my_bag_color])
    |> Enum.uniq()
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
      Regex.scan(@bag_colors_regex, rule)
      |> Enum.map(& Enum.slice(&1, -1..-1))
      |> List.flatten()
    end)
    |> Enum.reduce(%{}, fn bags, acc ->
      Map.put(acc, List.first(bags), Enum.drop(bags, 1))
    end)
  end

  defp reverse_graph(rules) do
    rules
    |> Map.keys()
    |> Enum.map(
      fn color ->
        {color, containers_for(rules, color)}
      end
    )
    |> Enum.into(%{})
  end

  defp containers_for(rules, color) do
    rules
    |> Enum.flat_map(fn {container, content} ->
      if Enum.member?(content, color), do: [container], else: []
    end)
  end

  defp recursive_containers_for(rules, color, seen) do
    contained_by =
      rules
      |> Map.get(color)

    contained_by
    |> Enum.reject(& Enum.member?(seen, &1))
    |> Enum.flat_map(fn color ->
      [color] ++ recursive_containers_for(rules, color, seen ++ contained_by)
    end)
  end
end
