-- chunkname: @scripts/utilities/luajit.lua

local has_ffi, ffi = pcall(require, "ffi")
local has_jutil, jutil = pcall(require, "jit.util")

if not IS_WINDOWS or not has_ffi or not has_jutil then
	return false
end

local C = ffi.C
local bit, debug, math, string = bit, debug, math, string
local pairs, tonumber, type = pairs, tonumber, type
local LuaJIT = {}

ffi.cdef("int QueryPerformanceFrequency(long long*);\nint QueryPerformanceCounter(long long*);\n")

local freq = ffi.new("long long[1]")
local cnt = ffi.new("long long[1]")

C.QueryPerformanceFrequency(freq)

LuaJIT.jutil = function ()
	return jutil
end

LuaJIT.clock = function ()
	C.QueryPerformanceCounter(cnt)

	return freq[0] * cnt[0]
end

LuaJIT.clock_diff = function (b, a)
	return tonumber(b - a)
end

local function toptr(kind, v)
	local addr = string.match(string.format("%p", v), "0x(%x+)")

	return ffi.cast(kind, tonumber(addr, 16))
end

local _dummy = {}

LuaJIT.tvalue = function (v)
	_dummy[0] = v

	local ptr = toptr("uint32_t*", _dummy)
	local array = ffi.cast("int64_t*", ptr[2])

	return array[0]
end

local itypename = {
	[0] = "nil",
	"false",
	"true",
	"lightud",
	"str",
	"upval",
	"thread",
	"proto",
	"func",
	"trace",
	"cdata",
	"tab",
	"udata",
	"numx",
}

LuaJIT.itype = function (o)
	local i64 = LuaJIT.tvalue(o)
	local it = tonumber(bit.arshift(i64, 32))
	local tag = bit.bnot(it)

	if it % 4294967296 <= 4294901759 then
		tag = 13
	elseif bit.arshift(it, 15) == -2 then
		tag = 3
	end

	return itypename[tag], tag
end

LuaJIT.table_size = function (t)
	local ptr = toptr("uint32_t*", t)

	return ptr[6], ptr[7]
end

local function sizeof(lut, o, to)
	to = to or type(o)

	if to == "nil" or to == "boolean" or to == "number" then
		return 0
	elseif lut then
		if lut[o] then
			return lut[o]
		end

		lut[o] = 0
	end

	if to == "string" then
		if o == "" then
			return 0
		end

		return 17 + #o
	elseif to == "table" then
		local a, h = LuaJIT.table_size(o)
		local b = 32 + 8 * a + 24 * h

		if lut then
			for tk, tv in pairs(o) do
				b = b + sizeof(lut, tk) + sizeof(lut, tv)
			end
		end

		return b
	elseif to == "function" then
		local info = jutil.funcinfo(o)
		local uvs = info.upvalues
		local b = 0

		if info.addr then
			b = 28 + 8 * math.max(1, uvs)
		else
			b = 20 + 4 * math.max(1, uvs)
		end

		if lut then
			b = b + sizeof(lut, info.proto)

			local ptr = toptr("uint32_t*", o)

			for i = 1, uvs do
				local gcref32 = ptr[5 + i]
				local _, v = debug.getupvalue(o, i)

				b = b + 24 + sizeof(lut, gcref32, "upval") + sizeof(lut, v)
			end
		end

		return b
	elseif to == "proto" then
		local ptr = toptr("uint32_t*", o)
		local b = ptr[8]

		if lut then
			local info = jutil.funcinfo(o)

			for i = -info.gcconsts, -1 do
				local k = jutil.funck(o, i)

				b = b + sizeof(lut, k)
			end
		end

		return b
	elseif to == "upval" then
		return 24
	elseif to == "userdata" then
		local it = LuaJIT.itype(o)

		if it == "lightud" then
			return 0
		end

		local ptr = toptr("uint32_t*", o)

		return 16 + ptr[-3]
	elseif to == "cdata" then
		return 8
	elseif to == "thread" then
		return 60
	elseif to == "trace" then
		error("NYI: trace")
	end

	error("Unknown type: " .. to)
end

LuaJIT.bytes = function (object, exclusive)
	return sizeof(not exclusive and {}, object)
end

LuaJIT.bytes_ex = function (object, lut)
	return sizeof(lut, object)
end

return LuaJIT
