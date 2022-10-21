local NvidiaAIAgent = class("NvidiaAIAgent")

NvidiaAIAgent.init = function (self)
	Log.info("NvidiaAIAgent", "Nvidia AI Agent initialized")

	self._player = Managers.player:local_player(1)

	if not self._player then
		Log.warning("NvidiaAIAgent", "No player(s)")

		return
	end

	self._agent_data = {
		health = 0,
		camera = {
			position = {
				z = 0,
				x = 0,
				y = 0
			},
			rotation = {
				roll = 0,
				pitch = 0,
				yaw = 0
			}
		}
	}
end

NvidiaAIAgent.destroy = function (self)
	Log.info("NvidiaAIAgent", "Nvidia AI Agent destroyed")
end

NvidiaAIAgent.update = function (self, dt, t)
	local player = self._player

	if not player then
		return
	end

	local agent_data = self._agent_data
	local current_health = 0
	local health_extension = ScriptUnit.has_extension(player.player_unit, "health_system")

	if health_extension then
		current_health = health_extension:current_health()
	end

	agent_data.health = current_health
	local viewport_name = player.viewport_name
	local camera_manager = Managers.state.camera
	local pos = agent_data.camera.position
	pos.x, pos.y, pos.z = Vector3.to_elements(camera_manager:camera_position(viewport_name))
	local rot = agent_data.camera.rotation
	rot.yaw, rot.pitch, rot.roll = Quaternion.to_yaw_pitch_roll(camera_manager:camera_rotation(viewport_name))

	Renderer.data_marker(cjson.encode(agent_data))
end

return NvidiaAIAgent
