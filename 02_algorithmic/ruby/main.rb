def sieve(n)
  return [] if n < 2
  is_prime = Array.new(n + 1, true)
  is_prime[0] = false
  is_prime[1] = false

  p = 2
  while p * p <= n
    if is_prime[p]
      (p * p).step(n, p) { |k| is_prime[k] = false }
    end
    p += 1
  end

  (2..n).select { |i| is_prime[i] }
end

n = (ARGV[0] || "100").to_i
puts sieve(n).join(", ")


