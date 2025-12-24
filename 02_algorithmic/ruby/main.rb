def board_string(pos)
  n = pos.length
  pos.map do |c|
    (1..n).map { |j| j == c ? "Q" : "." }.join(" ")
  end.join("\n")
end

def solve_nqueens(n)
  raise ArgumentError, "N must be >= 1" if n < 1
  raise ArgumentError, "N too large for bitmask demo (use N <= 63)" if n > 63

  all = (1 << n) - 1
  positions = Array.new(n)
  first = nil
  count = 0

  rec = lambda do |row, cols, diag1, diag2|
    if row == n
      count += 1
      first ||= positions.dup
      return
    end

    avail = all & ~(cols | diag1 | diag2)
    while avail != 0
      bit = avail & -avail
      col = bit.bit_length # trailingZeros + 1, но проще через bit_length
      positions[row] = col
      rec.call(row + 1, cols | bit, (diag1 | bit) << 1, (diag2 | bit) >> 1)
      avail &= avail - 1
    end
  end

  t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  rec.call(0, 0, 0, 0)
  t1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  { count: count, solution: first, time_ms: (t1 - t0) * 1000.0 }
end

n = (ARGV[0] || "12").to_i
res = solve_nqueens(n)

puts "N = #{n}"
puts "solutions = #{res[:count]}"
puts format("time_ms = %.3f", res[:time_ms])
if res[:solution]
  puts "\none solution:"
  puts board_string(res[:solution])
else
  puts "no solution"
end


