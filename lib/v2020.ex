defmodule V2020 do
  def solutions_for_day(day) do
    IO.puts("***DAY #{day}***")
    IO.puts("-----part 1-----")
    apply(String.to_existing_atom("Elixir.V2020.Day#{day}"), :solution_part1, [])
    IO.puts("-----part 2-----")
    apply(String.to_existing_atom("Elixir.V2020.Day#{day}"), :solution_part2, [])
  end

  def all_solutions do
    1..1
    |> Enum.each(& solutions_for_day(&1))
  end
end
