defmodule V2020.Day11 do
  @input_file_part1 "lib/day11/input.txt"
  @input_file_part2 "lib/day11/input.txt"

  def solution_part1() do
    @input_file_part1
    |> parse_input()
    |> run_until_stable()
    |> count_occupied()
  end

  def solution_part2() do
    @input_file_part2
    |> parse_input()
    |> IO.inspect()
  end

  def parse_input(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {line, x_index} ->
      {String.graphemes(line) |> Enum.with_index(), x_index}
    end)
  end

  defp run_until_stable(seat_matrix, out_index \\ 0) do
    new_seat_matrix = execute_round(seat_matrix) |> write_output(out_index)

    case matrixes_equal?(seat_matrix, new_seat_matrix) do
      false -> run_until_stable(new_seat_matrix, out_index + 1)
      _ -> new_seat_matrix
    end
  end

  def execute_round(seat_matrix) do
    Enum.map(seat_matrix, fn {line, x_index} ->
      {Enum.map(line, fn {status, y_index} ->
       maybe_update_seat(status, x_index, y_index, seat_matrix)
      end), x_index}
    end)
  end

  def write_output(lines, index \\ 0) do
    {:ok, file} = File.open("lib/day11/output#{index}.txt", [:write])
    Enum.each(lines, fn {line, _} ->
      Enum.each(line, fn {status, _} -> IO.binwrite(file, status) end)
      IO.binwrite(file, "\n")
    end)

    lines
  end

  def count_occupied(seat_matrix) do
    Enum.map(seat_matrix, fn {line, _} ->
      Enum.map(line, fn {status, _} ->
        status
      end)
    end)
    |> List.flatten()
    |> Enum.count(& &1 == "#")
  end

  defp maybe_update_seat(".", _, y_index, _), do: {".", y_index}
  defp maybe_update_seat(seat_status, x_index, y_index, seat_matrix) do
    Enum.slice(seat_matrix, adjacent_range(x_index, Enum.count(seat_matrix) - 1))
    |> Enum.map(fn {line, _} -> Enum.slice(line, adjacent_range(y_index, Enum.count(line)- 1)) end)
    |> List.flatten()
    |> Enum.map(fn {status, _} -> status end)
    |> change_status(seat_status, y_index)
  end

  defp change_status(adjacent_seats, "L", y_index) do
    case Enum.count(adjacent_seats, fn status -> status == "#" end) do
      0 -> {"#", y_index}
      _ -> {"L", y_index}
    end
  end

  defp change_status(adjacent_seats, "#", y_index) do
    case Enum.count(adjacent_seats, fn status -> status == "#" end) do
      above when above > 4 -> {"L", y_index}
      _ -> {"#", y_index}
    end
  end

  defp adjacent_range(0, _), do: 0..1
  defp adjacent_range(base, max) when base == max, do: base-1..base
  defp adjacent_range(base, _), do: base-1..base+1

  def matrixes_equal?(matrix1, matrix2) do
    Enum.map(matrix1, fn {line1, x_index} ->
      Enum.map(line1, fn {status1, y_index} ->
        {line2, _} = matrix2 |> Enum.at(x_index)
        {status2, _} = line2 |> Enum.at(y_index)
        status1 == status2
      end)
    end)
    |> List.flatten()
    |> Enum.all?()
  end
end
