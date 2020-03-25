function Reference_test_req(type::ReferenceType)

    ref = Reference(type, "key:20:key",
                    Dict("author" => "Key", "title" => "K E Y"),
                    :none, "A note.")
    return requiredfields(ref)

end

function Reference_test_opt(type::ReferenceType)

    ref = Reference(type, "key:20:key",
                    Dict("author" => "Key", "title" => "K E Y"),
                    :none, "A note.")
    return optionalfields(ref)

end

@testset "Reference" begin

    @testset "Required Fields" begin

        @test Reference_test_req(Article()) == ["author", "title", "journal", "year"]
        @test Reference_test_req(Book()) == ["author", "title", "publisher", "year"]
        @test Reference_test_req(Booklet()) == ["title"]
        @test Reference_test_req(Conference()) == ["author", "title"]
        @test Reference_test_req(InBook()) == ["author", "title", "chapter", "publisher", "year"]
        @test Reference_test_req(InCollection()) == ["author", "title", "booktitle"]
        @test Reference_test_req(InProceedings()) == ["author", "title"]
        @test Reference_test_req(Manual()) == ["title"]
        @test Reference_test_req(MasterThesis()) == ["author", "title", "school", "year"]
        @test Reference_test_req(Misc()) == String[]
        @test Reference_test_req(PhdThesis()) == ["author", "title", "school", "year"]
        @test Reference_test_req(Proceedings()) == ["title", "year"]
        @test Reference_test_req(TechReport()) == ["author", "title", "institution", "year"]
        @test Reference_test_req(Unpublished()) == ["author", "title"]

    end

    @testset "Optional Fields" begin

        @test Reference_test_opt(Article()) == ["month", "volume", "number", "pages", "doi"]
        @test Reference_test_opt(Book()) == ["month", "volume", "number", "series", "address", "edition"]
        @test Reference_test_opt(Booklet()) == ["author", "howpublished", "address", "year", "month"]
        @test Reference_test_opt(Conference()) == ["booktitle", "year", "month", "editor", "volume", "number", "series", "pages", "address", "organization", "publisher", "url"]
        @test Reference_test_opt(InBook()) == ["month", "volume", "number", "series", "type", "address", "edition", "pages"]
        @test Reference_test_opt(InCollection()) == ["publisher", "editor", "year", "month", "volume", "number", "series", "type", "chapter", "pages", "edition", "address"]
        @test Reference_test_opt(InProceedings()) == ["booktitle", "year", "month", "editor", "volume", "number", "series", "pages", "address", "organization", "publisher", "url"]
        @test Reference_test_opt(Manual()) == ["author", "organization", "address", "edition", "year", "month"]
        @test Reference_test_opt(MasterThesis()) == ["month", "type", "address", "url"]
        @test Reference_test_opt(Misc()) == ["author", "title", "year", "month", "howpublished", "url"]
        @test Reference_test_opt(PhdThesis()) == ["month", "type", "address", "url"]
        @test Reference_test_opt(Proceedings()) == ["month", "booktitle", "editor", "volume", "number", "series", "address", "organization", "publisher", "url"]
        @test Reference_test_opt(TechReport()) == ["month", "type", "number", "address"]
        @test Reference_test_opt(Unpublished()) == ["year", "month", "url"]

    end

end
