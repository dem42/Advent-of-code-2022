require Aoc

to_monkey_and_start = fn def ->
    [("Monkey " <> idx) | rest] = def
    [("Starting items: " <> starting_items) | rest] = rest
    [("Operation: new = " <> operation_cmd) | rest] = rest
    [("Test: divisible by " <> div_num) | rest] = rest
    [("If true: throw to monkey " <> if_true_monkey) | rest] = rest
    [("If false: throw to monkey " <> if_false_monkey) | rest] = rest
    idx = String.to_integer(String.trim_trailing(idx, ":"))
    div_num = String.to_integer(div_num)
    if_true_monkey = String.to_integer(if_true_monkey)
    if_false_monkey = String.to_integer(if_false_monkey)
    starting_items = String.split(starting_items, ",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    operation_cmd = case operation_cmd do
        "old * old" -> fn val -> val*val end
        "old * " <> const ->
            const_val = String.to_integer(const)
            fn val -> val * const_val end
        "old + " <> const ->
            const_val = String.to_integer(const)
            fn val -> val + const_val end
    end
    {
        %{:idx => idx, :cmd => operation_cmd, :test_div => div_num, :t_m => if_true_monkey, :f_m => if_false_monkey},
        starting_items
    }
end

div_3_round = fn val ->
    div(val, 3)
end

lines = Aoc.getInputLines("d11.txt")
{monkeys, items0} = lines
|> Enum.chunk_every(7)
|> Enum.map(to_monkey_and_start)
|> Enum.unzip
|> IO.inspect(charlists: :as_lists)

divisor = monkeys |> Enum.map(&(&1[:test_div])) |> Enum.uniq() |> Enum.product()
|> IO.inspect

mod_divisor = fn val ->
    rem(val, divisor)
end

items = Aoc.into_map(items0)
inspect_cnt = for i <- 0..(Enum.count(monkeys)-1), into: %{}, do: {i, 0}

solver = fn reduce_fn ->
    fn round, {items0, inspect_cnt0} ->
        Enum.reduce(monkeys, {items0, inspect_cnt0}, fn monkey, {items1, inspect_cnt1} ->
            our_monkey_items = items1[monkey.idx]
            true_monkey_items = items1[monkey.t_m]
            false_monkey_items = items1[monkey.f_m]
            {true_monkey_items, false_monkey_items} = Enum.reduce(our_monkey_items, {true_monkey_items, false_monkey_items}, fn our_item, {true_monkey_items1, false_monkey_items1} ->
                new_val = reduce_fn.(monkey.cmd.(our_item))
                test_res = rem(new_val, monkey.test_div) == 0
                if test_res do
                    {true_monkey_items1 ++ [new_val], false_monkey_items1}
                else
                    {true_monkey_items1, false_monkey_items1 ++ [new_val]}
                end
            end)
            inspect_cnt1 = Map.put(inspect_cnt1, monkey.idx, inspect_cnt1[monkey.idx] + length(our_monkey_items))
            items1 = Map.put(items1, monkey.idx, [])
            items1 = Map.put(items1, monkey.t_m, true_monkey_items)
            items1 = Map.put(items1, monkey.f_m, false_monkey_items)
            {items1, inspect_cnt1}
        end)
    end
end

# p1
items = Aoc.into_map(items0)
inspect_cnt = for i <- 0..(Enum.count(monkeys)-1), into: %{}, do: {i, 0}
{items, inspect_cnt} = Enum.reduce(1..20, {items, inspect_cnt}, solver.(div_3_round))
inspect_cnt |> IO.inspect
Map.values(inspect_cnt) |> Enum.sort(:desc) |> Enum.take(2) |> Enum.product() |> IO.puts

# p2
items = Aoc.into_map(items0)
inspect_cnt = for i <- 0..(Enum.count(monkeys)-1), into: %{}, do: {i, 0}
{items, inspect_cnt} = Enum.reduce(1..10000, {items, inspect_cnt}, solver.(mod_divisor))
inspect_cnt |> IO.inspect
Map.values(inspect_cnt) |> Enum.sort(:desc) |> Enum.take(2) |> Enum.product() |> IO.puts