using Test
include("../src/Reference.jl")
include("../src/writemasterbib.jl")
include("../src/readbib.jl")

@testset "refutils" begin
    include("Reference.jl")
    include("writemasterbib.jl")
    include("readbib.jl")
end
