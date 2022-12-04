require Aoc

list_to_int = fn list -> list |> Enum.map(&String.to_integer/1) end

make_range = fn elem -> Range.new(Enum.at(elem,0), Enum.at(elem,1)) end

range_contains = fn
  s1..e1, s2..e2 -> (s1 <= s2 && e2 <= e1) || (s2 <= s1 && e1 <= e2)
end

range_overlaps = fn
  r1, r2 -> not Range.disjoint?(r1, r2)
end

process_group = fn g, test_fun ->
  ranges = g |> Enum.map(&String.split(&1,"-")) |> Enum.map(list_to_int) |> Enum.map(make_range)
  test_fun.(Enum.at(ranges,0), Enum.at(ranges,1))
end

lines = Aoc.getInputLines("d4a.txt")
# p1
freq = lines |> Enum.map(&String.split(&1,",")) |> Enum.map(&process_group.(&1,range_contains)) |> Enum.frequencies
IO.puts(freq[true])
# p2
freq = lines |> Enum.map(&String.split(&1,",")) |> Enum.map(&process_group.(&1,range_overlaps)) |> Enum.frequencies
IO.puts(freq[true])
