MODULO = 998244353

class ElementPair
    attr_reader :first_element, :second_element, :rule, :bound

    def initialize(first_element, second_element, rule, bound)
        @first_element = first_element
        @second_element = second_element
        @rule = rule
        @bound = bound
    end

    def satisfiable?
        if @first_element != -1 && @second_element != -1
            if @rule == 0
                return [@first_element, @second_element].min == @bound
            else
                return [@first_element, @second_element].max == @bound
            end
        end
        true
    end

    def generate_possible_assignments(available)
        assignments = []
        if @first_element != -1 && @second_element != -1
            assignments << [@first_element, @second_element]
            return assignments
        end

        if @first_element != -1 || @second_element != -1
            fixed_element = @first_element != -1 ? @first_element : @second_element
            is_first_fixed = @first_element != -1
            if @rule == 0
                return assignments if fixed_element < @bound
                if fixed_element == @bound
                    available.each do |num|
                        if num > @bound && num != fixed_element
                            if is_first_fixed
                                assignments << [fixed_element, num]
                            else
                                assignments << [num, fixed_element]
                            end
                        end
                    end
                else
                    assignments << [fixed_element, @bound]
                end
            else
                return assignments if fixed_element > @bound
                if fixed_element == @bound
                    available.each do |num|
                        if num < @bound && num != fixed_element
                            if is_first_fixed
                                assignments << [fixed_element, num]
                            else
                                assignments << [num, fixed_element]
                            end
                        end
                    end
                else
                    assignments << [fixed_element, @bound]
                end
            end
            return assignments
        end

        if @rule == 0
            return assignments unless available.include?(@bound)
            available.each do |num|
                if num > @bound && num != @bound
                    assignments << [@bound, num]
                    assignments << [num, @bound]
                end
            end
        else
            return assignments unless available.include?(@bound)
            available.each do |num|
                if num < @bound && num != @bound
                    assignments << [@bound, num]
                    assignments << [num, @bound]
                end
            end
        end
        assignments
    end
end

def main
    input = $stdin.read.split
    pair_count = input.shift.to_i

    elements = input.shift(2 * pair_count).map(&:to_i)
    rules = input.shift(pair_count).map(&:to_i)
    bounds = input.shift(pair_count).map(&:to_i)

    is_used = Array.new(2 * pair_count + 1, false)
    elements.each { |value| is_used[value] = true if value != -1 }

    available_numbers = (1..2 * pair_count).reject { |i| is_used[i] }

    element_pairs = []
    pair_count.times do |i|
        first_element = elements[2 * i]
        second_element = elements[2 * i + 1]
        element_pairs << ElementPair.new(first_element, second_element, rules[i], bounds[i])
    end

    element_pairs.each do |pair|
        unless pair.satisfiable?
            puts 0
            return
        end
    end

    possible_assignments = element_pairs.map { |pair| pair.generate_possible_assignments(available_numbers) }

    sorted_pair_indices = (0...pair_count).to_a.sort_by { |i| possible_assignments[i].size }

    memoization_map = { 0 => 1 }

    pair_count.times do |i|
        new_memoization_map = {}
        current_pair_index = sorted_pair_indices[i]
        memoization_map.each do |mask, ways|
            possible_assignments[current_pair_index].each do |assignment|
                num1, num2 = assignment
                pos1 = num1 - 1
                pos2 = num2 - 1
                next if (mask & (1 << pos1) != 0) || (mask & (1 << pos2) != 0)
                updated_mask = mask | (1 << pos1) | (1 << pos2)
                new_memoization_map[updated_mask] = (new_memoization_map[updated_mask] || 0) + ways
                new_memoization_map[updated_mask] %= MODULO
            end
        end
        memoization_map = new_memoization_map
        break if memoization_map.empty?
    end

    total_ways = memoization_map.values.sum % MODULO
    puts total_ways
end

main if __FILE__ == $PROGRAM_NAME
