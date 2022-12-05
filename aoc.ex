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
end
