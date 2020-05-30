module ExchangeSimulator

import Pages
using Pages: Endpoint, HTTP, GET, start

function __init__()
    
    for ex in ["nasdaq", "nyse", "lse", "forex"]
        @eval ExchangeSimulator begin
            $(Symbol(ex)) = read(joinpath(@__DIR__,"..","deps","data","$($ex).json"),String)
            Endpoint("/api/$($ex)/list", GET) do request::HTTP.Request
                $(Symbol(ex))
            end
        end
    end

end

end # module
