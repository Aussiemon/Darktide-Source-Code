local JwtTicketUtils = {}

local function parse_jwt_payload(payload_json)
	local payload = cjson.decode(payload_json)
	local missionJson = payload.sessionSettings.missionJson

	if missionJson then
		payload.sessionSettings.missionJson = cjson.decode(missionJson)
	end

	return payload
end

JwtTicketUtils.decode_jwt_ticket = function (jwt_ticket)
	local parts = string.split(jwt_ticket, ".")
	local header_base64 = parts[1]
	local header_json = string.decode_base64(header_base64)
	local header = cjson.decode(header_json)
	local payload_json = string.decode_base64(parts[2])
	local payload = parse_jwt_payload(payload_json)

	return header, payload
end

JwtTicketUtils.join_jwt_ticket_array = function (jwt_ticket_array)
	local str = ""

	for i = 1, #jwt_ticket_array do
		local part = jwt_ticket_array[i]
		str = str .. part
	end

	return str
end

return JwtTicketUtils
