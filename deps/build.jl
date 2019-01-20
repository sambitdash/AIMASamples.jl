#Download aima-data
using LibGit2
using Pkg

println("Downloading AIMACore from GitHub")
Pkg.clone("https://github.com/sambitdash/AIMACore.jl")

!isdir("downloads") && mkdir("downloads")
cd("downloads")

println("Downloading aima-data from GitHub")
if !isdir("aima-data")
    repo_path = joinpath("aima-data")
    repo_url  = "https://github.com/aimacode/aima-data.git"
    LibGit2.clone(repo_url, repo_path)
else
    repo = LibGit2.GitRepo("aima-data")
    LibGit2.fetch(repo)
end
println("aima-data - downloaded")
