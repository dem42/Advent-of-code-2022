require Aoc

lines = Aoc.getInputLines("d10.txt")

test_points = 20..(length(lines)*2)//40 |> Aoc.into_map
key_cnt = Enum.count(test_points)

update_acc = fn acc, new_cycle, new_signal ->
    {new_total, new_testidx} = if acc.testidx < key_cnt && new_cycle >= test_points[acc.testidx] do
        update_val = if new_cycle == test_points[acc.testidx], do: acc.total + new_signal * test_points[acc.testidx], else: acc.total + acc.signal * test_points[acc.testidx]
        {update_val, acc.testidx + 1}
    else
        {acc.total, acc.testidx}
    end
    %{
        :signal => new_signal,
        :cycle => new_cycle,
        :total => new_total,
        :testidx => new_testidx,
    }
end

process_fun = fn cmd, acc ->
    case cmd do
        "noop" ->
            update_acc.(acc, acc.cycle + 1, acc.signal)
        "addx " <> val ->
            val = String.to_integer(val)
            update_acc.(acc, acc.cycle + 2, acc.signal + val)
    end
end

process_fun2 = fn cmd, acc ->
    new_acc = case cmd do
        "noop" ->
            update_acc.(acc, acc.cycle + 1, acc.signal)
        "addx " <> val ->
            val = String.to_integer(val)
            update_acc.(acc, acc.cycle + 2, acc.signal + val)
    end
    {{new_acc.cycle, new_acc.signal}, new_acc}
end

#p1
%{:total => res} = lines |> Enum.reduce(%{:signal => 1, :total => 0, :testidx => 0, :cycle => 1}, process_fun)
|> IO.inspect

IO.puts(res)

{states, _} = lines |> Enum.map_reduce(%{:signal => 1, :total => 0, :testidx => 0, :cycle => 1}, process_fun2)

state_map = Aoc.into_map(states)

{crt, _} = 1..240 |> Enum.map_reduce({0, 1}, fn cycle, {cur_idx, cur_sig} ->
    {new_cycle, new_signal} = state_map[cur_idx]
    crt_pos = rem(cycle-1, 40)
    {new_cur_idx, new_signal} = if cycle < new_cycle do
        {cur_idx, cur_sig}
    else
        {cur_idx + 1, new_signal}
    end
    crt_pixel = if abs(crt_pos - new_signal) <= 1, do: '#', else: ' '
    {crt_pixel, {new_cur_idx, new_signal}}
end)

crt
|> Enum.chunk(40)
|> Enum.map(&Enum.join/1)
|> IO.inspect