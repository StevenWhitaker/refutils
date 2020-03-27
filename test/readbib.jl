function readbib_test_1()

    refs = readbib("bibfiles/simple.txt")

end

function readbib_test_2()

    refs = readbib("bibfiles/simple.bib")

    correct = [
        Reference(Conference(), "zhao:14:sfs",
                  Dict("author" => "F. Zhao and J. A. Fessler and J-F. Nielsen and D. C. Noll",
                       "title" => "Simultaneous fat saturation and magnetization transfer preparation with steady-state incoherent sequences",
                       "booktitle" => "{Proc. Intl. Soc. Mag. Res. Med.}",
                       "pages" => "1652",
                       "url" => "http://cds.ismrm.org/protected/14MProceedings/files/1652.pdf",
                       "note" => "Invited talk.",
                       "year" => "2014"
                      )
                 ),
        Reference(Article(), "whitaker:20:asa",
                  Dict("author" => "Steven T. Whitaker and Jon-Fredrik Nielsen and Jeffrey A. Fessler",
                       "title" => "A S{\\\"i}mple Article",
                       "journal" => "{Mag. Res. Med.}",
                       "year" => "2020",
                       "volume" => "1",
                       "number" => "10",
                       "pages" => "{100--111}",
                       "month" => "jun",
                       "note" => "Submitted.",
                       "url" => "https://doi.org/10.1038/d41586-018-07848-2"
                      )
                 )
    ]

    return refs == correct

end

function readbib_test_3()

    refs = readbib("bibfiles/simple_missingfield.bib")

end

function readbib_test_4()

    refs = readbib("bibfiles/simple_missingkey.bib")

end

function readbib_test_5()

    refs = readbib("bibfiles/simple_emptykey.bib")

end

function readbib_test_6()

    refs = readbib("bibfiles/simple_missingvalue.bib")

end

function readbib_test_7()

    refs = readbib("bibfiles/simple_extra.bib")

end

function writemasterbib_readbib_test()

    refs = [
        Reference(Conference(), "whitaker:19:mwf",
                  Dict("author" => "Whitaker",
                       "title" => "Myelin water fraction",
                       "year" => "2019",
                       "booktitle" => "ISMRM"
                      )
                 ),
        Reference(Article(), "whitaker:20:awf",
                  Dict("author" => "Whitaker",
                       "title" => "Absolute water fraction",
                       "year" => "2020",
                       "journal" => "MRM"
                      )
                 ),
        Reference(Article(), "whitaker:20:mwf",
                  Dict("author" => "Whitaker",
                       "title" => "Myelin water fraction",
                       "year" => "2020",
                       "journal" => "JMRI"
                      )
                 )
    ]
    writemasterbib(refs, "./")
    result = readbib("./master.bib")
    rm("./master.bib")

    return result == refs

end

@testset "Read .bib Files" begin

    @test_throws BibExtensionError readbib_test_1()
    @test readbib_test_2()
    @test_throws MissingFieldError readbib_test_3()
    @test_throws BadBibEntryError readbib_test_4()
    @test_logs (:warn, "empty citation key") readbib_test_5()
    @test_throws BadBibEntryError readbib_test_6()
    @test_logs (:warn, "some file contents were ignored:\n@IGNOREME{@\n\nOther notes here.\n\nSome notes here too.\n") readbib_test_7()
    @test writemasterbib_readbib_test()

end
