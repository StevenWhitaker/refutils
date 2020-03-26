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
    # https://regex101.com/ is a really nice resource for figuring out regexes
    refs = Reference[]
    for entry in eachmatch(r"@[a-zA-Z]*{[^@]*}", filecontents)
        push!(refs, readbibentry(entry.match))
    end

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
    m = match(r"@([a-zA-Z]*){\s*((?:(?!,)\S)*)\s*,", entry)
    type = referencetype(m.captures[1])
    key = m.captures[2]

    # Find all field = value pairs
    # Regex explanation:
    #   \s* matches 0 or more whitespace characters
    #   (\S*) captures 0 or more non-whitespace characters
    #   = is matched literally
    #   { is matched literally
    #   (.*) captures 0 or more characters
    #   } is matched literally
    # Note: Given, e.g., "{Steven {T.} Whitaker}", I'm not sure why this regex
    #       matches "Steven {T.} Whitaker" and not just "Steven {T."
    fields = Dict{String,String}()
    for m in eachmatch(r"\s*(\S*)\s*=\s*{(.*)}\s*", entry)
        (key, value) = String.(m.captures)
        fields[key] = value
    end

    # Create the Reference object
    ref = Reference(type, key, fields)

    # Make sure all required fields are present
    hasrequired(ref) || throw(MissingFieldError(ref))

    return ref

end
