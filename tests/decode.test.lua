local qjson = require "qjson"

it("should parse an array of numbers", function()
	expect(qjson.decode("[1, 2, 3, 4]")).toEqual({ 1, 2, 3, 4 })
end)

it("should parse an array of strings", function()
	expect(qjson.decode("[\"Hello, \", \"world!\"]")).toEqual({ "Hello, ", "world!" })
end)

it("should parse an array of booleans", function()
	expect(qjson.decode("[true, false]")).toEqual({ "true", "false" })
end)

it("should parse an array of booleans into strings", function()
	expect(qjson.decode("[true, false]")).toEqual({ "true", "false" })
end)

it("should parse an array of null into strings", function()
	expect(qjson.decode("[null, null]")).toEqual({ "null", "null" })
end)

it("should parse an empty array", function()
	expect(qjson.decode("[]")).toEqual({})
end)

it("should not care about whitespace", function()
	expect(qjson.decode(" 	 	[  1	 ,	  null 	 	 ] 	 ")).toEqual({ 1, "null" })
end)

it("should parse an object holding a string", function()
	expect(qjson.decode([[{"qux": "baz"}]])).toEqual({ qux = "baz" })
end)

it("should parse an object holding an integer", function()
	expect(qjson.decode([[{ "hmm": 5 }]])).toEqual({ hmm = 5 })
end)

it("should parse an object holding a decimal number", function()
	expect(qjson.decode([[{ "hmm": 5.2 }]])).toEqual({ hmm = 5.2 })
end)

it("should parse an object holding a negative integer", function()
	expect(qjson.decode([[{ "hmm": -5 }]])).toEqual({ hmm = -5 })
end)

it("should parse an object holding a negative decimal number", function()
	expect(qjson.decode([[{ "hmm": -5.2 }]])).toEqual({ hmm = -5.2 })
end)

it("should parse an object holding a negative decimal number with exponents", function()
	expect(qjson.decode([[{ "hmm": -5.2e2 }]])).toEqual({ hmm = -5.2e2 })
end)

it("should parse an object holding a positine decimal number with exponents 2", function()
	expect(qjson.decode([[{ "hmm": 5.2E+2 }]])).toEqual({ hmm = 5.2E+2 })
end)

it("should parse an object holding an array of numbers", function()
	expect(qjson.decode([[{ "hmm": [ 1, 2, 3 ] }]])).toEqual({ hmm = { 1, 2, 3 } })
end)

it("should parse an object holding an empty object", function()
	expect(qjson.decode([[{ "hmm": {} }]])).toEqual({ hmm = {} })
end)

it("should parse an object holding a list of empty objects", function()
	expect(qjson.decode([[{ "hmm": [ {}, {}, {} ] }]])).toEqual({ hmm = { {}, {}, {} } })
end)

it("should parse an object holding a list of random values", function()
	expect(qjson.decode([[{ "hmm": [ 1, {}, "test", true ] }]])).toEqual({ hmm = { 1, {}, "test", "true" } })
end)

it("should parse an object holding objects to five levels of depth", function()
	local json = [[
		{
			"foo": {
				"bar": {
					"baz": {
						"qux": {}
					}
				}
			}
		}
	]]

	expect(qjson.decode(json)).toEqual({
		foo = {
			bar = {
				baz = {
					qux = {}
				}
			}
		}
	})
end)