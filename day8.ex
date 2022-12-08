require Aoc

to_cell = fn str ->
    String.split(str,"", trim: true) |> Enum.map(&String.to_integer/1)
end

sight_checker = fn elem, max ->
    {elem > max, (if elem > max, do: elem, else: max)}
end

row_sight_check = fn row ->
    {vis, _} = Enum.map_reduce(row, -1, sight_checker)
    vis
end

build_vismap = fn lines ->
    Enum.map(lines, row_sight_check)
end

lines = Aoc.getInputLines("d8a.txt") |> Enum.map(to_cell)

#p1
all_maps = 0..3
|> Enum.map(&(Aoc.rotate(build_vismap.(Aoc.rotate(lines, &1)), 4 - &1)))
|> Aoc.transpose
|> Enum.map(fn map -> Aoc.transpose(map) |> Enum.map(&Enum.any?/1) end)
|> Enum.flat_map(&Function.identity/1)
|> Enum.frequencies
|> IO.inspect

tree_counter = fn elem, sofar_rev ->
    larger_tree_idx = Enum.find_index(sofar_rev, &(&1 >= elem))
    {(if larger_tree_idx != nil, do: larger_tree_idx+1, else: length(sofar_rev)), [elem | sofar_rev]}
end

row_treecnt_check = fn row ->
    {vis, _} = Enum.map_reduce(row, [], tree_counter)
    vis
end

build_seecnt = fn lines ->
    Enum.map(lines, row_treecnt_check)
end

#p2
all_maps = 0..3
|> Enum.map(&(Aoc.rotate(build_seecnt.(Aoc.rotate(lines, &1)), 4 - &1)))
|> Aoc.transpose
|> Enum.map(fn map -> Aoc.transpose(map) |> Enum.map(&Enum.product/1) end)
|> Enum.flat_map(&Function.identity/1)
|> Enum.max
|> IO.inspect