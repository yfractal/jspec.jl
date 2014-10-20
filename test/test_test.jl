include("../src/test.jl")

# context should work like below
context("do some test") do
    @test 1 == 1
end


context("before macro") do
    # it take a block
    @before begin
        x = 1
    end

    @test x == 1
end

# outer of the context, x should not be defined
try
    x
catch error
    @test typeof(error) == UndefVarError
end
