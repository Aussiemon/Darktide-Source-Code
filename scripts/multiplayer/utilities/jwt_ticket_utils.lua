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

JwtTicketUtils.verify_jwt_ticket = function (jwt_ticket, public_key)
	assert(public_key, "public_key is not set")

	local is_valid = false

	if public_key == "none" then
		Log.info("JwtTicketUtils", "ticket is valid since public_key is set to 'none'")

		is_valid = true
	else
		is_valid = JWT.verify(jwt_ticket, public_key)
	end

	if is_valid then
		local header, payload = JwtTicketUtils.decode_jwt_ticket(jwt_ticket)

		return is_valid, header, payload
	else
		return false
	end
end

JwtTicketUtils.create_matchmaking_jwt_ticket = function (backend_mission_data)
	local missionJson = nil

	if backend_mission_data then
		missionJson = cjson.encode(backend_mission_data)
	end

	local payload = {
		instanceId = "NO_INSTANCE_ID",
		sessionId = "NO_SESSION_ID",
		exp = 4109491289.0,
		iat = 4109491289.0,
		sessionSettings = {
			missionJson = missionJson
		}
	}
	payload = cjson.encode(payload)
	payload = string.encode_base64(payload)
	local jwt_ticket = string.format("empty-header.%s.empty-signature", payload)

	return jwt_ticket
end

JwtTicketUtils.join_jwt_ticket_array = function (jwt_ticket_array)
	local str = ""

	for i = 1, #jwt_ticket_array, 1 do
		local part = jwt_ticket_array[i]
		str = str .. part
	end

	return str
end

return JwtTicketUtils
