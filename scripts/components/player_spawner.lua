-- chunkname: @scripts/components/player_spawner.lua

local PlayerSpawner = component("PlayerSpawner")

PlayerSpawner.init = function (self, unit)
	local player_spawner_extension = ScriptUnit.fetch_component_extension(unit, "player_spawner_system")

	if player_spawner_extension then
		local player_side = self:get_data(unit, "player_side")
		local spawn_identifier = self:get_data(unit, "spawn_identifier")
		local spawn_priority = self:get_data(unit, "spawn_priority")

		player_spawner_extension:setup_from_component(unit, player_side, spawn_identifier, spawn_priority)
	end
end

PlayerSpawner.editor_init = function (self, unit)
	return
end

PlayerSpawner.editor_validate = function (self, unit)
	return true, ""
end

PlayerSpawner.enable = function (self, unit)
	return
end

PlayerSpawner.disable = function (self, unit)
	return
end

PlayerSpawner.destroy = function (self, unit)
	return
end

PlayerSpawner.component_data = {
	player_side = {
		ui_name = "Player Side",
		ui_type = "combo_box",
		value = "heroes",
		options_keys = {
			"Heroes",
		},
		options_values = {
			"heroes",
		},
	},
	spawn_identifier = {
		ui_name = "Spawn Identifier",
		ui_type = "combo_box",
		value = "default",
		options_keys = {
			"Default",
			"Bots",
			"Recent Mission",
			"Shooting Range",
		},
		options_values = {
			"default",
			"bots",
			"recent_mission",
			"tg_shooting_range",
		},
	},
	spawn_priority = {
		decimals = 0,
		min = 1,
		step = 1,
		ui_name = "Spawn Priority",
		ui_type = "number",
		value = 1,
	},
	extensions = {
		"PlayerSpawnerExtension",
	},
}

return PlayerSpawner
