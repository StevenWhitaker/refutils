using Test
include("../src/Reference.jl")
include("../src/writemasterbib.jl")

@testset "refutils" begin
    include("Reference.jl")
    include("writemasterbib.jl")
end
