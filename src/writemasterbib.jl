"""
    MissingFieldError(reference)

Error to throw when a reference does not specify all required fields.
"""
struct MissingFieldError <: Exception
    ref::Reference
end

function Base.showerror(io::IO, err::MissingFieldError)

    print(io, "MissingFieldError: reference is missing required fields\n")
    print(io, err.ref)
    print(io, "required fields are ", requiredfields(err.ref))

end

"""
    writemasterbib(refs, path)

Create master.bib from the given references at the given path.
"""
function writemasterbib(refs::AbstractVector{<:Reference}, path::AbstractString)

    # Make sure all references have the required fields
    for r in refs
        hasrequired(r) || throw(MissingFieldError(r))
    end

    # Sort the references
    refs = sort(refs)

    open(joinpath(path, "master.bib"), "w") do file
        for r in refs
            print(file, r, "\n")
        end
    end

end
