local WARN_MISSING_CATCH = false
local queue = {}
local State = {
	REJECTED = "rejected",
	FULFILLED = "fulfilled",
	PENDING = "pending"
}

local function passthrough(x)
	return x
end

local function errorthrough(x)
	error(x)
end

local function callable_table(callback)
	local mt = getmetatable(callback)

	return type(mt) == "table" and type(mt.__call) == "function"
end

local function is_callable(value)
	local t = type(value)

	return t == "function" or t == "table" and callable_table(value)
end

local transition, resolve, run = nil
local Promise = class("Promise")

local function do_async(callback)
	if Promise.async then
		Promise.async(callback)
	else
		table.insert(queue, callback)
	end
end

local function cancel(promise)
	promise.queue = {}
end

local function reject(promise, reason)
	transition(promise, State.REJECTED, reason)
end

local function fulfill(promise, value)
	transition(promise, State.FULFILLED, value)
end

function transition(promise, state, value)
	if promise.state == state or promise.state ~= State.PENDING or state ~= State.FULFILLED and state ~= State.REJECTED then
		return
	end

	promise.state = state
	promise.value = value

	run(promise)
end

Promise.next = function (self, on_fulfilled, on_rejected)
	local promise = Promise.new()

	table.insert(self.queue, {
		fulfill = is_callable(on_fulfilled) and on_fulfilled or nil,
		reject = is_callable(on_rejected) and on_rejected or nil,
		promise = promise,
		debug_traceback_info_1 = debug.getinfo(2, "Sl"),
		debug_traceback_info_2 = debug.getinfo(3, "Sl")
	})
	run(self)

	return promise
end

function resolve(promise, x)
	if promise == x then
		reject(promise, "TypeError: cannot resolve a promise with itself")

		return
	end

	local x_type = type(x)

	if x_type ~= "table" then
		fulfill(promise, x)

		return
	end

	if rawget(x, "is_promise") then
		if x.state == State.PENDING then
			x:next(function (value)
				resolve(promise, value)
			end, function (reason)
				reject(promise, reason)
			end)

			return
		end

		transition(promise, x.state, x.value)

		return
	end

	local called = false
	local success, reason = xpcall(function ()
		local next = rawget(x, "next")

		if is_callable(next) then
			next(x, function (y)
				if not called then
					resolve(promise, y)

					called = true
				end
			end, function (r)
				if not called then
					reject(promise, r)

					called = true
				end
			end)
		else
			fulfill(promise, x)
		end
	end, function (err)
		if not type(err) ~= "table" then
			err = {
				fatal = true,
				message = err
			}
		end

		err.__traceback = "<<Promise Stack>>" .. debug.traceback("Error in promise resolve", 2) .. "<</Promise Stack>><<Promise Context>>" .. extract_stored_traceback(obj) .. "<</Promise Context>>"
		err.__locals = extract_locals(4)

		return err
	end)

	if not success then
		if reason.fatal then
			assert(false, "<<Promise Error>>" .. tostring(reason.message) .. "<</Promise Error>>\n" .. reason.__traceback .. "<<Promise Locals>>" .. reason.__locals .. "<</Promise Locals>>")
		end

		if not called then
			reject(promise, reason)
		end
	end
end

local function extract_locals(level_base)
	local level = level_base
	local res = ""

	while debug.getinfo(level) ~= nil do
		res = string.format("%s\n[%i] ", res, level - level_base + 1)
		local v = 1

		while true do
			local name, value = debug.getlocal(level, v)

			if not name then
				break
			end

			local var = string.format("%s = %s; ", name, tostring(value))
			res = res .. var
			v = v + 1
		end

		level = level + 1
	end

	return res
end

local function extract_stored_traceback(obj)
	local short_traceback = string.format("%s:%d\n%s:%d", obj.debug_traceback_info_1 and obj.debug_traceback_info_1.source or "", obj.debug_traceback_info_1 and obj.debug_traceback_info_1.currentline or -1, obj.debug_traceback_info_2 and obj.debug_traceback_info_2.source or "", obj.debug_traceback_info_2 and obj.debug_traceback_info_2.currentline or -1)

	return short_traceback
end

