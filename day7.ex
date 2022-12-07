require Aoc

chunk_fun = fn elem, acc ->             
if String.starts_with?(elem, "$") do                        
  {:cont, Enum.reverse(acc), [elem]}                       
else                                    
  {:cont, [elem | acc]}
end
end

after_fun = fn
  acc -> {:cont, Enum.reverse(acc), []}
end

lines = Aoc.getInputLines("d7a.txt") |> Enum.drop(1)
cmd = Enum.chunk_while(lines, [], chunk_fun, after_fun) |> Enum.drop(1)

process_ls_entry = fn elem, fs, current ->
  {pref, suf} = List.to_tuple(String.split(elem, " "))
  if pref == "dir" do
    new_dir = current ++ [suf]
    if not Map.has_key?(fs, new_dir) do
      Map.put(fs, new_dir, %{:sz => 0, :is_dir => true})
    else
      fs
    end
  else
    sz = String.to_integer(pref)
    new_file = current ++ [suf]
    if not Map.has_key?(fs, new_file) do
      Map.put(fs, new_file, %{:sz => sz, :is_dir => false})
    else
      fs
    end
  end
end

  
follow_cmds = fn input, tup ->
  {current, fs} = tup
  cmdtype = List.first(input)
  if String.starts_with?(cmdtype, "$ cd") do
    new_dir_name = String.trim_leading(cmdtype, "$ cd ")
    cond do
      new_dir_name == "/" -> {["/"], fs}
      new_dir_name == ".." -> {Enum.take(current, length(current)-1), fs}
      true ->
	new_dir = current ++ [new_dir_name]
	if Map.has_key?(fs, new_dir) do
	  {new_dir, fs}
	else
	  throw(new_dir)
	end
    end
  else
    fs = input |> Enum.drop(1) |> Enum.reduce(fs, &process_ls_entry.(&1,&2,current))
    {current, fs}
  end
end

acc = {["/"], %{["/"] => %{:sz => 0, :is_dir => true}}}
{_, fs} = Enum.reduce(cmd, acc, follow_cmds)

list_filter? = fn list, prefix ->
  (length(list) == length(prefix) + 1) && List.starts_with?(list, prefix)
end

to_size = fn child, fs ->
  if Map.has_key?(fs, child) do
    Map.fetch!(fs, child)[:sz]
  else
    0
  end
end

calc_size = fn path, fs ->
  entry = Map.fetch!(fs, path)
  if not entry[:is_dir] do
    fs
  else
    sz = Map.keys(fs)
    |> Enum.filter(&list_filter?.(&1,path))
    |> Enum.map(&to_size.(&1,fs))
    |> Enum.sum
    Map.put(fs, path, %{:sz => sz, :is_dir => true})
  end
end

paths = Map.keys(fs)
|> Enum.sort_by(&(length(&1)), :desc)

fs = Enum.reduce(paths, fs, calc_size)

# p1
Map.values(fs)
|> Enum.filter(&(&1[:is_dir]))
|> Enum.map(&(&1[:sz]))
|> Enum.filter(&(&1 < 100000))
|> Enum.sum
|> IO.puts

# p2
unused = 70000000 - Map.fetch!(fs, ["/"])[:sz]
need = 30000000 - unused
Map.values(fs)
|> Enum.filter(&(&1[:is_dir]))
|> Enum.map(&(&1[:sz]))
|> Enum.filter(&(&1 >= need))
|> Enum.sort(:asc)
|> IO.inspect
|> Enum.take(1)
|> IO.inspect
