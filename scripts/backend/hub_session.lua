-- chunkname: @scripts/backend/hub_session.lua

local Interface = {
	"fetch_server_details",
	"update",
}
local HubSession = class("HubSession")

HubSession.fetch_server_details = function (self, session_id)
	return Managers.backend:title_request("/hub/sessions/" .. session_id .. "/serverdetails"):next(function (data)
		return data.body
	end)
end

HubSession.update = function (self, session_id, jwt_sign_key_id, connection_info, fleet_id, time_at_utilized, deployment_id, participants, status, sorted_set_key)
	local data = {
		status = status,
		jwtSignKeyId = jwt_sign_key_id,
		connectionInfo = connection_info,
		fleetId = fleet_id,
		timeAtUtilized = time_at_utilized,
		deploymentId = deployment_id,
		connectedParticipants = participants,
		sortedSetKey = sorted_set_key,
	}

	return Managers.backend:title_request("/hub/sessions/" .. session_id .. "/update", {
		method = "POST",
		body = data,
	}):next(function (data)
		return data.body
	end)
end

HubSession.get_hub_config = function (self)
	return Managers.backend:title_request("/hub/config"):next(function (data)
		return data.body
	end)
end

implements(HubSession, Interface)

return HubSession
