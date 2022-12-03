sum = 0
File.open("input.txt").each_slice(3) do |chunk|    
    common = chunk[0].chars & chunk[1].chars & chunk[2].chars

    if /[a-z]/.match(common[0])
      sum = sum + common[0].ord - 'a'.ord + 1
    else
      sum = sum + common[0].ord - 'A'.ord + 27
    end
end

puts sum
