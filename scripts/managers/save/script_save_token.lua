local TokenInterface = require("scripts/foundation/managers/token/token_interface")
local ScriptSaveToken = class("ScriptSaveToken")

ScriptSaveToken.init = function (self, save_implementation, save_implementation_token)
	self._implementation = save_implementation
	self._token = save_implementation_token
	self._info = {}
end

ScriptSaveToken.update = function (self)
	self._info = self._implementation.progress(self._token)
end

ScriptSaveToken.info = function (self)
	return self._info
end

ScriptSaveToken.done = function (self)
	return self._info.done
end

ScriptSaveToken.close = function (self)
	self._implementation.close(self._token)
end

implements(ScriptSaveToken, TokenInterface)

return ScriptSaveToken
