defmodule V2020 do
  def solutions_for_day(day) do
    IO.puts("*****DAY #{day}******")
    IO.puts("-----part 1-----")
    apply(String.to_existing_atom("Elixir.V2020.Day#{day}"), :solution_part1, [])
    IO.puts("-----part 2-----")
    apply(String.to_existing_atom("Elixir.V2020.Day#{day}"), :solution_part2, [])
    IO.puts("----------------")
  end

  def all_solutions do
    1..latest_solution()
    |> Enum.map(&solutions_for_day(&1))
  end

  def latest_solution() do
    solutions_folder = File.cwd!() |> Path.join("lib")

    solutions_folder
    |> File.ls!()
    |> Enum.filter(&(Path.join(solutions_folder, &1) |> File.dir?()))
    |> Enum.map(&(String.trim_leading(&1, "day") |> String.to_integer()))
    |> Enum.max()
  end
end
