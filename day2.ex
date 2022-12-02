require Aoc

strat = fn
  {:r,:r} -> 3+1
  {:r,:p} -> 6+2
  {:r,:s} -> 0+3
  {:p,:r} -> 0+1
  {:p,:p} -> 3+2
  {:p,:s} -> 6+3
  {:s,:r} -> 6+1
  {:s,:p} -> 0+2
  {:s,:s} -> 3+3
end

matchMyCode = fn
  {:r, "X"} -> :s
  {:p, "X"} -> :r
  {:s, "X"} -> :p
  {:r, "Y"} -> :r
  {:p, "Y"} -> :p
  {:s, "Y"} -> :s
  {:r, "Z"} -> :p
  {:p, "Z"} -> :s
  {:s, "Z"} -> :r
end

matchCode = fn
  "A " <> m -> strat.({:r, matchMyCode.({:r, m})})
  "B " <> m -> strat.({:p, matchMyCode.({:p, m})})
  "C " <> m -> strat.({:s, matchMyCode.({:s, m})})
end

lines = Aoc.getInputLines("d2a.txt")
IO.puts(Enum.sum(Enum.map(lines,matchCode)))
