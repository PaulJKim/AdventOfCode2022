def get_points_for_action(my_action)
    if my_action == "X"
        return 1
    elsif my_action == "Y"
        return 2
    elsif my_action == "Z"
        return 3
    end
end

def get_outcome(opponent_action, my_action) 
    if (opponent_action == "A" and my_action == "X") or (opponent_action == "B" and my_action == "Y") or (opponent_action == "C" and my_action == "Z")
        return 3
    elsif (opponent_action == "A" and my_action == "Y") or (opponent_action == "B" and my_action == "Z") or (opponent_action == "C" and my_action == "X")
        return 6
    elsif (opponent_action == "A" and my_action == "Z") or (opponent_action == "B" and my_action == "X") or (opponent_action == "C" and my_action == "Y")
        return 0
    end
end

def get_score(opponent_action, my_action) 
    return get_outcome(opponent_action, my_action) + get_points_for_action(my_action)
end

total_score = 0
File.open("input.txt").each do |line|
    player_actions = line.split(" ")
    opponent_action = player_actions[0]
    my_action = player_actions[1]

    total_score = total_score + get_score(opponent_action, my_action)
end

puts total_score