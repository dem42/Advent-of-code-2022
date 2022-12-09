require Aoc

parse_cmd = fn
  "R " <> v -> {:r, String.to_integer(v)}
  "L " <> v -> {:l, String.to_integer(v)}
  "U " <> v -> {:u, String.to_integer(v)}
  "D " <> v -> {:d, String.to_integer(v)}
end

is_touching = fn ty, tx, hy, hx ->
    abs(ty - hy) <= 1 && abs(tx - hx) <= 1
end

move_tail = fn ty, tx, hy, hx, map, should_update, fun ->
    new_map = if should_update do
        Aoc.deep_put_in(map, [ty, tx], true)
    else
        map
    end
    cond do
        is_touching.(hy, hx, ty, tx) -> {ty, tx, new_map}
        ty == hy -> fun.(ty, (if hx > tx, do: tx+1, else: tx-1), hy, hx, new_map, should_update, fun)
        tx == hx -> fun.((if hy > ty, do: ty+1, else: ty-1), tx, hy, hx, new_map, should_update, fun)
        (hy > ty && hx > tx) -> fun.(ty+1, tx+1, hy, hx, new_map, should_update, fun)
        (hy < ty && hx > tx) -> fun.(ty-1, tx+1, hy, hx, new_map, should_update, fun)
        (hy > ty && hx < tx) -> fun.(ty+1, tx-1, hy, hx, new_map, should_update, fun)
        (hy < ty && hx < tx) -> fun.(ty-1, tx-1, hy, hx, new_map, should_update, fun)
    end
end

step_rope = fn {cmd, val}, pos_tuple ->
    {hy, hx} = pos_tuple.rope[0]
    {nhy, nhx} = case cmd do
        :u -> {hy + 1, hx}
        :d -> {hy - 1, hx}
        :r -> {hy, hx + 1}
        :l -> {hy, hx - 1}
    end
    key_cnt = Enum.count(Map.keys(pos_tuple.rope))
    rope = pos_tuple.rope
    new_pos_tuple = %{:rope => put_in(rope[0], {nhy, nhx}), :m => pos_tuple.m}
    new_pos_tuple = 1..(key_cnt-1) |> Enum.reduce(new_pos_tuple, fn idx, acc ->
        {hy, hx} = Map.fetch!(acc.rope, idx-1)
        {ty, tx} = Map.fetch!(acc.rope, idx)
        {nty, ntx, new_map} = move_tail.(ty, tx, hy, hx, acc.m, idx == key_cnt-1, move_tail)
        new_rope = acc.rope
        new_rope = put_in(new_rope[idx], {nty, ntx})
        %{:rope => new_rope, :m => new_map}
    end)
    %{:rope => new_pos_tuple.rope, :m => new_pos_tuple.m}
end

move_and_mark = fn {cmd, val} = cmdpair, pos_tuple ->
    1..val |> Enum.reduce(pos_tuple, fn _, acc -> step_rope.(cmdpair, acc) end)
end

lines = Aoc.getInputLines("d9.txt")

build_rope = fn knots ->
    1..knots |> Enum.map(fn _ -> {0,0} end) |> Enum.with_index(&Aoc.index_first/2) |> Enum.into(%{})
end

solve = fn rope_len ->
    map = %{0 => %{0 => true}}
    s1 = build_rope.(rope_len)
    %{:m => map} = lines
    |> Enum.map(parse_cmd)
    |> Enum.reduce(%{:rope => s1, :m => map}, move_and_mark)

    map
    |> Map.values()
    |> Enum.flat_map(&Map.values/1)
    |> Enum.count
end

#p1
solve.(2) |> IO.puts
#p2
solve.(10) |> IO.puts