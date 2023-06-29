# `qjson.lua`

Tiny and Rapid JSON encoding/decoding in pure Lua.

(Running benchmark by [`rxi/json.lua`](https://github.com/rxi/json.lua))
```
Lua version   : LuaJIT 2.1.0-beta3
CPU name      : 11th Gen Intel(R) Core(TM) i7-11800H @ 2.30GHz
../json.lua   : 0.00494s [x7.06e+03] (min: 0.00452s, max 0.00526s)
dkjson.lua    : 0.0121s [x1.73e+04] (min: 0.0118s, max 0.0123s)
jfjson.lua    : 0.00993s [x1.42e+04] (min: 0.00954s, max 0.0103s)
qjson_simple.lua  : 4.3e-06s [x6.14] (min: 0s, max 1.6e-05s)
qjson.lua : 7e-07s [x1] (min: 0s, max 1e-06s)
```

## Features
* Pure lua, should work on every version (5.1-5.4, JIT)
* Incredibly fast: ~10000x faster than rxi/json at decoding.
* Actually tiny, < 150 loc.
* Decent error handling: `Expected : to follow key for object at char 39`

## Usage
```lua
local json = require "qjson"
print(json.encode {
	hello = "world!",
	qjson = { "fast", "simple", "tiny" }
})

--[[
	{"qjson": ["fast","simple","tiny"],"hello": "world!"}
]]

print(json.decode([[
	{ "foo": "bar" }
]]))
```

## Notes
* `true`, `false` and `null` are represented as strings.

## qjson_simple

Smaller initial version of `qjson` without all of the optimizations that make it less readable.

Often runs worse than `qjson`, but can run at around the same speed.

Doesn't support escaping strings, exponential numbers, or `null`.