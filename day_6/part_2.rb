def check_fourteen(sub_string, full_string)
  uniq_string = sub_string[0, 14].split("").uniq
  puts "Unique values #{uniq_string}"
  if uniq_string.length < 14 
    check_fourteen(sub_string[1..], full_string)
  else
    index = full_string.index(sub_string)
    puts "Number of characters processed: #{index + 14}"
  end
end

text = File.read("input.txt")
check_fourteen(text, text)


