local NvidiaAIAgent = class("NvidiaAIAgent")

NvidiaAIAgent.init = function (self)
	Log.info("NvidiaAIAgent", "Nvidia AI Agent initialized")
end

NvidiaAIAgent.destroy = function (self)
	Log.info("NvidiaAIAgent", "Nvidia AI Agent destroyed")
end

local function _agent_data(camera_data, health_data)
	local camera_position = camera_data.position
	local camera_rotation = camera_data.rotation
	local current_health = (health_data and health_data.current_health) or 0
	local agent_data = {
		camera = {
			position = {
				x = camera_position.x,
				y = camera_position.y,
				z = camera_position.z
			},
			rotation = {
				pitch = Quaternion.pitch(camera_rotation),
				roll = Quaternion.roll(camera_rotation),
				yaw = Quaternion.yaw(camera_rotation)
			}
		},
		health = current_health
	}

	return agent_data
end

local function _camera_data(player_viewport)
	local camera_manager = Managers.state.camera
	local camera_position = camera_manager:camera_position(player_viewport)
	local camera_rotation = camera_manager:camera_rotation(player_viewport)
	local camera_data = {
		position = camera_position,
		rotation = camera_rotation
	}

	return camera_data
end

local function _health_data(player_unit)
	if not player_unit then
		return
	end

	local health_extension = ScriptUnit.has_extension(player_unit, "health_system")

	if not health_extension then
		return
	end

	local current_health = health_extension:current_health()
	local health_data = {
		current_health = current_health
	}

	return health_data
end

local function _player()
	local player_manager = Managers.player
	local local_player = player_manager:local_player(1)

	return local_player
end

local function _send_agent_data(agent_data)
	local data_as_json = cjson.encode(agent_data)

	Renderer.data_marker(data_as_json)
end

NvidiaAIAgent.update = function (self, dt, t)
	local player = _player()

	if not player then
		Log.warning("NvidiaAIAgent", "No player(s)")

		return
	end

	local camera_data = _camera_data(player.viewport_name)
	local health_data = _health_data(player.player_unit)
	local agent_data = _agent_data(camera_data, health_data)

	_send_agent_data(agent_data)
end

return NvidiaAIAgent
