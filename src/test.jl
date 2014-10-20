using Base.Test
function context(f::Function, description)
    println(description)
    f()
end
