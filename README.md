<img src="qjson.svg" height=150px/>

Tiny, quick JSON encoding/decoding in pure Lua.

# [![Release Shield](https://img.shields.io/github/v/release/Vurv78/qjson.lua?include_prereleases)](https://github.com/Vurv78/qjson.lua/releases/latest) [![License](https://img.shields.io/github/license/Vurv78/qjson.lua?color=red)](https://opensource.org/licenses/MIT) [![Linter Badge](https://github.com/Vurv78/qjson.lua/workflows/Run%20Lest/badge.svg)](https://github.com/Vurv78/qjson.lua/actions) [![github/Vurv78](https://img.shields.io/discord/824727565948157963?label=Discord&logo=discord&logoColor=ffffff&labelColor=7289DA&color=2c2f33)](https://discord.gg/yXKMt2XUXm)

## Features
* Pure lua, should work on every version (5.1-5.4, JIT)
* Quick, focused on performance. (See benchmarks below)
* Actually tiny, ~150 sloc.
* Decent error handling: `Expected : to follow key for object at char 39`

## Usage
```lua
local json = require "qjson"
print(json.encode {
	hello = "world!",
	qjson = { "fast", "simple", "tiny" }
})

--[[
	{"qjson":["fast","simple","tiny"],"hello":"world!"}
]]

print(json.decode([[
	{ "foo": "bar" }
]]))
```

## Notes
* `null` is output as a special table instance, retrieved from `qjson.NULL`
* This does not guarantee 100% compatibility with the more niche parts of the JSON spec (like unicode escapes)

## Benchmarks
Using benchmarks/bench.lua:

```
LuaJIT 2.1.0-beta3
11th Gen Intel(R) Core(TM) i7-11800H @ 2.30GHz

Running benchmarks...
| Name (Decode)   | Min        | Max        | Avg        | Avg / Best  |
| vurv78/qjson    | 0.0091     | 0.012012   | 0.00968749 | x1.75539    |
| rxi/json        | 0.004745   | 0.006889   | 0.0055187  | x1          |
| actboy168/json  | 0.010586   | 0.012723   | 0.0113411  | x2.05503    |
| luadist/dkjson  | 0.011112   | 0.016785   | 0.0134858  | x2.44366    |

| Name (Encode)   | Min        | Max        | Avg        | Avg / Best  |
| vurv78/qjson    | 0.003788   | 0.004491   | 0.004021   | x1          |
| rxi/json        | 0.0104     | 0.014977   | 0.0108013  | x2.68623    |
| actboy168/json  | 0.010361   | 0.012899   | 0.0110817  | x2.75596    |
| luadist/dkjson  | 0.014438   | 0.017056   | 0.0153153  | x3.80883    |
```

```
Lua 5.3
11th Gen Intel(R) Core(TM) i7-11800H @ 2.30GHz

Running benchmarks...
| Name (Decode)   | Min        | Max        | Avg        | Avg / Best  |
| vurv78/qjson    | 0.015195   | 0.018472   | 0.0159068  | x1          |
| rxi/json        | 0.045206   | 0.052624   | 0.048079   | x3.02255    |
| actboy168/json  | 0.019059   | 0.022751   | 0.0200545  | x1.26075    |
| luadist/dkjson  | 0.028623   | 0.034445   | 0.0307014  | x1.93009    |

| Name (Encode)   | Min        | Max        | Avg        | Avg / Best  |
| vurv78/qjson    | 0.006012   | 0.017234   | 0.00760202 | x1          |
| rxi/json        | 0.015458   | 0.019752   | 0.0170518  | x2.24306    |
| actboy168/json  | 0.015981   | 0.021264   | 0.0169299  | x2.22703    |
| luadist/dkjson  | 0.02172    | 0.025274   | 0.0229826  | x3.02323    |
```

From here, you can see this library is significantly faster on regular lua, and a bit slower than rxi/json on LuaJIT.

Currently working on making it faster for LuaJIT, but this is pretty hard to fix considering making it faster would require not using as many [lua patterns](https://www.lua.org/pil/20.2.html), which would slow down PUC-Lua.