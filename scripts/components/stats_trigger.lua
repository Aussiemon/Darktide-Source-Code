-- chunkname: @scripts/components/stats_trigger.lua

local StatsTrigger = component("StatsTrigger")

StatsTrigger.init = function (self, unit, is_server)
	if not is_server then
		return
	end

	self._hook_type = self:get_data(unit, "hook_type")
	self._optional_value = self:get_data(unit, "optional_value")
	self._hook_name = self:get_data(unit, "hook_name")
	self._unit = unit
end

StatsTrigger.editor_init = function (self, unit)
	self:enable(unit)
end

StatsTrigger.editor_validate = function (self, unit)
	return true, ""
end

StatsTrigger.enable = function (self, unit)
	return
end

StatsTrigger.disable = function (self, unit)
	return
end

StatsTrigger.destroy = function (self, unit)
	return
end

StatsTrigger.stat_trigger_on_unit_destruction = function (self)
	local hook_name = self._hook_name
	local hook_type = self._hook_type

	if not hook_name and hook_type then
		return
	end

	local optional_value = self._optional_value

	if hook_type == "player" then
		local unit = self._unit
		local health_extension = ScriptUnit.extension(unit, "health_system")

		last_damaging_unit = health_extension:last_damaging_unit()

		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local target_player = player_unit_spawn_manager:owner(last_damaging_unit)

		Managers.stats:record_private(hook_name, target_player, optional_value)
	elseif hook_type == "team" then
		Managers.stats:record_team(hook_name, optional_value)
	end
end

StatsTrigger.component_data = {
	hook_name = {
		ui_type = "text_box",
		value = "",
		ui_name = "hook name",
		category = "hook name"
	},
	optional_value = {
		ui_type = "number",
		min = 0,
		decimals = 0,
		value = 0,
		ui_name = "optional value",
		step = 1000
	},
	hook_type = {
		ui_type = "combo_box",
		category = "Hook Type",
		value = "none",
		ui_name = "Player or Team",
		options_keys = {
			"player",
			"team"
		},
		options_values = {
			"player",
			"team"
		}
	},
	inputs = {
		stat_trigger_on_unit_destruction = {
			accessibility = "public",
			type = "event"
		}
	}
}

return StatsTrigger
