def get_points_for_result(result)
    if result == "X"
        return 0
    elsif result == "Y"
        return 3
    elsif result == "Z"
        return 6
    end
end

def get_outcome(opponent_action, result) 
    if (opponent_action == "A" and result == "Z") or (opponent_action == "B" and result == "Y") or (opponent_action == "C" and result == "X")
        return 2
    elsif (opponent_action == "A" and result == "Y") or (opponent_action == "B" and result == "X") or (opponent_action == "C" and result == "Z")
        return 1
    elsif (opponent_action == "A" and result == "X") or (opponent_action == "B" and result == "Z") or (opponent_action == "C" and result == "Y")
        return 3
    end
end

def get_score(opponent_action, result) 
    return get_outcome(opponent_action, result) + get_points_for_result(result)
end

total_score = 0
File.open("input.txt").each do |line|
    actions = line.split(" ")
    opponent_action = actions[0]
    result = actions[1]

    total_score = total_score + get_score(opponent_action, result)
end

puts total_score