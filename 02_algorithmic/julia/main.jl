function sieve(n::Int)
    if n < 2
        return Int[]
    end
    is_prime = trues(n)
    is_prime[1] = false
    p = 2
    while p * p <= n
        if is_prime[p]
            for k in p*p:p:n
                is_prime[k] = false
            end
        end
        p += 1
    end
    return [i for i in 1:n if is_prime[i]]
end

function main()
    n = length(ARGS) > 0 ? parse(Int, ARGS[1]) : 100
    primes = sieve(n)
    println(join(primes, ", "))
end

main()


