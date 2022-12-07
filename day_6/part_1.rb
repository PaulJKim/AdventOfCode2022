def check_four(sub_string, full_string)
  uniq_string = sub_string[0, 4].split("").uniq
  puts "Unique values #{uniq_string}"
  if uniq_string.length < 4 
    check_four(sub_string[1..], full_string)
  else
    index = full_string.index(sub_string)
    puts puts "Number of characters processed: #{index + 4}"
  end
end

text = File.read("input.txt")
check_four(text, text)


