module ExchangeSimulator

import Pages
using Pages: Endpoint, HTTP, JSON3, start

function __init__()
    
    for ex in ["nasdaq", "nyse", "lse", "forex"]
        @eval ExchangeSimulator begin
            $(Symbol("_",ex)) = read(joinpath(@__DIR__,"..","deps","data","$($ex).json"),String)
            $(Symbol(uppercase(ex))) = JSON3.read($(Symbol("_",ex)))

            Endpoint("/api/$($ex)") do request::HTTP.Request
                params = HTTP.queryparams(HTTP.URI(request.target).query)
                if haskey(params,"symbols")
                    symbols = Symbol.(split(params["symbols"],","))
                    response = Dict{Symbol,String}()
                    for symbol in symbols
                        response[symbol] = $(Symbol(uppercase(ex)))[symbol]
                    end
                    return JSON3.write(response)
                else
                    return $(Symbol("_",ex))
                end
            end

        end
    end

end

end # module
