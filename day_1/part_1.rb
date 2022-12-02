current_max_sum = 0
current_sum = 0

File.open("input.txt").each do |line|
    if line.length == 1
        if current_sum > current_max_sum
            current_max_sum = current_sum
        end
        current_sum = 0
    else
        current_sum = current_sum + line.to_i
    end
end

puts current_max_sum