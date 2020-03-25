"""
    ReferenceType

Abstract supertype of the different reference types that exist in BibTeX.

# Reference Types
See https://www.bibtex.com/e/entry-types/ (accessed 2020-03-25 at 9:37 AM)
- Article
- Book
- Booklet
- Conference
- InBook
- InCollection
- InProceedings
- Manual
- MasterThesis
- Misc
- PhdThesis
- Proceedings
- TechReport
- Unpublished
"""
abstract type ReferenceType end
struct Article <: ReferenceType end
struct Book <: ReferenceType end
struct Booklet <: ReferenceType end
struct Conference <: ReferenceType end
struct InBook <: ReferenceType end
struct InCollection <: ReferenceType end
struct InProceedings <: ReferenceType end
struct Manual <: ReferenceType end
struct MasterThesis <: ReferenceType end
struct Misc <: ReferenceType end
struct PhdThesis <: ReferenceType end
struct Proceedings <: ReferenceType end
struct TechReport <: ReferenceType end
struct Unpublished <: ReferenceType end

"""
    reqfields

Required fields for the different reference types. See Templates heading at
https://www.bibtex.com/format/ (accessed 2020-03-25 at 11:17 AM).
"""
const reqfields = Dict(
    Article() => ["author", "title", "journal", "year"],
    Book() => ["author", "title", "publisher", "year"],
    Booklet() => ["title"],
    Conference() => ["author", "title"],
    InBook() => ["author", "title", "chapter", "publisher", "year"],
    InCollection() => ["author", "title", "booktitle"],
    InProceedings() => ["author", "title"],
    Manual() => ["title"],
    MasterThesis() => ["author", "title", "school", "year"],
    Misc() => String[],
    PhdThesis() => ["author", "title", "school", "year"],
    Proceedings() => ["title", "year"],
    TechReport() => ["author", "title", "institution", "year"],
    Unpublished() => ["author", "title"]
)

"""
    optfields

Optional fields for the different reference types. See Templates heading at
https://www.bibtex.com/format/ (accessed 2020-03-25 at 11:17 AM).
"""
const optfields = Dict(
    Article() => ["month", "volume", "number", "pages", "doi"],
    Book() => ["month", "volume", "number", "series", "address", "edition"],
    Booklet() => ["author", "howpublished", "address", "year", "month"],
    Conference() => ["booktitle", "year", "month", "editor", "volume", "number", "series", "pages", "address", "organization", "publisher", "url"],
    InBook() => ["month", "volume", "number", "series", "type", "address", "edition", "pages"],
    InCollection() => ["publisher", "editor", "year", "month", "volume", "number", "series", "type", "chapter", "pages", "edition", "address"],
    InProceedings() => ["booktitle", "year", "month", "editor", "volume", "number", "series", "pages", "address", "organization", "publisher", "url"],
    Manual() => ["author", "organization", "address", "edition", "year", "month"],
    MasterThesis() => ["month", "type", "address", "url"],
    Misc() => ["author", "title", "year", "month", "howpublished", "url"],
    PhdThesis() => ["month", "type", "address", "url"],
    Proceedings() => ["month", "booktitle", "editor", "volume", "number", "series", "address", "organization", "publisher", "url"],
    TechReport() => ["month", "type", "number", "address"],
    Unpublished() => ["year", "month", "url"]
)

"""
    Reference(type, key, fields, [tags], [note])

Construct a `Reference` object to represent .bib file entries.

# Arguments
- `type::ReferenceType`: Type of reference (e.g., Article, Conference, etc.)
- `key::String`: Citation key
- `fields::Dict{String,String}`: Set of (field, value) pairs (e.g., year = 2019)
- `tags::Vector{Symbol} = Symbol[]`: Set of tags for organizing
- `note::String = ""`: General notes about the reference
"""
struct Reference{T<:ReferenceType}
    key::String
    fields::Dict{String,String}
    tags::Vector{Symbol}
    note::String
end

function Reference(
    type::ReferenceType,
    key::String,
    fields::Dict{String,String},
    tags::Vector{Symbol} = Symbol[],
    note::String = ""
)

    return Reference{typeof(type)}(key, fields, tags, note)

end

function Reference(
    type::ReferenceType,
    key::String,
    fields::Dict{String,String},
    tag::Symbol,
    note::String = ""
)

    return Reference(type, key, fields, [tag], note)

end

function Reference(
    type::ReferenceType,
    key::String,
    fields::Dict{String,String},
    note::String
)

    return Reference(type, key, fields, Symbol[], note)

end

"""
    requiredfields(reference)
    requiredfeilds(referencetype)

Return a list of the required fields of the given reference (type).
"""
requiredfields(reference::Reference{T}) where {T<:ReferenceType} = requiredfields(T())
requiredfields(referencetype::ReferenceType) = reqfields[referencetype]

"""
    optionalfields(reference)
    optionalfeilds(referencetype)

Return a list of the optional fields of the given reference (type).
"""
optionalfields(reference::Reference{T}) where {T<:ReferenceType} = optionalfields(T())
optionalfields(referencetype::ReferenceType) = optfields[referencetype]
