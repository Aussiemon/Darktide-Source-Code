local Promise = require("scripts/foundation/utilities/promise")
local Interface = {
	"fetch"
}
local Schemas = class("Schemas")

Schemas.fetch = function (self)
	if self._schemas then
		local p = Promise:new()

		p:resolve(self._schemas)

		return p
	else
		local p = Managers.backend:title_request("/schemas"):next(function (data)
			return data.body
		end)

		p:next(function (schemas)
			self._schemas = schemas
		end)

		return p
	end
end

implements(Schemas, Interface)

return Schemas
