using Pkg
path = @__DIR__
Pkg.activate(path)
using Mitosis
using MitosisStochasticDiffEq
using LinearAlgebra, Statistics, Random, StatsBase
using DelimitedFiles
using StaticArrays
const d = 3
const 𝕏 = SVector{d,Float64}


θ = ([0.1, 0.2, 0.2], [0.1, 0.1, 0.1])
const M = -0.05I + [-1 0.5 0.5 ; 0.5 -1 0.5; 0.5 0.5 -1]

B(θ) = Diagonal(θ[1])*M
Σ(θ) = Diagonal(θ[2])

f(u,θ,t) = Diagonal(θ[1])*M*u
g(u,θ,t) = θ[2]
tstart = 0.0
tend = 50.0
dt = 0.01

u0 = rand(d)
θlin = (B(θ), zero(u0), Σ(θ))
kernel = MitosisStochasticDiffEq.SDEKernel(f,g,tstart,tend,θ,θ,dt=dt)
x, xT = MitosisStochasticDiffEq.sample(kernel, u0; save_noise=true)
xT
#=
lines(Point3f0.(x.u))
lines(first.(x.u))
lines!(getindex.(x.u, 2))
lines!(last.(x.u))
=#
tipslist, header = readdlm(joinpath(path, "lizard_trait.csv"), ','; header=true)
N = size(tipslist,1)


tipsdict = Dict()
for row in eachrow(tipslist)
    push!(tipsdict, row[1] => 𝕏(row[2:end-1]))
end
tipsdict["lucius"]

StatsBase.cov2cor(A) = cov2cor(A, sqrt.(diag(A)))
C = cov(collect(values(tipsdict)))
Rho = cov2cor(Matrix(C))




nwtree = """
((((((((ahli:6.544436481,allogus:6.544436481):5.45394495,rubribarbus:11.99838143):17.38620364,imias:29.38458508):6.398895957,((((sagrei:12.88102021,(bremeri:5.487182621,quadriocellifer:5.487182621):7.39383759):3.075299922,ophiolepis:15.95632013):4.36096088,mestrei:20.31728101):6.490702506,(((jubar:5.943297621,homolechis:5.943297621):4.526135954,confusus:10.46943358):2.107788591,guafe:12.57722217):14.23076135):8.975497514):6.886185624,((((garmani:10.00167905,opalinus:10.00167905):0.9843599411,grahami:10.98603899):10.8904957,valencienni:21.87653468):6.130643032,(lineatopus:23.56855311,reconditus:23.56855311):4.438624604):14.66248894):3.351759762,(((evermanni:10.67601358,stratulus:10.67601358):17.60760293,(((krugi:16.33780327,pulchellus:16.33780327):6.564651854,(gundlachi:19.32330063,poncensis:19.32330063):3.57915449):1.517539033,(cooki:19.7644096,cristatellus:19.7644096):4.655584552):3.863622354):7.477878776,(((brevirostris:13.78711733,(caudalis:8.524873097,marron:8.524873097):5.262244234):1.336374726,websteri:15.12349206):4.917874343,distichus:20.0413664):15.72012888):10.25993114):1.744366152,(((barbouri:40.10542509,(((alumina:13.40538439,semilineatus:13.40538439):10.9683589,olssoni:24.37374329):13.11118303,(etheridgei:29.41536076,(fowleri:18.854692,insolitus:18.854692):10.56066875):8.069565566):2.620498769):3.360194845,((((whitemani:17.10135633,((haetianus:13.34917036,breslini:13.34917036):3.481091738,((armouri:7.419547631,cybotes:7.419547631):2.208359111,shrevei:9.627906742):7.202355359):0.2710942246):5.332800474,(longitibialis:12.60626673,strahmi:12.60626673):9.827890069):4.571501266,marcanoi:27.00565807):12.52637604,((((((baleatus:2.086522712,barahonae:2.086522712):2.631837766,ricordii:4.718360478):10.18010755,eugenegrahami:14.89846803):4.255550995,christophei:19.15401903):4.547667011,cuvieri:23.70168604):5.381927504,(barbatus:7.339713347,(porcus:4.655292118,(chamaeleonides:3.815118093,guamuhaya:3.815118093):0.8401740246):2.68442123):21.74390019):10.44842056):3.933585836):3.798999624,((((((((altitudinalis:8.744497094,oporinus:8.744497094):4.610159031,isolepis:13.35465613):12.69460446,(allisoni:14.8011465,porcatus:14.8011465):11.24811409):1.851745599,(((argillaceus:5.710826139,centralis:5.710826139):1.24881222,pumilis:6.959638359):11.78128137,loysiana:18.74091973):9.160086453):4.261431265,guazuma:32.16243745):2.322058746,((placidus:9.347897895,sheplani:9.347897895):18.86829905,(alayoni:18.96909033,(angusticeps:10.86063481,paternus:10.86063481):8.10845552):9.247106617):6.26829925):3.943522271,((alutaceus:6.04309845,inexpectatus:6.04309845):20.21257905,(((clivicola:16.79799015,(cupeyalensis:4.303151532,cyanopleurus:4.303151532):12.49483861):5.948682113,(alfaroi:14.0116969,macilentus:14.0116969):8.734975363):0.461393415,vanidicus:23.20806568):3.047611821):12.17234097):4.717657381,(argenteolus:32.82165973,lucius:32.82165973):10.32401612):4.118943716):0.5011730105):2.234207429,(((bartschi:26.23626837,vermiculatus:26.23626837):12.4729884,((((baracoae:2.926988768,(noblei:1.070308761,smallwoodi:1.070308761):1.856680007):1.424582119,luteogularis:4.351570887):0.89496035,equestris:5.246531237):31.48597248,(((monticola:30.27768839,(bahorucoensis:19.20550341,(dolichocephalus:7.546354666,hendersoni:7.546354666):11.65914875):11.07218498):1.574600858,darlingtoni:31.85228925):1.644368006,(((aliniger:8.917713736,singularis:8.917713736):6.885287536,chlorocyanus:15.80300127):10.67813301,coelestinus:26.48113428):7.015522978):3.235846465):1.976753045):6.037411928,occultus:44.74666869):5.253331306);
"""
using NewickTree

