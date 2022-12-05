require Aoc

lines = Aoc.getInputLinesWithWhitespace("d5a.txt")
{stack, instruction} = Enum.split_while(lines, fn l -> l != "" end)

stackLabels = List.last(stack) |> String.trim |> String.split(" ", trim: true)

drop_spaces = fn str ->
  String.to_charlist(str) |> Enum.chunk_every(3, 4) |> Enum.map(&List.to_string/1)
end

stackData = Enum.take(stack, length(stack)-1) |> Enum.map(drop_spaces)

remove_empty_cells = fn l ->
  Enum.drop_while(l, fn e -> String.trim(e) == "" end)
end

stackData = stackData |> Enum.zip |> Enum.map(&Tuple.to_list(&1)) |> Enum.map(remove_empty_cells)
stackMap = Enum.zip(stackLabels, stackData) |> Map.new

parse_cmd = fn cmd ->
  Regex.named_captures(~r/move (?<c>\d+) from (?<o>\d+) to (?<d>\d+)/, cmd)
end

instruction = instruction |> Enum.drop(1)
cmds = instruction |> Enum.map(parse_cmd)

make_process = fn do_reverse ->
  process_cmd = fn cmd, map ->
    %{"c" => count, "o" => from, "d" => to} = cmd
    count = String.to_integer(count)
    from_row = Map.fetch!(map, from)
    to_row = Map.fetch!(map, to)
    elems = Enum.take(from_row, count)
    new_from_row = Enum.drop(from_row, count)
    new_to_row = if do_reverse do
      Enum.reverse(elems) ++ to_row
    else
      elems ++ to_row
    end
    map = Map.put(map, from, new_from_row)
    Map.put(map, to, new_to_row)
  end
end

get_stack_top = fn
  [] -> ""
  l -> String.trim_trailing(String.trim_leading(List.first(l), "["), "]")
end

#p1
Enum.reduce(cmds, stackMap, make_process.(true)) |> Map.values() |> Enum.map(get_stack_top) |> Enum.join |> IO.puts

#p2
Enum.reduce(cmds, stackMap, make_process.(false)) |> Map.values() |> Enum.map(get_stack_top) |> Enum.join |> IO.puts

  



