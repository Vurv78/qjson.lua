local os = package.config:sub(1, 1) == "\\" and "Windows" or "Unix"
local cpu

if os == "Windows" then
	local handle, err = io.popen("wmic cpu get name /VALUE")
	assert(handle, err)
	cpu = handle:read("*a"):match("Name=([^\n]+)")
	handle:close()
else
	local handle, err = io.popen([[lscpu | sed -nr '/Model name/ s/.*:\s*(.* @ .*)/\1/p']])
	assert(handle, err)
	cpu = handle:read("*a")
	handle:close()
end

return {
	os = os,
	version = jit and jit.version or _VERSION,
	cpu = cpu
}