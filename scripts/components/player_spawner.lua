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
		value = "heroes",
		ui_type = "combo_box",
		ui_name = "Player Side",
		options_keys = {
			"Heroes"
		},
		options_values = {
			"heroes"
		}
	},
	spawn_identifier = {
		value = "default",
		ui_type = "combo_box",
		ui_name = "Spawn Identifier",
		options_keys = {
			"Default",
			"Bots"
		},
		options_values = {
			"default",
			"bots"
		}
	},
	spawn_priority = {
		ui_type = "number",
		min = 1,
		decimals = 0,
		value = 1,
		ui_name = "Spawn Priority",
		step = 1
	},
	extensions = {
		"PlayerSpawnerExtension"
	}
}

return PlayerSpawner
