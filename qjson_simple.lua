local function decode(json --[[@param json string]]) ---@return table
	local ptr = 0
	local function consume(pattern --[[@param pattern string]]) ---@return string?
		local start, finish = json:find("^%s+", ptr)
		if start then ptr = finish + 1 end

		local start, finish, match = json:find(pattern, ptr)
		if start then
			ptr = finish + 1
			return match or true
		end
	end

	local table, list
	local function number() return tonumber(consume("^(%d+%.%d+)") or consume("^(%d+)")) end
	local function bool() return consume("^(true)") or consume("^(false)") end
	local function string() return consume("^\"([^\"]*)\"") end
	local function value() return number() or bool() or string() or table() or list() end

	function table()
		if consume("^{") then
			local fields = {}
			if consume("^}") then return fields end

			repeat
				local key = assert(string(), "Expected field for table")
				assert(consume("^:"))
				fields[key] = assert(value(), "Expected value for field " .. key)
				consume("^,")
			until consume("^}")

			return fields
		end
	end

	function list()
		if consume("^%[") then
			local values = {}
			if consume("^%]") then return values end

			repeat
				values[#values + 1] = assert(value(), "Expected value for field #" .. #values + 1)
				consume("^,")
			until consume("^%]")

			return values
		end
	end

	return table()
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
			kvs[nkvs] = tostring(k) .. ":" .. value(v)
		end
		return "{" .. concat(kvs, ",", 1, nkvs) .. "}";
	end
end

return {
	encode = encode,
	decode = decode
}