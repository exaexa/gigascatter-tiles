
using GigaScatter

x = rand(1000000)
points = Matrix([x .* sin.(x .* 100)  x .* cos.(x .* 100)]') + 0.005 .* randn(2,1000000)
colors = expressionColors((1 .+ sin.(x.*123))./2, expressionPalette(256, alpha=.1))

x0,y0=(minimum(points[1,:]), minimum(points[2,:]))
s0 = max(maximum(points[1,:])-x0, maximum(points[1,:])-y0)

function tileRaster(z::Int,x::Int,y::Int)
    ts = s0 / 2^z
    ex = ts/16
    x1 = x0 + x * ts
    y1 = y0 + y * ts
    solidBackground(
        rasterKernelCircle(sqrt(z),
            rasterize((288, 288),
                points,
                colors,
                xlim=(x1 - ex, x1 + ts + ex),
                ylim=(y1 - ex, y1 + ts + ex))))[:,17:272,17:272]
end

using HTTP
using Images
using FileIO

HTTP.listen("127.0.0.1", 8080, reuseaddr=true, verbose=true) do http
    @info http.message.target
    m = match(r"^/([0-9]+)/([0-9]+)/([0-9]+)\.png$",http.message.target)
    if m == nothing
        HTTP.setstatus(http, 404)
        startwrite(http)
        write(http, "tile out of range\n")
    else
        zxy = broadcast(parse, Int, m.captures)
        HTTP.setstatus(http, 200)
        HTTP.setheader(http, "Content-type" => "image/png")
        startwrite(http)
        Images.save(FileIO.Stream(FileIO.format"PNG", http),
                    Images.colorview(Images.RGB, tileRaster(zxy...)))
    end
end
