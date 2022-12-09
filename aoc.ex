defmodule Aoc do
  def getInputLines(fileName) do
    {:ok, contents} = File.read("inputs/#{fileName}")
	lines = contents |> String.split("\n", trim: true) |> Enum.map(&String.trim/1)
	lines
  end
    def getInputLinesWithWhitespace(fileName) do
    {:ok, contents} = File.read("inputs/#{fileName}")
	lines = contents |> String.split("\n", trim: true) |> Enum.map(&String.trim(&1,"\n")) |> Enum.map(&String.trim(&1,"\r"))
	lines
  end

  def index_first(element, index) do
    {index, element}
  end

  def make_table(lists) do
    list_of_maps = lists |> Enum.map(fn l -> l |> Enum.with_index(&Aoc.index_first/2) |> Enum.into(%{}) end)
    Enum.with_index(list_of_maps, &Aoc.index_first/2) |> Enum.into(%{})
  end

  def table_entries(table) do
    table
    |> Map.to_list
    |> Enum.flat_map(fn {k, v} -> Map.to_list(v) |> Enum.map(fn {k1, v1} -> {k, k1, v1} end) end)
  end

  def transpose(lists) do
    lists |> Enum.zip |> Enum.map(&Tuple.to_list(&1))
  end

  def rotate(lists) do
    reversed = lists |> Enum.map(&Enum.reverse/1)
    transpose(reversed)
  end

  def rotate(lists, times) do
    if times > 0 do
      rotate(rotate(lists), times - 1)
    else
      lists
    end
  end

  def deep_put_in(data, path, value) do
    put_in(data, Enum.map(path, &Access.key(&1, %{})), value)
  end
end
