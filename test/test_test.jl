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

    @it x == 1
end

# outer of the context, x should not be defined
try
    x
catch error
    @test typeof(error) == UndefVarError
end

type Foo
    f
end

function change_foo!(foo)
    foo.f = "changed"
    foo
end


context("before") do
    @before begin
        foo = Foo(1)
    end

    @it foo.f == 1
    @it change_foo!(foo).f == "changed"
    @it foo.f == 1
end
