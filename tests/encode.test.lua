local qjson = require "qjson"

it("should encode an empty table as an array", function()
	expect(qjson.encode({})).toBe("[]")
end)

it("should encode a sequential table as an array", function()
	expect(qjson.encode({1, 2, 3})).toBe("[1,2,3]")
end)

it("should encode a list of booleans", function()
	expect(qjson.encode({true, false, false})).toBe("[true,false,false]")
end)

it("should encode a list of strings", function()
	expect(qjson.encode({"Hello", "world!"})).toBe('["Hello","world!"]')
end)

it("should encode a list of strings with escapes", function()
	expect(qjson.encode({"Hello", "world\"!"})).toBe('["Hello","world\\"!"]')
end)

it("should encode a lookup table", function()
	local encoded = qjson.encode({ foo = "bar", [1] = "qux" })

	-- Todo: Better approach for this.
	local equality =
		encoded == [[{"foo": "bar","1": "qux"}]] or
		encoded == [[{"1": "qux","foo": "bar"}]]

	expect(equality).toBeTruthy()
end)