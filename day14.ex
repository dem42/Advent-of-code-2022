require Aoc

lines = Aoc.getInputLines("d14.txt")

data_0 = lines
|> Enum.map(&String.split(&1, " -> "))
|> Enum.map(&Enum.map(&1, fn str -> List.to_tuple(String.split(str,",") |> Enum.map(fn v -> String.to_integer(v) end)) end))

solve = fn data ->
    data_flat = data |> List.flatten
    {max_x, _} = data_flat |> Enum.max_by(fn {f,_} -> f end)
    {min_x, _} = data_flat |> Enum.min_by(fn {f,_} -> f end)
    {_, max_y} = data_flat |> Enum.max_by(fn {_,f} -> f end)
    min_y = 0

    IO.inspect({min_x, max_x, min_y, max_y})

    max_sand = (max_x - min_x + 1) * (max_y - min_y)

    out_of_bounds = fn x,y,state ->
        x > max_x || x < min_x || y > max_y || (y == 0 && state[x-min_x][y])
    end

    free = fn state,x,y ->
        test_x = x - min_x
        if state[test_x][y] == nil do
            IO.inspect({x,y})
        end
        y > max_y || test_x < 0 || test_x > max_x - min_x || not state[test_x][y]
    end

    move_sand = fn {x,y}, state, self ->
        cond do
            out_of_bounds.(x, y, state) -> {:halt, state}
            free.(state, x, y+1) -> self.({x,y+1}, state, self)
            free.(state, x-1, y+1) -> self.({x-1,y+1}, state, self)
            free.(state, x+1, y+1) -> self.({x+1,y+1}, state, self)
            true ->
                new_state = put_in(state, [x-min_x, y], true)
                {:cont, new_state}
        end
    end

    drop_sand = fn v, {_, state} ->
        new_sand_pos = {500, 0}
        {res, new_state} = move_sand.(new_sand_pos, state, move_sand)
        {res, {v, new_state}}
    end

    state = List.duplicate(List.duplicate(false,max_y - min_y + 1),(max_x - min_x + 1))
    |> Aoc.make_table

    state = data |> Enum.flat_map(&Enum.chunk_every(&1, 2, 1, :discard))
    |> Enum.map(&List.to_tuple/1)
    |> Enum.reduce(state, fn {{fx,fy},{tx,ty}}, state ->
        minx = Enum.min([fx,tx]) - min_x
        maxx = Enum.max([fx,tx]) - min_x
        miny = Enum.min([fy,ty])
        maxy = Enum.max([fy,ty])
        if minx == maxx do
            miny..maxy |> Enum.reduce(state, fn y, acc ->
                put_in(acc, [minx, y], true)
            end)
        else
            minx..maxx |> Enum.reduce(state, fn x, acc ->
                put_in(acc, [x, miny], true)
            end)
        end
    end)
    {max_sand, state, drop_sand}
end

#p1
{max_sand, state, drop_sand} = solve.(data_0)
{res, new_state} = 1..max_sand |> Enum.reduce_while({0, state}, drop_sand)
IO.puts(res-1)

#p2
data_flat = data_0 |> List.flatten
{_, max_y} = data_flat |> Enum.max_by(fn {_,f} -> f end)
h = max_y + 2
data_1 = [[{500 - h, h}, {500 + h, h}] | data_0]
{max_sand, state, drop_sand} = solve.(data_1)
{res, new_state} = 1..max_sand |> Enum.reduce_while({0, state}, drop_sand)
IO.puts(res-1)
