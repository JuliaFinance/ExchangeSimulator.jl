using DelimitedFiles, Tables, JSON3

function genfile(name)
    infile = joinpath(@__DIR__,"data","$(uppercase(name)).txt")
    outfile = joinpath(@__DIR__,"data","$(lowercase(name)).json")

    data = Tables.table(readdlm(infile,'\t','\n',header=true)[1])
    rows = Dict[]
    for stock in Tables.rows(data)
        typeof(stock[1]) !== SubString{String} && continue
        typeof(stock[2]) !== SubString{String} && continue
        row = Dict("Symbol" => stock[1], "Description" => stock[2])
        push!(rows, row)
    end
    open(outfile, "w") do io
        print(io,JSON3.write(rows))
    end
end

@show "NASDAQ"
genfile("NASDAQ")

@show "NYSE"
genfile("NYSE")

@show "LSE"
genfile("LSE")

@show "FOREX"
genfile("FOREX")
