def inclusion_exclusion(index, current_product, count, n, k, elasticities, result)
    (index...k).each do |i|
        next if current_product > n / elasticities[i]

        new_product = current_product * elasticities[i]
        next if new_product > n

        new_count = count + 1

        if new_count.odd?
            result[0] += n / new_product
        else
            result[0] -= n / new_product
        end

        inclusion_exclusion(i + 1, new_product, new_count, n, k, elasticities, result)
    end
end

begin
    input = gets.strip.split.map(&:to_i)
    n = input[0]
    k = input[1]

    elasticities = gets.strip.split.map(&:to_i)
    elasticities.sort!

    result = [0]
    inclusion_exclusion(0, 1, 0, n, k, elasticities, result)

    puts result[0]
rescue StandardError => e
    STDERR.puts "An error occurred: #{e.message}"
end
