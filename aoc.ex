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
end
