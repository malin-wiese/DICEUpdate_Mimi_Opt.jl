CI = get(ENV, "CI", nothing) == "true" || get(ENV, "GITHUB_TOKEN", nothing) !== nothing
using DrWatson, Documenter
@quickactivate "OptMimiDICE2016R2"

# Here you may include files from the source directory
include(srcdir("OptMimiDICE2016R2.jl"))
include(srcdir("optimise.jl"))
include(srcdir("marginaldamage.jl"))
# include(srcdir("OptMimiDICE2016R2_copy.jl"))

@info "Building Documentation"
makedocs(;
    sitename = "OptMimiDICE2016R2",
    # This argument is only so that the sequence of pages in the sidebar is configured
    # By default all markdown files in `docs/src` are expanded and included.
    pages = [
        "index.md",
    ],
    # Don't worry about what `CI` does in this line.
    format = Documenter.HTML(prettyurls = CI),
)

@info "Deploying Documentation"
if CI
    deploydocs(
        # `repo` MUST be set correctly
        repo = "https://github.com/felixschaumann/OptMimiDICE2016R2.git",
        target = "build",
        push_preview = true,
        devbranch = "main",
    )
end

@info "Finished with Documentation"
