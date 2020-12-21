defmodule V2020.Day21 do
  @input_file_part1 "lib/day21/input.txt"
  @input_file_part2 "lib/day21/input.txt"

  def solution_part1() do
    products = parse_input(@input_file_part1)
    alergens = alergen_list(products)
    alergen_ingredients = possible_ingredients_by_alergen(products)

    ingredients_with_alergens =
      alergens
      |> ingredients_containing_alergens(alergen_ingredients)
      |> Map.values()
      |> Enum.reduce(MapSet.new, & MapSet.union(&1, &2))

    products
    |> Enum.map(& elem(&1, 0))
    |> List.flatten()
    |> Enum.reject(& MapSet.member?(ingredients_with_alergens, &1))
    |> Enum.count()
  end

  def solution_part2() do
    products = parse_input(@input_file_part2)
    alergens = alergen_list(products)
    alergen_ingredients = possible_ingredients_by_alergen(products)

    alergens
    |> ingredients_containing_alergens(alergen_ingredients)
    |> Map.to_list()
    |> remove_duplicate_ingredients()
    |> Enum.sort_by(fn {alergen, _} -> alergen end)
    |> Enum.reduce([], fn {_, ingredient}, acc -> acc ++ MapSet.to_list(ingredient) end)
    |> Enum.join(",")

  end

  defp parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(& Regex.run(~r/(.+) \(contains (.+)\)/, &1))
    |> Enum.map(& {String.split(Enum.at(&1, 1)), String.split(Enum.at(&1, 2), ", ")})
  end

  defp alergen_list(products) do
    products
    |> Enum.map(& elem(&1, 1))
    |> List.flatten()
    |> MapSet.new()
  end

  defp possible_ingredients_by_alergen(products) do
    products
    |> Enum.reduce([], fn {ingredients, alergens}, acc ->
      acc ++ Enum.map(alergens, & {&1, ingredients})
    end)
  end

  defp ingredients_containing_alergens(alergens, alergen_ingredients) do
    alergens
    |> Enum.reduce(%{}, fn alergen, acc ->
      compatible_ingredients =
        alergen_ingredients
        |> Enum.filter(fn {a, _} -> a == alergen end)

      possible_ingredients =
        compatible_ingredients
        |> Enum.reduce(MapSet.new(compatible_ingredients |> List.first() |> elem(1)), fn {_, ingredients}, acc ->
          ingredients
          |> MapSet.new()
          |> MapSet.intersection(acc)
        end)

      Map.put(acc, alergen, possible_ingredients)
    end)
  end

  defp remove_duplicate_ingredients(alergen_ingredients) do
    sorted_alergens =
      alergen_ingredients
      |> Enum.sort_by(fn {_, ingredients} -> MapSet.size(ingredients) end)

    updated_alergens =
      sorted_alergens
      |> Enum.with_index()
      |> Enum.reduce(sorted_alergens, fn {_, index}, acc ->
        possible_ingredients = acc |> Enum.at(index) |> elem(1)
        case MapSet.size(possible_ingredients) do
          1 -> remove_ingredient_from_rest(Enum.at(possible_ingredients, 0), acc, index + 1)
          _ -> acc
        end
      end)

      case Enum.all?(updated_alergens, fn {_, ingredients} -> MapSet.size(ingredients) < 2 end) do
        false -> remove_duplicate_ingredients(updated_alergens)
        _ -> updated_alergens
      end
  end

  defp remove_ingredient_from_rest(ingredient, alergen_ingredients, from) do
    alergen_ingredients
    |> Enum.with_index()
    |> Enum.map(fn {{alergen, ingredients}, index} ->
      cond do
        index >= from -> {alergen, MapSet.delete(ingredients, ingredient)}
        true -> {alergen, ingredients}
      end
    end)
  end
end
