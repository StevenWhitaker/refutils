function writemasterbib_test_1()

    refs = [
        Reference(Article(), "whitaker:20:mwf",
                  Dict("author" => "Whitaker",
                       "title" => "Myelin water fraction",
                       "year" => "2020"
                      )
                 ),
        Reference(Article(), "whitaker:20:awf",
                  Dict("author" => "Whitaker",
                       "title" => "Absolute water fraction",
                       "year" => "2020",
                       "journal" => "MRM"
                      )
                 ),
        Reference(Conference(), "whitaker:19:mwf",
                  Dict("author" => "Whitaker",
                       "title" => "Myelin water fraction",
                       "year" => "2019",
                       "booktitle" => "ISMRM"
                      )
                 )
    ]
    writemasterbib(refs, "./")

end

function writemasterbib_test_2()

    refs = [
        Reference(Article(), "whitaker:20:mwf",
                  Dict("author" => "Whitaker",
                       "title" => "Myelin water fraction",
                       "year" => "2020",
                       "journal" => "JMRI"
                      )
                 ),
        Reference(Article(), "whitaker:20:awf",
                  Dict("author" => "Whitaker",
                       "title" => "Absolute water fraction",
                       "year" => "2020",
                       "journal" => "MRM"
                      )
                 ),
        Reference(Conference(), "whitaker:19:mwf",
                  Dict("author" => "Whitaker",
                       "title" => "Myelin water fraction",
                       "year" => "2019",
                       "booktitle" => "ISMRM"
                      )
                 )
    ]
    writemasterbib(refs, "./")
    result = read("./master.bib", String)
    rm("./master.bib")

    correct = """
    @CONFERENCE{whitaker:19:mwf,
        author = {Whitaker},
        title = {Myelin water fraction},
        booktitle = {ISMRM},
        year = {2019},
    }

    @ARTICLE{whitaker:20:awf,
        author = {Whitaker},
        title = {Absolute water fraction},
        journal = {MRM},
        year = {2020},
    }

    @ARTICLE{whitaker:20:mwf,
        author = {Whitaker},
        title = {Myelin water fraction},
        journal = {JMRI},
        year = {2020},
    }

    """

    return result == correct

end

@testset "Write Master .bib File" begin

    @test_throws MissingFieldError writemasterbib_test_1()
    @test writemasterbib_test_2()

end
