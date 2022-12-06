require Aoc

find_first_uniq = fn charlist, blocksize  ->
  {_, pos} = Stream.chunk_every(charlist, blocksize, 1) |> Stream.with_index(1) |> Stream.take_while(fn {chunk, pos} -> length(Enum.uniq(chunk)) < blocksize end) |> Enum.to_list |> List.last
  pos + blocksize
end

lines = Aoc.getInputLines("d6a.txt")
# p1
lines |> Enum.map(&String.to_charlist/1) |> Enum.map(&find_first_uniq.(&1, 4)) |> IO.inspect

# p2
lines |> Enum.map(&String.to_charlist/1) |> Enum.map(&find_first_uniq.(&1, 14)) |> IO.inspect