function run(promise)
	if promise.state == State.PENDING then
		return
	end

	do_async(function ()
		local q = promise.queue
		local i = 0

		while i < #q do
			i = i + 1
			local obj = q[i]
			local success, result = xpcall(function ()
				local success = obj.fulfill or passthrough
				local failure = obj.reject or errorthrough
				local callback = promise.state == State.FULFILLED and success or failure

				return callback(promise.value)
			end, function (err)
				if type(err) ~= "table" then
					err = {
						fatal = true,
						message = err
					}
				end

				err.__traceback = "<<Promise Stack>>" .. debug.traceback("Error in promise resolve", 2) .. "<</Promise Stack>><<Promise Context>>" .. extract_stored_traceback(obj) .. "<</Promise Context>>"
				err.__locals = extract_locals(4)

				return err
			end)

			if not success then
				if result.fatal then
					assert(false, "<<Promise Error>>" .. tostring(result.message) .. "<</Promise Error>>\n" .. result.__traceback .. "<<Promise Locals>>" .. result.__locals .. "<</Promise Locals>>")
				end

				reject(obj.promise, result)
			else
				resolve(obj.promise, result)
			end
		end

		if #q == 0 and promise.state == State.REJECTED then
			local string_value = nil

			if type(promise.value) == "table" then
				string_value = table.tostring(promise.value, 3)
			else
				string_value = tostring(promise.value)
			end

			if WARN_MISSING_CATCH then
				Log.warning("Promise", "No top level catch for error: %s", string_value)
			end
		end

		for j = 1, i do
			q[j] = nil
		end
	end)
end

Promise.init = function (self, callback)
	self.is_promise = true
	self.state = State.PENDING
	self.queue = {}

	if callback then
		callback(function (value)
			resolve(self, value)
		end, function (reason)
			reject(self, reason)
		end)
	end
end

Promise.catch = function (self, callback)
	return self:next(nil, callback)
end

Promise.resolve = function (self, value)
	fulfill(self, value)
end

Promise.reject = function (self, reason)
	reject(self, reason)
end

Promise.cancel = function (self)
	cancel(self)
end

Promise.is_rejected = function (self)
	return self.state == State.REJECTED
end

Promise.is_fulfilled = function (self)
	return self.state == State.FULFILLED
end

Promise.is_pending = function (self)
	return self.state == State.PENDING
end

Promise.update = function (dt, t)
	Promise._check_predicate()
	Promise._check_delayed(t)

	while true do
		local async = table.remove(queue, 1)

		if not async then
			break
		end

		async()
	end
end

Promise.all = function (...)
	local promises = {
		...
	}
	local results = {}
	local state = State.FULFILLED
	local remaining = #promises
	local promise = Promise.new()

	local function check_finished()
		if remaining > 0 then
			return
		end

		transition(promise, state, results)
	end

	for i = 1, #promises do
		promises[i]:next(function (value)
			results[i] = value
			remaining = remaining - 1

			check_finished()
		end, function (value)
			results[i] = value
			remaining = remaining - 1
			state = State.REJECTED

			check_finished()
		end)
	end

	check_finished()

	return promise
end

Promise.race = function (...)
	local promises = {
		...
	}
	local promise = Promise.new()

	Promise.all(...):next(nil, function (value)
		reject(promise, value)
	end)

	local function success(value)
		fulfill(promise, value)
	end

	for i = 1, #promises do
		promises[i]:next(success)
	end

	return promise
end

local delayed = {}
local latest_time = 0

Promise._check_delayed = function (t)
	latest_time = t

	for i = #delayed, 1, -1 do
		local p = delayed[i]

		if p.time < latest_time then
			p.promise:resolve(nil)
			table.remove(delayed, i)
		end
	end
end

local predicates = {}

Promise._check_predicate = function ()
	for i = #predicates, 1, -1 do
		local p = predicates[i]
		local r = p.result
		r[1], r[2] = p.predicate()

		if r[1] or r[2] then
			if r[1] then
				p.promise:resolve(r[1])
			else
				p.promise:reject(r[2])
			end

			table.remove(predicates, i)
		end
	end
end

Promise.resolved = function (value)
	local promise = Promise:new()

	promise:resolve(value)

	return promise
end

Promise.rejected = function (value)
	local promise = Promise:new()

	promise:reject(value)

	return promise
end

Promise.delay = function (delta)
	fassert(delta >= 0, "Can't delay for less than 0 seconds")

	local promise = Promise:new()

	table.insert(delayed, {
		promise = promise,
		time = latest_time + delta
	})

	return promise
end

Promise.until_true = function (predicate)
	fassert(predicate ~= nil, "Predicate cannot be nil")

	return Promise.delay(0):next(function ()
		if predicate() then
			return nil
		else
			return Promise.until_true(predicate)
		end
	end)
end

Promise.until_value_is_true = function (predicate)
	fassert(predicate ~= nil, "Predicate cannot be nil")

	local promise = Promise:new()

	table.insert(predicates, {
		promise = promise,
		predicate = predicate,
		result = {}
	})

	return promise
end

return Promise
