local qjson = require "qjson"

test("readme encoding should work", function()
	local encoded = qjson.encode({ hello = "world!", qjson = { "fast", "simple", "tiny" } })

	-- Todo: Better approach for this.
	local equality =
		encoded == [[{"qjson":["fast","simple","tiny"],"hello":"world!"}]] or
		encoded == [[{"hello":"world!","qjson":["fast","simple","tiny"]}]]

	expect(equality).toBeTruthy()
end)

test("readme decoding should work", function()
	local decoded = qjson.decode([[
		{ "foo":"bar" }
	]])

	expect(decoded).toEqual({ foo = "bar" })
end)