
---@alias BenchResult { min: number, max: number, avg: number }
local function bench(times, fn) ---@return BenchResult
	collectgarbage() -- Clear gc before running

	for _ = 1, 5 do -- Warm up
		fn()
	end

	local results --[=[@type number[]]=] = {}
	for i = 1, times do
		local start = os.clock()
		fn()
		results[i] = os.clock() - start
	end

	local min, max, avg = math.huge, -math.huge, 0
	for _, time in ipairs(results) do
		if time < min then
			min = time
		elseif time > max then
			max = time
		end

		avg = avg + time
	end

	return {
		min = min, max = max, avg = avg / times
	}
end

local function get(url)
	local handle = assert(io.popen("curl -s " .. url))
	local content = handle:read("*a")
	handle:close()
	return content
end

local loadstring = loadstring or load

print("Downloading required files...")

local LIBS --[[@type table<string, table>]] = {
	["vurv78/qjson"] = require "qjson",
	["rxi/json"] = loadstring(get("https://raw.githubusercontent.com/rxi/json.lua/master/json.lua"))(),
	["actboy168/json"] = loadstring(get("https://raw.githubusercontent.com/actboy168/json.lua/master/json.lua"))(),
	["luadist/dkjson"] = loadstring(get("https://raw.githubusercontent.com/LuaDist/dkjson/master/dkjson.lua"))(),
	["grafi-tt/lunajson"] = {
		encode = loadstring(get("https://raw.githubusercontent.com/grafi-tt/lunajson/master/src/lunajson/encoder.lua"))()(),
		decode = loadstring(get("https://raw.githubusercontent.com/grafi-tt/lunajson/master/src/lunajson/decoder.lua"))()()
	}
}

local DECODE_TARGET = get("https://raw.githubusercontent.com/simdjson/simdjson/master/jsonexamples/twitter.json")
local ENCODE_TARGET = require("qjson").decode(DECODE_TARGET)

local util = require "benchmarks.util"

print( util.version )
print( util.cpu )

print("Running benchmarks... ")

do
	local total --[=[@type table<string, BenchResult>]=] = {}
	for name, lib in pairs(LIBS) do
		local decode = lib.decode
		total[name] = bench(200, function()
			decode(DECODE_TARGET)
		end)
	end

	local best = math.huge
	for _, result in pairs(total) do
		if result.avg < best then
			best = result.avg
		end
	end

	print( ("| %-20s | %-10s | %-10s | %-10s | %-11s |"):format("Name (Decode)", "Min", "Max", "Avg", "Avg / Best") )
	print( ("| %-20s | %-10s | %-10s | %-10s | %-11s |"):format("---", "---", "---", "---", "---") )
	for name, result in pairs(total) do
		print( ("| %-20s | %-10g | %-10g | %-10g | x%-10g |"):format(name, result.min, result.max, result.avg, result.avg / best) )
	end
end

print()

do
	local total --[=[@type table<string, BenchResult>]=] = {}
	for name, lib in pairs(LIBS) do
		local encode = lib.encode
		total[name] = bench(200, function()
			encode(ENCODE_TARGET)
		end)
	end

	local best = math.huge
	for _, result in pairs(total) do
		if result.avg < best then
			best = result.avg
		end
	end

	print( ("| %-20s | %-10s | %-10s | %-10s | %-11s |"):format("Name (Encode)", "Min", "Max", "Avg", "Avg / Best") )
	print( ("| %-20s | %-10s | %-10s | %-10s | %-11s |"):format("---", "---", "---", "---", "---") )
	for name, result in pairs(total) do
		print( ("| %-20s | %-10g | %-10g | %-10g | x%-10g |"):format(name, result.min, result.max, result.avg, result.avg / best) )
	end
end