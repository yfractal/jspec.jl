using Base.Test
import Base.Test.do_test

type Index
    index
end

global index = Index(1)

befores = Dict();

# another name of context
# each context has one before
# in the context's before, there is some precondition or setup things
# and the context's before will be execuate before each @it(test).
# so it the precondition is setted up
function context(f::Function, description)
    index.index = index.index + 1 # use the index to identify the current context's before

    println(description)
    f()
end

# another name of setup
macro before(exp::Expr)
    befores[index.index] = exp
end

# works like test
# use origin variable do compare because, setup need "polute" the variable
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

# origin test code from julia
# macro test(ex)
#     if typeof(ex) == Expr && ex.head == :comparison
#         syms = [gensym() for i = 1:length(ex.args)]
#         func_block = Expr(:block)
#         # insert assignment into a block
#         func_block.args = [:($(syms[i]) = $(esc(ex.args[i]))) for i = 1:length(ex.args)]
#         # finish the block with a return
#         push!(func_block.args, Expr(:return, :(Expr(:comparison, $(syms...)), $(Expr(:comparison, syms...)))))
#         :(do_test(()->($func_block), $(Expr(:quote,ex))))
#     else
#         :(do_test(()->($(Expr(:quote,ex)), $(esc(ex))), $(Expr(:quote,ex))))
#     end
# end
