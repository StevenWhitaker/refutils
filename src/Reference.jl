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
    Reference(type, fields, [tags], [note])

Construct a `Reference` object to represent .bib file entries.

# Arguments
- `type::ReferenceType`: Type of reference (e.g., Article, Conference, etc.)
- `fields::Dict{String,String}`: Set of (field, value) pairs (e.g., year = 2019)
- `tags::Vector{Symbol} = Symbol[]`: Set of tags for organizing
- `note::String = ""`: General notes about the reference
"""
struct Reference{T<:ReferenceType}
    fields::Dict{String,String}
    tags::Vector{Symbol}
    note::String
end

function Reference(
    type::ReferenceType,
    fields::Dict{String,String},
    tags::Vector{Symbol} = Symbol[],
    note::String = ""
)

    return Reference{typeof(type)}(fields, tags, note)

end

function Reference(
    type::ReferenceType,
    fields::Dict{String,String},
    tag::Symbol,
    note::String = ""
)

    return Reference(type, fields, [tag], note)

end

function Reference(
    type::ReferenceType,
    fields::Dict{String,String},
    note::String
)

    return Reference(type, fields, String[], note)

end
