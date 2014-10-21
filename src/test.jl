using Base.Test

type Index
    index
end

global index = Index(1)

befores = Dict();

function context(f::Function, description)
    index.index = index.index + 1

    println(description)
    f()
end

macro before(exp::Expr)
    befores[index.index] = exp

    esc(exp)
end
