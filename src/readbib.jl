"""
    BibExtensionError(file)

Error to throw when a given file does not have a .bib extension.
"""
struct BibExtensionError <: Exception
    file::String
end

function Base.showerror(io::IO, err::BibExtensionError)

    print(io, "BibExtensionError: the provided file ", err.file)
    ext = splitext(err.file)[2]
    if isempty(ext)
        print(io, " has no extension,")
    else
        print(io, " has a ", ext, " extension,")
    end
    print(io, " but should have a .bib extension")

end

"""
    BadBibEntryError(entry, [entry_from_regex])

Error to throw when a bib entry in incorrectly formatted.
"""
struct BadBibEntryError{T<:Union{Nothing,<:AbstractString}} <: Exception
    entry::String
    entry_from_regex::T

    BadBibEntryError(e::AbstractString) = new{Nothing}(e, nothing)
    BadBibEntryError(e::AbstractString, efr::AbstractString) =
        new{typeof(efr)}(e, efr)
end

function Base.showerror(io::IO, err::BadBibEntryError{T}) where {T<:Union{Nothing,<:AbstractString}}

    print(io, "BadBibEntryError: incorrectly formatted bib entry:\n", err.entry)
    T === Nothing || print(io, "the following was parsed:\n", err.entry_from_regex)

end

"""
    refs = readbib(file)

Create a list of `Reference`s from the given .bib file.
"""
function readbib(file::AbstractString)

    # Make sure the file is indeed a .bib file
    splitext(file)[2] == ".bib" || throw(BibExtensionError(file))

    # Read in the file
    filecontents = read(file, String)

    # Iterate over each bib entry and add it to the list of references
    # To explain the regex:
    #   @ is matched literally (beginning of bib entry)
    #   [a-zA-Z]* matches 0 or more letters (to match the entry type)
    #   { is matched literally (beginning of entry fields)
    #   [^@]* matches 0 or more of anything but @ (contents of entry)
    #   } is mathced literally (end of entry)
    #   \s* matches 0 or more whitespace charaters
    # Note: This regex assumes that there are no @ characters in the body
    #       of the bib entries
    # https://regex101.com/ is a really nice resource for figuring out regexes
    regex_entry = r"@[a-zA-Z]*{[^@]*}\s*"
    refs = Reference[]
    for entry in eachmatch(regex_entry, filecontents)
        push!(refs, readbibentry(entry.match))
    end

    # Display a warning if there is extraneous information in the file
    # The following filters out all of the matches (empty strings returned
    # by split), leaving just the stuff that didn't match
    extra = [ex for ex in split(filecontents, regex_entry) if !isempty(ex)]
    isempty(extra) || @warn("some file contents were ignored:\n$(prod(extra))")

    return refs

end

"""
    ref = readbibentry(entry)

Create a `Reference` object from a single BibTeX entry represented as a String.
"""
function readbibentry(entry::AbstractString)

    # Find out the entry type and citation key
    # Regex explanation:
    #   @ is matched literally
    #   ([a-zA-Z]*) captures 0 or more letters
    #   { is matched literally
    #   \s* matches 0 or more whitespace characters
    #   ((?:(?!,)\S)*) captures 0 or more non-whitespace characters that are
    #       not commas; the ?: makes the ((?!,)\S) group non-capturing
    #   , is matched literally
    # After the regex, the first captured group should be the entry type, and
    # the second captured group should be the citation key
    regex_type_citekey = r"@([a-zA-Z]*){\s*((?:(?!,)\S)*)\s*,"
    m_type_citekey = match(regex_type_citekey, entry)
    # Throw an error if there is no match
    isnothing(m_type_citekey) && throw(BadBibEntryError(entry))
    type = referencetype(m_type_citekey.captures[1])
    citekey = m_type_citekey.captures[2]
    entry_from_regex = m_type_citekey.match # Used to make sure entry is good

    # Find all field = value pairs
    # Regex explanation:
    #   \s* matches 0 or more whitespace characters
    #   (\S*) captures 0 or more non-whitespace characters
    #   = is matched literally
    #   { is matched literally
    #   (.*) captures 0 or more characters
    #   } is matched literally
    #   , is matched literally
    #   ,? matches 0 or 1 commas
    # For a correct bib entry, the last field doesn't need a comma following
    # the value, but it does need to preceed a }
    # Other fields might match regex_field_last, so only use the last match
    regex_field = r"\s*(\S*)\s*=\s*{(.*)}\s*,"
    regex_field_last = r"\s*(\S*)\s*=\s*{(.*)}\s*,?\s*}\s*"
    m_field = collect(eachmatch(regex_field, entry))
    m_field_last = collect(eachmatch(regex_field_last, entry))[end]
    # The last field might match both regexes, so ignore the last match of
    # regex_field if it is contained in regex_field_last
    if occursin(m_field[end].match, m_field_last.match)
        m_field_all = [m_field[1:end-1]; m_field_last]
    else
        m_field_all = [m_field; m_field_last]
    end
    fields = Dict{String,String}()
    for m in m_field_all
        (key, value) = String.(m.captures)
        fields[key] = value
        entry_from_regex *= m.match
    end

    # Make sure the bib entry was good by making sure everything in the entry
    # was matched by a regex
    entry == entry_from_regex || throw(BadBibEntryError(entry, entry_from_regex))

    # Create the Reference object
    ref = Reference(type, citekey, fields)

    # Display a warning if an empty citation key was found
    isempty(citekey) && @warn("empty citation key", ref)

    # Make sure all required fields are present
    hasrequired(ref) || throw(MissingFieldError(ref))

    return ref

end
