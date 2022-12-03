sum = 0
File.open("input.txt").each do |line|
    first_half, second_half = line[0...line.length/2], line[line.length/2..-1]
    
    common = first_half.chars & second_half.chars

    if /[a-z]/.match(common[0])
      sum = sum + common[0].ord - 'a'.ord + 1
    else
      sum = sum + common[0].ord - 'A'.ord + 27
    end
end

puts sum
