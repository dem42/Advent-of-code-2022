require Aoc

lines = Aoc.getInputLines("d12.txt")
table = lines
|> Enum.map(&String.to_charlist/1)
|> Enum.map(&Enum.map(&1, fn str -> Aoc.to_int(str) end))
|> Aoc.make_table

{start_y,start_x,_} = Aoc.table_entries(table)
|> Enum.find(fn {_,_,v} -> v == 45 end)

{fin_y,fin_x,_} = Aoc.table_entries(table)
|> Enum.find(fn {_,_,v} -> v == 31 end)

table = put_in(table, [fin_y,fin_x], Aoc.to_int(?z))
table = put_in(table, [start_y,start_x], Aoc.to_int(?a))

seen = lines
|> Enum.map(&String.to_charlist/1)
|> Enum.map(&Enum.map(&1, fn _ -> false end))
|> Aoc.make_table

n = length(lines)
m = Enum.count(table[0])

compute_shortest_path = fn start_pq, target_fun, can_go ->
    {shortest_path, pq, seen} = 1..(n*m) |> Enum.reduce_while({-1, start_pq, seen}, fn elem, {_, pq, seen} ->
        {best, new_pq} = List.pop_at(pq, 0)
        # best |> IO.inspect
        new_pq = Enum.filter(new_pq, fn %{:x => x, :y => y} -> best.x != x || best.y != y end)
        new_seen = put_in(seen, [best.y, best.x], true)

        if target_fun.(best) do
            {:halt, {best.v, pq, new_seen}}
        else
            new_pq = if best.y > 0 && not seen[best.y-1][best.x] && can_go.(best.y-1,best.x,best.y,best.x) do
                [%{:v => best.v + 1, :y => best.y-1, :x => best.x} | new_pq]
            else
                new_pq
            end

            new_pq = if best.y < n-1 && not seen[best.y+1][best.x] && can_go.(best.y+1,best.x,best.y,best.x) do
                [%{:v => best.v + 1, :y => best.y+1, :x => best.x} | new_pq]
            else
                new_pq
            end

            new_pq = if best.x > 0 && not seen[best.y][best.x-1] && can_go.(best.y,best.x-1,best.y,best.x) do
                [%{:v => best.v + 1, :y => best.y, :x => best.x-1} | new_pq]
            else
                new_pq
            end

            new_pq = if best.x < m-1 && not seen[best.y][best.x+1] && can_go.(best.y,best.x+1,best.y,best.x) do
                [%{:v => best.v + 1, :y => best.y, :x => best.x+1} | new_pq]
            else
                new_pq
            end

            new_pq = Enum.sort_by(new_pq, &(&1.v), :asc)

            {:cont, {-1, new_pq, new_seen}}
        end
    end)
    shortest_path
end

#p1
can_go1 = fn ny, nx, y, x ->
    table[ny][nx] - table[y][x] <= 1
end
target_fn1 = fn best ->
    best.y == fin_y && best.x == fin_x
end
pq = [%{:v => 0, :y => start_y, :x => start_x}]
shortest_path = compute_shortest_path.(pq, target_fn1, can_go1)
IO.puts(shortest_path)

#p2
can_go2 = fn ny, nx, y, x ->
    table[y][x] - table[ny][nx] <= 1
end
target_fn2 = fn best ->
    table[best.y][best.x] == 1
end
pq = [%{:v => 0, :y => fin_y, :x => fin_x}]
shortest_path = compute_shortest_path.(pq, target_fn2,can_go2)
IO.puts(shortest_path)