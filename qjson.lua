local NULL = {}

local find, sub, tonumber, error = string.find, string.sub, tonumber, error
local function decode(json --[[@param json string]]) ---@return any
	local ptr = 1

	local function consume(pattern --[[@param pattern string]]) ---@return string?
		local _, finish, match = find(json, pattern, ptr)
		if finish then
			ptr = finish + 1
			return match or true
		end
	end

	local function slowstring() -- string parser that supports escapes.
		local start = ptr + 1 -- skip initial quote
		ptr = start

		while true do
			local start, finish = find(json, "\\*\"", ptr)
			if finish then
				ptr = finish + 1
				if (finish - start) % 2 == 0 then
					return sub(json, start, finish - 1) -- return (gsub(sub(json, start, finish - 1), "\\([bfnrt\\\"])", ESCAPES))
				end
			else
				error("Missing end quote for string at char " .. ptr)
			end
		end
	end


	local function number()
		return tonumber(consume("^(-?%d*.?%d+[eE]?[+-]?%d*)"))
	end

	local value
	local function whitespace()
		ptr = find(json, "%S", ptr) or ptr -- skip past whitespace, return immediate value
		return value()
	end

	local function string()
		local start = ptr + 1
		local quot = find(json, '"', start, true)
		local prev = quot - 1
		if sub(json, prev, prev) ~= "\\" then
			ptr = quot + 1
			return sub(json, start, prev)
		else
			return slowstring()
		end
	end

	local peek = {
		["\""] = string,
		["t"] = function()
			if sub(json, ptr, ptr + 3) == "true" then
				ptr = ptr + 4
				return true
			end
		end,
		["f"] = function()
			if sub(json, ptr, ptr + 4) == "false" then
				ptr = ptr + 5
				return false
			end
		end,
		["n"] = function()
			if sub(json, ptr, ptr + 3) == "null" then
				ptr = ptr + 4
				return NULL
			end
		end,

		["0"] = number, ["1"] = number, ["2"] = number,
		["3"] = number, ["4"] = number, ["5"] = number,
		["6"] = number, ["7"] = number, ["8"] = number,
		["9"] = number, ["-"] = number,

		["{"] = function()
			ptr = ptr + 1

			local fields = {}
			if consume("^%s*}") then return fields end

			repeat
				ptr = find(json, "%S", ptr) or ptr -- skip whitespace inline
				local key = string()
				if not key then
					error("Expected field for object at char " .. ptr)
				end

				if not consume("^%s*:") then
					error("Expected : to follow key for object at char " .. ptr)
				end

				local val = value()
				if val ~= nil then
					fields[key] = val
				else
					error("Expected value for field " .. key .. " at char " .. ptr)
				end

				consume("^%s*,")
			until consume("^%s*}")

			return fields
		end,

		["["] = function()
			ptr = ptr + 1 -- Already know we're at the [ from value()

			local values, nvalues = {}, 0
			if consume("^%s*%]") then return values end

			repeat
				nvalues = nvalues + 1
				local value = value()
				if value ~= nil then
					values[nvalues] = value
				else
					error("Expected value for field #" .. nvalues + 1 .. " at char " .. ptr)
				end
				consume("^%s*,")
			until consume("^%s*%]")

			return values
		end,

		[" "] = whitespace, ["\t"] = whitespace, ["\n"] = whitespace, ["\r"] = whitespace,
	}

	function value()
		local p = peek[sub(json, ptr, ptr)]
		if p then
			return p()
		else
			error("Failed parsing at character " .. ptr)
		end
	end

	return value()
end

local concat, tostring, format, pairs, type = table.concat, tostring, string.format, pairs, type

local function isarray(t)
	local len = #t

	for k in pairs(t) do
		if len == 0 or type(k) ~= "number" then
			return false
		else
			len = len - 1
		end
	end

	return true
end

local encode
local function value(v)
	local t = type(v)
	if t == "table" then
		return encode(v)
	elseif t == "string" then
		return format("%q", v)
	else
		return tostring(v)
	end
end

function encode(tbl --[[@param tbl table]]) ---@return string
	if isarray(tbl) then
		local strs, len = {}, #tbl
		for i = 1, len do
			strs[i] = value(tbl[i])
		end
		return "[" .. concat(strs, ",", 1, len) .. "]"
	else
		local kvs, nkvs = {}, 0
		for k, v in pairs(tbl) do
			nkvs = nkvs + 1
			kvs[nkvs] = "\"" .. tostring(k) .. "\"" .. ":" .. value(v)
		end
		return "{" .. concat(kvs, ",", 1, nkvs) .. "}";
	end
end

return {
	NULL = NULL,
	encode = encode,
	decode = decode
}