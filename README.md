
# map tiles from gigascatter

## How to start this

Start the back-end (it will sit in a terminal):
```
julia serve.jl
```

Run the front-end:
```sh
npm install
npm start
```

Backend is listening on `localhost:8080`, frontend should spawn on something
like `localhost:1234` depending on current `npm` mood. navigate there to get
the zoomable map.

## TODO

- some space partitioning (going through 1M points everytime sucks)
- determine how big the points should be
- perhaps Pluto integration?
