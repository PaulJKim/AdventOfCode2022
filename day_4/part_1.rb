def range_to_set(range) 
  limits = range.split("-")

  return (limits[0].to_i..limits[1].to_i).to_a
end

count = 0
File.open("input.txt").each do |line|
  ranges = line.split(",")
  set_1 = range_to_set(ranges[0])
  set_2 = range_to_set(ranges[1])
  
  intersection = set_1 & set_2

  if set_1 == intersection or set_2 == intersection
    count = count + 1
  end
end

puts count

