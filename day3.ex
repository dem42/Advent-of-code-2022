splitter = fn str ->
  nstr = String.split_at(str, div(String.length(str),2))
  Tuple.to_list(nstr) |> Enum.map(&String.to_charlist/1)
end

return_dup = fn tup ->
  intersec = MapSet.intersection(MapSet.new(Enum.at(tup, 0)), MapSet.new(Enum.at(tup, 1)))
  if length(tup) == 2 do
    MapSet.to_list(intersec)
  else
    intersec2 = MapSet.intersection(intersec, MapSet.new(Enum.at(tup, 2)))
    MapSet.to_list(intersec2)
  end
end

to_int = fn char ->
  if char >= ?a do
    char - ?a + 1
  else
    char - ?A + 27
  end
end

lines = Aoc.getInputLines("d3a.txt")
# p1
lines |> Enum.map(splitter) |> Enum.flat_map(return_dup) |> Enum.map(to_int) |> Enum.sum |> IO.puts
# p2
lines |> Enum.map(&String.to_charlist/1) |> Enum.chunk(3) |> Enum.flat_map(return_dup) |> Enum.map(to_int) |> Enum.sum |> IO.puts
