local Interface = {
	"fetch_connection_info"
}
local Immaterium = class("Immaterium")

Immaterium.fetch_connection_info = function (self)
	return Managers.backend:title_request("/immaterium/connectioninfo", {
		method = "GET"
	}):next(function (data)
		return data.body
	end)
end

implements(Immaterium, Interface)

return Immaterium
