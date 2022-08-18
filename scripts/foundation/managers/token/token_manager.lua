local TokenInterface = require("scripts/foundation/managers/token/token_interface")
local TokenManager = class("TokenManager")

TokenManager.init = function (self)
	self._tokens = {}
	self._is_updating_tokens = false
end

TokenManager.register_token = function (self, token, callback, timeout)
	assert_interface(token, TokenInterface)

	self._tokens[#self._tokens + 1] = {
		time = 0,
		token = token,
		callback = callback,
		timeout = timeout or math.huge
	}
end

TokenManager.abort = function (self, token)
	fassert(not self._is_updating_tokens, "Can't abort tokens from token update since removing tokens would trash the loop.")

	local tokens = self._tokens

	for index, entry in ipairs(tokens) do
		if entry.token == token then
			token:close()
			table.swap_delete(tokens, index)

			return
		end
	end

	ferror("Invalid token. contents:\n%s", table.tostring(token))
end

TokenManager.update = function (self, dt, t)
	local tokens = self._tokens
	self._is_updating_tokens = true

	for index = #tokens, 1, -1 do
		local entry = tokens[index]
		local token = entry.token
		entry.time = entry.time + dt

		token:update()

		if token:done() or entry.timeout <= entry.time then
			local callback = entry.callback

			if callback then
				local info = token:info()

				callback(info)
			end

			token:close()
			table.swap_delete(tokens, index)
		end
	end

	self._is_updating_tokens = false
end

TokenManager.destroy = function (self)
	for id, entry in ripairs(self._tokens) do
		local token = entry.token

		token:close()

		self._tokens[id] = nil
	end
end

return TokenManager
