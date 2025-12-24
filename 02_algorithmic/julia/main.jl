function board_string(pos::Vector{Int})
    n = length(pos)
    io = IOBuffer()
    for r in 1:n
        c = pos[r]
        for j in 1:n
            print(io, j == c ? 'Q' : '.')
            if j < n
                print(io, ' ')
            end
        end
        print(io, '\n')
    end
    return String(take!(io))
end

function solve_nqueens(n::Int)
    if n < 1
        error("N must be >= 1")
    end
    if n > 63
        error("N too large for UInt64 bitmask demo (use N<=63)")
    end

    all::UInt64 = (UInt64(1) << n) - 1
    positions = Vector{Int}(undef, n)   # positions[row] = col (1-based)
    first_solution = Ref{Vector{Int}}()
    has_first = Ref(false)
    count = Ref(0)

    function backtrack(row::Int, cols::UInt64, d1::UInt64, d2::UInt64)
        if row == n
            count[] += 1
            if !has_first[]
                first_solution[] = copy(positions)
                has_first[] = true
            end
            return
        end

        avail = all & ~(cols | d1 | d2)
        while avail != 0
            bit = avail & (~avail + 1)
            col = trailing_zeros(bit) + 1
            positions[row + 1] = col
            backtrack(
                row + 1,
                cols | bit,
                ((d1 | bit) << 1) & all,
                (d2 | bit) >> 1,
            )
            avail &= avail - 1
        end
    end

    t0 = time_ns()
    backtrack(0, UInt64(0), UInt64(0), UInt64(0))
    t1 = time_ns()

    return (count = count[], solution = has_first[] ? first_solution[] : nothing, elapsed_ms = (t1 - t0) / 1e6)
end

function main()
    n = length(ARGS) > 0 ? parse(Int, ARGS[1]) : 12
    res = solve_nqueens(n)
    println("N = ", n)
    println("solutions = ", res.count)
    println("time_ms = ", round(res.elapsed_ms; digits=3))
    if res.solution === nothing
        println("no solution")
    else
        println("\none solution:")
        print(board_string(res.solution))
    end
end

main()


