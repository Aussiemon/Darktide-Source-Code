-- chunkname: @scripts/components/player_spawner.lua

local PlayerSpawner = component("PlayerSpawner")

PlayerSpawner.init = function (self, unit)
	self._unit = unit
	self._player_spawner_extension = ScriptUnit.fetch_component_extension(unit, "player_spawner_system")

	if self:get_data(unit, "active") then
		self:player_spawner_activate()
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

PlayerSpawner.player_spawner_activate = function (self)
	local player_spawner_extension = self._player_spawner_extension

	if not player_spawner_extension then
		return
	end

	local unit = self._unit
	local player_side = self:get_data(unit, "player_side")
	local spawn_identifier = self:get_data(unit, "spawn_identifier")
	local spawn_priority = self:get_data(unit, "spawn_priority")
	local parent_spawned = self:get_data(unit, "parent_spawned")

	player_spawner_extension:activate_spawner(unit, player_side, spawn_identifier, spawn_priority, parent_spawned)
end

PlayerSpawner.player_spawner_deactivate = function (self)
	local player_spawner_extension = self._player_spawner_extension

	if not player_spawner_extension then
		return
	end

	local unit = self._unit
	local spawn_identifier = self:get_data(unit, "spawn_identifier")

	player_spawner_extension:deactivate_spawner(unit, spawn_identifier)
end

PlayerSpawner.component_data = {
	active = {
		ui_type = "check_box",
		value = true,
		ui_name = "Active"
	},
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
			"Bots",
			"Recent Mission",
			"Shooting Range"
		},
		options_values = {
			"default",
			"bots",
			"recent_mission",
			"tg_shooting_range"
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
	parent_spawned = {
		ui_type = "check_box",
		value = false,
		ui_name = "Parent Spawned"
	},
	inputs = {
		player_spawner_activate = {
			accessibility = "public",
			type = "event"
		},
		player_spawner_deactivate = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"PlayerSpawnerExtension"
	}
}

return PlayerSpawner
