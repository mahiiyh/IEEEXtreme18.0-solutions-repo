class Main
    def self.run
        input = gets.chomp
        length = 2 * input.length
        start = 1
        finish = length
        left = Array.new(length + 1, 0)
        right = Array.new(length + 1, 0)

        (1..length).each do |i|
            left[i] = 0
            right[i] = 0
        end

        (1..length / 2).each do |i|
            left[i] = 2 * i if 2 * i <= length
            right[i] = 2 * i + 1 if 2 * i + 1 <= length
        end

        result = "#{length} #{start} #{finish}\n"
        (1..length).each do |i|
            result += "#{left[i]} #{right[i]}\n"
        end

        print result
    end
end

Main.run