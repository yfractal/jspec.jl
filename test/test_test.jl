include("../src/test.jl")

# context should work like below
context("do some test") do
    @test 1 == 1
end
