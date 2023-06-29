local find, sub, gsub, tonumber, error = string.find, string.sub, string.gsub, tonumber, error
local function decode(json --[[@param json string]]) ---@return table
	local ptr = 0
	local function consume(pattern --[[@param pattern string]]) ---@return string?
		local _, finish, match = find(json, pattern, ptr)
		if finish then
			ptr = finish + 1
			return match or true
		end
		return nil
	end

	local repl = { -- escape characters
		["b"] = "\b", ["f"] = "\f", ["n"] = "\n", ["r"] = "\r",
		["t"] = "\t", ["\\"] = "\\", ["\""] = "\""
	}

	local function slowstring() -- string parser that works with escapes. fallback at very far end of parsing order, since rare case.
		local _, start = find(json, "^%s*\"", ptr)
		if not start then return end
		ptr = start + 1

		while true do
			local _, finish, escapes = find(json, "(\\*)\"", ptr)
			if finish then
				ptr = finish + 1
				if #escapes % 2 == 0 then
					return ( gsub( sub(json, start + 1, finish - 1), "\\([bfnrt\\\"])", repl) )
				end
			else
				error("Missing end quote for string at char " .. ptr)
			end
		end
	end

	local object, array
	local function faststring() -- Parses a string without any escapes. Fastest and most common case.
		return consume("^%s*\"([^\"\\]*)\"")
	end

	--- Parses a JSON value.
	--- Order is important for performance with common cases.
	local function value()
		return faststring()
			or object()
			or tonumber(consume("^%s*(%-?%d+%.?%d*[eE][%+%-]?%d+)") or consume("^%s*(%-?%d+%.?%d*)"))
			or consume("^%s*(true)") or consume("^%s*(false)") or consume("^%s*(null)")
			or array()
			or slowstring()
	end

	function object()
		if consume("^%s*{") then
			local fields = {}
			if consume("^%s*}") then return fields end

			repeat
				local key = faststring()
				if not key then
					error("Expected field for object at char " .. ptr)
				end

				if not consume("^%s*:") then
					error("Expected : to follow key for object at char " .. ptr)
				end

				local val = value()
				if val then
					fields[key] = val
				else
					error("Expected value for field " .. key .. " at char " .. ptr)
				end

				consume("^%s*,")
			until consume("^%s*}")

			return fields
		end
	end

	function array()
		if consume("^%s*%[") then
			local values, nvalues = {}, 0
			if consume("^%s*%]") then return values end

			repeat
				nvalues = nvalues + 1
				local value = value()
				if value then
					values[nvalues] = value
				else
					error("Expected value for field #" .. nvalues + 1 .. " at char " .. ptr)
				end
				consume("^%s*,")
			until consume("^%s*%]")

			return values
		end
	end

	return object() or array()
end

local concat, tostring, format, pairs = table.concat, tostring, string.format, pairs
local function isarray(t)
	local i = 1
	for k in pairs(t) do
		if type(k) ~= "number" or k ~= i then
			return false
		end
		i = i + 1
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
			kvs[nkvs] = "\"" .. tostring(k) .. "\"" .. ": " .. value(v)
		end
		return "{" .. concat(kvs, ",", 1, nkvs) .. "}";
	end
end

return {
	encode = encode,
	decode = decode
}