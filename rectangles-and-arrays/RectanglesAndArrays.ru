class Main
    def initialize
        @n, @x = gets.split.map(&:to_i)
        @array = gets.split.map(&:to_i)
        @size = 1
        @size <<= 1 while @size < @n
        @seg_min = Array.new(2 * @size, Float::INFINITY)
        @seg_count = Array.new(2 * @size, 0)
        @seg_second_min = Array.new(2 * @size, Float::INFINITY)
    end

    def compute_left(left)
        stack = []
        @n.times do |i|
            stack.pop while !stack.empty? && @array[stack.last] >= @array[i]
            left[i] = stack.empty? ? -1 : stack.last
            stack.push(i)
        end
    end

    def compute_right(right)
        stack = []
        (@n - 1).downto(0) do |i|
            stack.pop while !stack.empty? && @array[stack.last] >= @array[i]
            right[i] = stack.empty? ? @n : stack.last
            stack.push(i)
        end
    end

    def build_segment_tree
        @n.times do |i|
            @seg_min[@size + i] = @array[i]
            @seg_count[@size + i] = 1
            @seg_second_min[@size + i] = Float::INFINITY
        end

        (@size + @n).upto(2 * @size - 1) do |i|
            @seg_min[i] = Float::INFINITY
            @seg_count[i] = 0
            @seg_second_min[i] = Float::INFINITY
        end

        (@size - 1).downto(1) { |i| merge_nodes(i) }
    end

    def merge_nodes(i)
        left_min = @seg_min[2 * i]
        left_count = @seg_count[2 * i]
        left_second_min = @seg_second_min[2 * i]

        right_min = @seg_min[2 * i + 1]
        right_count = @seg_count[2 * i + 1]
        right_second_min = @seg_second_min[2 * i + 1]

        if left_min < right_min
            @seg_min[i] = left_min
            @seg_count[i] = left_count
            @seg_second_min[i] = [right_min, left_second_min].min
        elsif left_min > right_min
            @seg_min[i] = right_min
            @seg_count[i] = right_count
            @seg_second_min[i] = [left_min, right_second_min].min
        else
            @seg_min[i] = left_min
            @seg_count[i] = left_count + right_count
            @seg_second_min[i] = [left_second_min, right_second_min].min
        end
    end

    def query_segment_tree(l, r)
        l += @size
        r += @size
        res_min = Float::INFINITY
        res_count = 0
        res_second_min = Float::INFINITY

        while l <= r
            if (l % 2) == 1
                if @seg_min[l] < res_min
                    res_second_min = [res_second_min, res_min].min
                    res_min = @seg_min[l]
                    res_count = @seg_count[l]
                elsif @seg_min[l] == res_min
                    res_count += @seg_count[l]
                else
                    res_second_min = [res_second_min, @seg_min[l]].min
                end
                l += 1
            end
            if (r % 2) == 0
                if @seg_min[r] < res_min
                    res_second_min = [res_second_min, res_min].min
                    res_min = @seg_min[r]
                    res_count = @seg_count[r]
                elsif @seg_min[r] == res_min
                    res_count += @seg_count[r]
                else
                    res_second_min = [res_second_min, @seg_min[r]].min
                end
                r -= 1
            end
            l >>= 1
            r >>= 1
        end

        QueryResult.new(res_min, res_count, res_second_min)
    end

    def run
        left = Array.new(@n)
        right = Array.new(@n)
        compute_left(left)
        compute_right(right)
        build_segment_tree

        max_area = 0
        @n.times do |i|
            area = @array[i] * (right[i] - left[i] - 1)
            max_area = area if area > max_area
        end

        @n.times do |i|
            l = left[i] + 1
            r = right[i] - 1
            next if l > r

            qr = query_segment_tree(l, r)
            m = if qr.min == @array[i] && qr.count > 1
                        qr.min
                    elsif qr.min == @array[i] && qr.count == 1
                        qr.second_min
                    else
                        qr.min
                    end
            m = m == Float::INFINITY ? @x : [@x, m].min
            area = m * (r - l + 1)
            max_area = area if area > max_area
        end

        puts max_area
    end

    class QueryResult
        attr_reader :min, :count, :second_min

        def initialize(min, count, second_min)
            @min = min
            @count = count
            @second_min = second_min
        end
    end
end

Main.new.run