tree = readnw(nwtree)
ids = map(x->x.id, prewalk(tree))
nams = map(x->x.data.name, prewalk(tree))
n = length(ids)
@assert all(ids .== 1:length(ids))
X = zeros(𝕏, n)

l = getleaves(tree)
lids = map(x->Int(x.id), l)
lnames = map(x->x.data.name, l)
@assert issubset(tipslist[:,1], lnames)

for (id, name) in zip(lids, lnames)
    X[id] = tipsdict[name]
end



Par = zeros(Int, n)
T = zeros(n)
for node in prewalk(tree)
    isroot(node) && continue
    p = node.parent.id
    Par[node.id] = p
    T[node.id] = T[p] + node.data.distance
end
@assert all(Par .< 1:n)
@assert all(T[lids] .≈ 50.0)


ids # Vertex ids
nams # Vertex names
X # vertex values
lids # leaf ids
lnames # leaf names
Par # Parent ids, parents of first node set to 0
T # Times

@assert all(T[Par[ids][2:end]] .< T[ids[2:end]])



dt0 = 0.05
Xd = [zero(𝕏)]
segs = Any[]#Xd[1:0]

for i in eachindex(T)
    local kernel, x, xT, dt
    i == 1 && continue
    i′ = Par[i]
    t = T[i′]
    u = Xd[i′]
    m = round(Int, (T[i]-t)/dt0)
    dt = (T[i] - t)/m
    kernel = MitosisStochasticDiffEq.SDEKernel(f,g,t,T[i],θ,θ,dt=dt)
    x, xT = MitosisStochasticDiffEq.sample(kernel, u; dt = dt, save_noise=true)
    push!(Xd, xT)
#    append!(segs, [u,xT])
    push!(segs, x)
end

#=
using Makie
#linesegments(Point3f0.(segs), markersize=0.05)
scatter(Point3f0.(Xd), markersize=5.0)
for s in segs
    lines!(Point3f0.(s.u))
end

Scene()
for x in segs
    α = rand()
    lines!(x.t, first.(x.u), color=(:red,α))
    lines!(x.t, getindex.(x.u, 2), color=(:blue,α))
    lines!(x.t, last.(x.u), color=(:yellow,α))
end

=#

Xd = [i in lids ? WGaussian{(:μ,:Σ,:c)}(Vector(X[i]), 0.1Matrix(I(3)), 0.0) : missing for i in eachindex(X)]
i = 199
for i in reverse(eachindex(T))
    println(i)
    local kernel, x, xT, dt
    i == 1 && continue
    i′ = Par[i]
    v = Xd[i]
    VT = NamedTuple{(:logscale, :μ, :Σ)}((v.c, v.μ, v.Σ))
    m = round(Int, (T[i]-T[i′])/dt0)
    dt = (T[i] - T[i′])/m
    kernel = MitosisStochasticDiffEq.SDEKernel(f,g,T[i′],T[i],θ,θlin,dt=dt)
    message, u = MitosisStochasticDiffEq.backwardfilter(kernel, VT)
    u = WGaussian{(:μ,:Σ,:c)}(u.x[1], u.x[2], u.x[3][])
    if ismissing(Xd[i′])
        Xd[i′] = u
    else
        Xd[i′] = fuse(u, Xd[i′]; unfused=false)[2]
    end
end

using Makie
pts = map(x -> ismissing(x) ? missing : Point3f0(mean(x)), Xd)

#scatter(collect(skipmissing(pts)))
scatter((x->asinh.(x)).(pts), markersize=100log.(norm.(cov.(Xd))))
