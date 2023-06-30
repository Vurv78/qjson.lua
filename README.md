<img src="qjson.svg" height=150px/>

Tiny, quick JSON encoding/decoding in pure Lua.

# [![Release Shield](https://img.shields.io/github/v/release/Vurv78/qjson.lua?include_prereleases)](https://github.com/Vurv78/qjson.lua/releases/latest) [![License](https://img.shields.io/github/license/Vurv78/qjson.lua?color=red)](https://opensource.org/licenses/MIT) [![Linter Badge](https://github.com/Vurv78/qjson.lua/workflows/Run%20Lest/badge.svg)](https://github.com/Vurv78/qjson.lua/actions) [![github/Vurv78](https://img.shields.io/discord/824727565948157963?label=Discord&logo=discord&logoColor=ffffff&labelColor=7289DA&color=2c2f33)](https://discord.gg/yXKMt2XUXm)

## Features
* Pure lua, should work on every version (5.1-5.4, JIT)
* Quick, focused on performance. (See benchmarks below)
* Very small, ~180 sloc.
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
Using benchmarks/bench.lua [(which tests the simdjson twitter example)](https://raw.githubusercontent.com/simdjson/simdjson/master/jsonexamples/twitter.json) through WSL:

```
LuaJIT 2.1.0-beta3
11th Gen Intel(R) Core(TM) i7-11800H @ 2.30GHz

Running benchmarks...
| Name (Decode)   | Min        | Max        | Avg        | Avg / Best  |
| vurv78/qjson    | 0.008763   | 0.010837   | 0.00939495 | x1.72715    |
| rxi/json        | 0.00475    | 0.007055   | 0.00543957 | x1          |
| actboy168/json  | 0.010547   | 0.013259   | 0.0112183  | x2.06235    |
| luadist/dkjson  | 0.011222   | 0.014534   | 0.0126976  | x2.3343     |

| Name (Encode)   | Min        | Max        | Avg        | Avg / Best  |
| vurv78/qjson    | 0.001677   | 0.002637   | 0.00189174 | x1          |
| rxi/json        | 0.010513   | 0.011322   | 0.010924   | x5.77459    |
| actboy168/json  | 0.009892   | 0.012293   | 0.0104864  | x5.54327    |
| luadist/dkjson  | 0.014829   | 0.01985    | 0.0157059  | x8.30237    |
```

```
Lua 5.3
11th Gen Intel(R) Core(TM) i7-11800H @ 2.30GHz

Running benchmarks...
| Name (Decode)   | Min        | Max        | Avg        | Avg / Best  |
| luadist/dkjson  | 0.028568   | 0.033705   | 0.0306484  | x1.94652    |
| rxi/json        | 0.045178   | 0.053548   | 0.0480421  | x3.05121    |
| vurv78/qjson    | 0.015006   | 0.018043   | 0.0157452  | x1          |
| actboy168/json  | 0.019061   | 0.023373   | 0.0200551  | x1.27372    |

| Name (Encode)   | Min        | Max        | Avg        | Avg / Best  |
| luadist/dkjson  | 0.021639   | 0.024754   | 0.0226422  | x4.10556    |
| rxi/json        | 0.015463   | 0.019618   | 0.0166444  | x3.01802    |
| vurv78/qjson    | 0.005148   | 0.006336   | 0.00551502 | x1          |
| actboy168/json  | 0.016263   | 0.018331   | 0.0170535  | x3.09218    |
```

From here, you can see this library is significantly faster for `json.encode` in comparison to `json.decode`.
Additionally `decode` is faster on PUC-Lua than LuaJIT.

Currently working on making it faster for LuaJIT, but this is pretty hard to fix considering making it faster would require not using as many [lua patterns](https://www.lua.org/pil/20.2.html), which would slow down PUC-Lua.