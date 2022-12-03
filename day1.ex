require Aoc

chunk_fun = fn elem, acc ->             
if elem == "" do                        
  {:cont, acc, 0}                       
else                                    
  {:cont, acc + String.to_integer(elem)}
end
end

after_fun = fn
  acc -> {:cont, acc, 0}
end

lines = Aoc.getInputLines("d1a.txt")
chunky = Enum.chunk_while(lines, 0, chunk_fun, after_fun)
chunky |> Enum.sort(:desc) |> Enum.take(3) |> Enum.sum |> IO.puts
