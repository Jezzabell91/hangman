strip = Proc.new do |word|
    word.to_s.strip!
end

between_five_twelve = Proc.new do |word|
    word.to_s.length >= 5 && word.length <= 12
end

filtered_dictionary = File.open("filtered_dictionary.txt", "w+"){
    |file| file.puts File.open("dictionary.txt").readlines.map(&strip).select(&between_five_twelve)
}

