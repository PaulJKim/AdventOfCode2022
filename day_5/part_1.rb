stacks = {
  "1" => ["S", "P", "W", "N", "J", "Z"],
  "2" => ["T", "S", "G"],
  "3" => ["H", "L", "R", "Q", "V"],
  "4" => ["D", "T", "S", "V"],
  "5" => ["J", "M", "B", "D", "T", "Z", "Q"],
  "6" => ["L", "Z", "C", "D", "J", "T", "W", "M"],
  "7" => ["J", "T", "G", "W", "M", "P", "L"],
  "8" => ["H", "Q", "F", "B", "T", "M", "G", "N"],
  "9" => ["W", "Q", "B", "P", "C", "G", "D", "R"]
}

File.open("input.txt").each do |line|
  split_line = line.split
  amount, from, to = split_line[1], split_line[3], split_line[5]

  from_stack = stacks[from]
  taken, not_taken = from_stack.take(amount.to_i), from_stack.drop(amount.to_i)

  stacks[from] = not_taken

  reversed_taken = taken.reverse()
  new_stack = reversed_taken.concat(stacks[to])
  stacks[to] = new_stack
end

stacks.each do |key, stack|
  puts stack.first()
end
