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
LuaJIT 2.1.0-beta3 (Windows 11)
11th Gen Intel(R) Core(TM) i7-11800H @ 2.30GHz
```

| Name (Decode)        | Min        | Max        | Avg        | Avg / Best  |
| ---                  | ---        | ---        | ---        | ---         |
| actboy168/json       | 0          | 0.025      | 0.013235   | x2.0456     |
| vurv78/qjson         | 0          | 0.023      | 0.00881    | x1.36167    |
| rxi/json             | 0          | 0.022      | 0.00704    | x1.0881     |
| luadist/dkjson       | 0.004      | 0.026      | 0.01519    | x2.34776    |
| grafi-tt/lunajson    | 0          | 0.018      | 0.00647    | x1          |

| Name (Encode)        | Min        | Max        | Avg        | Avg / Best  |
| ---                  | ---        | ---        | ---        | ---         |
| actboy168/json       | 0          | 0.023      | 0.01057    | x6.84142    |
| vurv78/qjson         | 0.001      | 0.003      | 0.001545   | x1          |
| rxi/json             | 0          | 0.024      | 0.010825   | x7.00647    |
| luadist/dkjson       | 0.013      | 0.019      | 0.01588    | x10.2783    |
| grafi-tt/lunajson    | 0          | 0.02       | 0.00907    | x5.87055    |

```
Lua 5.3 (WSL : Windows 11)
11th Gen Intel(R) Core(TM) i7-11800H @ 2.30GHz
```

| Name (Decode)        | Min        | Max        | Avg        | Avg / Best  |
| ---                  | ---        | ---        | ---        | ---         |
| actboy168/json       | 0.018951   | 0.024308   | 0.0201813  | x1.63619    |
| vurv78/qjson         | 0.01469    | 0.018899   | 0.0153881  | x1.24758    |
| rxi/json             | 0.045162   | 0.05497    | 0.0473737  | x3.84079    |
| luadist/dkjson       | 0.028868   | 0.041998   | 0.0318926  | x2.58567    |
| grafi-tt/lunajson    | 0.011779   | 0.015871   | 0.0123344  | x1          |

| Name (Encode)        | Min        | Max        | Avg        | Avg / Best  |
| ---                  | ---        | ---        | ---        | ---         |
| actboy168/json       | 0.016695   | 0.020211   | 0.0175769  | x3.02879    |
| vurv78/qjson         | 0.005439   | 0.006851   | 0.00580326 | x1          |
| rxi/json             | 0.016098   | 0.024696   | 0.0173684  | x2.99287    |
| luadist/dkjson       | 0.022419   | 0.026535   | 0.0233218  | x4.01874    |
| grafi-tt/lunajson    | 0.011502   | 0.014437   | 0.0121709  | x2.09725    |

From here, you can see this library is fastest at encoding.

Decoding is getting there. Currently balancing performance between PUC-Lua and Luajit.