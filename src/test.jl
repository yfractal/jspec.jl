using Base.Test
import Base.Test.do_test

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
end

# works like test
# use origin variable do compare
macro it(ex)
  if typeof(ex) == Expr && ex.head == :comparison
      func_block = Expr(:block)
      # finish the block with a return
      push!(func_block.args , befores[index.index]) # let eh func_block execuate the before's assasiment first
      push!(func_block.args, Expr(:return, :(Expr(:comparison, $(ex.args...)), $(Expr(:comparison, ex.args...)))))
      :(do_test(()->($func_block), $(Expr(:quote,ex))))
  else
      :(do_test(()->($(Expr(:quote,ex)), $(esc(ex))), $(Expr(:quote,ex))))
  end

end
