sum_array = []
current_sum = 0

File.open("input.txt").each do |line|
    if line.length == 1
        sum_array.push(current_sum)
        current_sum = 0
    else
        current_sum = current_sum + line.to_i
    end
end

puts sum_array.sort.last(3).sum