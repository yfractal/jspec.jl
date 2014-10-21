using Base.Test

global context_counter = [0]
befores = Dict();

function context(f::Function, description)
    push!(context_counter, context_counter[end] + 1)

    println(description)
    f()
end

macro before(exp::Expr)
    esc(merge!(befores, {context_counter[end] => exp}))

    println(befores)
    esc(exp)
end
