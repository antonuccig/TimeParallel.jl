@recipe function f(iterate::TimeParallelIterate; vars = nothing)
    P = length(iterate)
    for n in 1:P
        vars    --> vars
        @series iterate[n]
    end
    # solves a bug in Plots
    primary := false
    ()
end

@recipe function f(solution::TimeParallelSolution; vars = nothing, chunks = false)
    framestyle     --> :box
    legend         --> :none
    gridalpha      --> 0.2
    linewidth      --> 1.5
    minorgrid      --> 0.1
    minorgridstyle --> :dash
    seriestype     --> :path
    xwiden         --> false
    tick_direction --> :out
    vars           --> vars
    @series begin
        solution[end]
    end
    if chunks == true
        @series begin
            seriescolor --> :black
            seriestype  := :vline
            linealpha   --> 0.5
            linestyle   --> :dashdotdot
            getchunks(solution[end])
        end
    end
end

@userplot CONVERGENCE
@recipe function f(h::CONVERGENCE)
    if length(h.args) != 1 || !(h.args[1] isa TimeParallelSolution)
        error("convergence must be given TimeParallelSolution. Got $(typeof(h.args))")
    elseif h.args[1] isa TimeParallelSolution
        solution = h.args[1]
    end
    framestyle      --> :box
    legend          --> :none
    gridalpha       --> 0.2
    linewidth       --> 1.5
    markershape     --> :circle
    markersize      --> 3
    yminorgrid      --> 0.1
    yminorgridstyle --> :dash
    seriestype      --> :path
    tick_direction  --> :out
    solution.φ
end

# @recipe function f(solution::MovingWindowSolution; vars = nothing)
#     framestyle  --> :box
#     legend      --> :none
#     seriestype  --> :path
#     M = length(solution)
#     for m in 1:M
#         vars    --> vars
#         @series solution[m]
#     end
# end
