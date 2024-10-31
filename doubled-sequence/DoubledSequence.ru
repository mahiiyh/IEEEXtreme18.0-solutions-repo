def main
    require 'set'

    t = gets.to_i
    ns = Array.new(t) { gets.to_i }
    unique_ns = ns.to_set
    valid_ns = unique_ns.select { |n| n % 4 == 0 || n % 4 == 1 }.to_set
    sequences = {}

    def generate_sequence(n)
        sequence = Array.new(2 * n, 0)
        used = Array.new(n + 1, false)

        backtrack = lambda do |pos|
            return true if pos == 2 * n
            return backtrack.call(pos + 1) if sequence[pos] != 0

            (n).downto(1) do |num|
                if !used[num] && pos + num < 2 * n && sequence[pos] == 0 && sequence[pos + num] == 0
                    sequence[pos] = num
                    sequence[pos + num] = num
                    used[num] = true
                    return true if backtrack.call(pos + 1)
                    sequence[pos] = 0
                    sequence[pos + num] = 0
                    used[num] = false
                end
            end
            false
        end

        backtrack.call(0) ? sequence.join(' ') : '-1'
    end

    valid_ns.each do |n|
        sequences[n] = generate_sequence(n)
    end

    unique_ns.each do |n|
        sequences[n] ||= '-1'
    end

    results = ns.map { |n| sequences[n] }
    puts results.join("\n")
end

main
