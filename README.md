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
| Name (Decode)        | Min        | Max        | Avg        | Avg / Best  |
| vurv78/qjson         | 0.008706   | 0.011876   | 0.00915391 | x1.71064    |
| actboy168/json       | 0.010476   | 0.013891   | 0.0113075  | x2.11309    |
| luadist/dkjson       | 0.011261   | 0.016459   | 0.0126863  | x2.37076    |
| rxi/json             | 0.004783   | 0.007264   | 0.00535117 | x1          |
| grafi-tt/lunajson    | 0.005398   | 0.007717   | 0.00583864 | x1.0911     |

| Name (Encode)        | Min        | Max        | Avg        | Avg / Best  |
| vurv78/qjson         | 0.00166    | 0.004003   | 0.00189934 | x1          |
| actboy168/json       | 0.010009   | 0.012101   | 0.0107158  | x5.64188    |
| luadist/dkjson       | 0.014416   | 0.017742   | 0.0152628  | x8.03585    |
| rxi/json             | 0.010861   | 0.013424   | 0.0114725  | x6.04024    |
| grafi-tt/lunajson    | 0.007869   | 0.010028   | 0.00877393 | x4.61946    |
```

```
Lua 5.3
11th Gen Intel(R) Core(TM) i7-11800H @ 2.30GHz

Running benchmarks...
| Name (Decode)        | Min        | Max        | Avg        | Avg / Best  |
| actboy168/json       | 0.019026   | 0.023047   | 0.0202998  | x1.58917    |
| rxi/json             | 0.045717   | 0.05649    | 0.048758   | x3.81701    |
| luadist/dkjson       | 0.02851    | 0.038804   | 0.0317486  | x2.48544    |
| vurv78/qjson         | 0.014956   | 0.019906   | 0.0165542  | x1.29595    |
| grafi-tt/lunajson    | 0.011663   | 0.015941   | 0.0127739  | x1          |

| Name (Encode)        | Min        | Max        | Avg        | Avg / Best  |
| actboy168/json       | 0.016101   | 0.029937   | 0.0171029  | x3.06483    |
| rxi/json             | 0.015395   | 0.019102   | 0.0168397  | x3.01765    |
| luadist/dkjson       | 0.02162    | 0.025159   | 0.0226016  | x4.05019    |
| vurv78/qjson         | 0.005168   | 0.0067     | 0.00558039 | x1          |
| grafi-tt/lunajson    | 0.011286   | 0.016953   | 0.0124624  | x2.23325    |
```

From here, you can see this library is significantly faster for `json.encode` in comparison to `json.decode`.
Additionally `decode` is faster on PUC-Lua than LuaJIT.

Currently working on making it faster for LuaJIT, but this is pretty hard to fix considering making it faster would require not using as many [lua patterns](https://www.lua.org/pil/20.2.html), which would slow down PUC-Lua.