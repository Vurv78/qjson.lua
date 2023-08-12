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
| rxi/json             | 0.005      | 0.009      | 0.00672    | x1          |
| actboy168/json       | 0.011      | 0.016      | 0.01295    | x1.92708    |
| luadist/dkjson       | 0.012      | 0.017      | 0.01426    | x2.12202    |
| vurv78/qjson         | 0.008      | 0.015      | 0.00939    | x1.39732    |
| grafi-tt/lunajson    | 0.005      | 0.012      | 0.007095   | x1.0558     |

| Name (Encode)        | Min        | Max        | Avg        | Avg / Best  |
| ---                  | ---        | ---        | ---        | ---         |
| rxi/json             | 0.01       | 0.02       | 0.011745   | x7.93581    |
| actboy168/json       | 0.009      | 0.014      | 0.01077    | x7.27703    |
| luadist/dkjson       | 0.015      | 0.018      | 0.01559    | x10.5338    |
| vurv78/qjson         | 0.001      | 0.003      | 0.00148    | x1          |
| grafi-tt/lunajson    | 0.007      | 0.01       | 0.008645   | x5.84122    |

```
Lua 5.3 (WSL : Windows 11)
11th Gen Intel(R) Core(TM) i7-11800H @ 2.30GHz
```

| Name (Decode)        | Min        | Max        | Avg        | Avg / Best  |
| ---                  | ---        | ---        | ---        | ---         |
| actboy168/json       | 0.019036   | 0.024134   | 0.0204356  | x1.63325    |
| rxi/json             | 0.045677   | 0.059829   | 0.0487656  | x3.89742    |
| vurv78/qjson         | 0.01478    | 0.02029    | 0.0160733  | x1.28461    |
| luadist/dkjson       | 0.028986   | 0.038415   | 0.0314367  | x2.51247    |
| grafi-tt/lunajson    | 0.01162    | 0.015419   | 0.0125123  | x1          |

| Name (Encode)        | Min        | Max        | Avg        | Avg / Best  |
| ---                  | ---        | ---        | ---        | ---         |
| actboy168/json       | 0.016462   | 0.019902   | 0.0176806  | x3.0031     |
| rxi/json             | 0.016091   | 0.020716   | 0.0182224  | x3.09512    |
| vurv78/qjson         | 0.005352   | 0.008078   | 0.00588746 | x1          |
| luadist/dkjson       | 0.022643   | 0.04247    | 0.0249368  | x4.23559    |
| grafi-tt/lunajson    | 0.011779   | 0.014569   | 0.0128647  | x2.1851     |

From here, you can see this library is fastest at encoding, running 8-10x faster than the most commonly used libraries.

Decoding is getting there. Currently balancing performance between PUC-Lua and Luajit.