local ScriptWorld = require("scripts/foundation/utilities/script_world")
Reportify = Reportify or {}
REPORTIFY_NETWORK_READY = false

Reportify.setup = function (self)
	self.has_setup = true
	self.content_revision = APPLICATION_SETTINGS.content_revision or LOCAL_CONTENT_REVISION or ""
	self.engine_revision = BUILD_IDENTIFIER or Application.build_identifier() or ""
	self.log_file_path = Application.get_filelog_local() or ""
	self.project = "BSP"
end

Reportify.get_data = function (self)
	if not self.has_setup then
		self:setup()
	end

	local pos, rot = self:_get_location()
	local player_info = self:_get_player_info()
	local mission_info = self:_create_summary()
	local console_command = {
		type = "reportify",
		project = self.project,
		fields = {
			customfield_10031 = self.content_revision,
			customfield_10032 = self.engine_revision,
			summary = mission_info
		},
		custom = {
			level = self:_get_level(),
			log_file_path = self.log_file_path,
			position = pos,
			rotation = rot,
			archetype = player_info.archetype_name,
			wielded_slot = player_info.wielded_slot,
			primary_slot = player_info.primary_name,
			secondary_slot = player_info.secondary_name
		}
	}

	Application.console_send(console_command)
end

Reportify._create_summary = function (self)
	local mission, chunk = self:_get_mission_info()

	return string.format("Reportify: Mission '%s/%s'", mission, chunk)
end

Reportify._get_mission_info = function (self)
	local mission_manager = Managers.state.mission
	local mission = mission_manager and mission_manager:mission()
	local mission_name = mission and mission.name or "n/a"
	local chunk_short_name = nil

	if Managers.state and Managers.state.chunk_lod then
		local chunk_name = Managers.state.chunk_lod:current_chunk_name()

		if chunk_name then
			chunk_short_name = string.match(chunk_name, "/([^/]+)/world.level")
		else
			chunk_short_name = "n/a"
		end
	end

	return mission_name, chunk_short_name
end

Reportify._get_level = function (self)
	local level_name = rawget(_G, "SPAWNED_LEVEL_NAME")

	return level_name or ""
end

Reportify._get_location = function (self)
	if not Managers.player then
		return ""
	end

	if not REPORTIFY_NETWORK_READY then
		return ""
	end

	local local_player = Managers.player:local_player(1)

	if not local_player or not Managers.state.camera or not ScriptWorld.has_viewport(Managers.state.camera._world, local_player.viewport_name) then
		return ""
	end

	return tostring(Managers.state.camera:camera_position(local_player.viewport_name)), tostring(Managers.state.camera:camera_rotation(local_player.viewport_name))
end

Reportify._get_player_info = function (self)
	local ret = {
		wielded_slot = "N/A",
		primary_name = "N/A",
		archetype_name = "N/A",
		secondary_name = "N/A"
	}

	if not Managers.player then
		return ret
	end

	if not REPORTIFY_NETWORK_READY then
		return ret
	end

	local local_player = Managers.player:local_player(1)

	if not local_player then
		return ret
	end

	local visual_loadout_extension = ScriptUnit.has_extension(local_player.player_unit, "visual_loadout_system")

	if visual_loadout_extension then
		ret.wielded_slot = visual_loadout_extension._locally_wielded_slot
	end

	local profile = local_player:profile()

	if not profile then
		return ret
	end

	if profile.archetype then
		ret.archetype_name = profile.archetype.name
	end

	if not profile.loadout or not profile.loadout.slot_primary or not profile.loadout.slot_secondary then
		return ret
	end

	ret.primary_name = profile.loadout.slot_primary.name
	ret.secondary_name = profile.loadout.slot_secondary.name

	return ret
end
