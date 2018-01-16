#Download aima-data
using Base.LibGit2

!isdir("downloads") && mkdir("downloads")
cd("downloads")

println("Downloading aima-data from github")
if !isdir("aima-data")
    repo_path = joinpath("aima-data")
    repo_url  = "https://github.com/aimacode/aima-data.git"
    LibGit2.clone(repo_url, repo_path)
else
    repo = LibGit2.GitRepo("aima-data")
    LibGit2.fetch(repo)
end
println("aima-data - downloaded")
