-- chunkname: @scripts/extension_systems/weapon/actions/action_place_deployable.lua

require("scripts/extension_systems/weapon/actions/action_place_base")

local ActionPlaceDeployable = class("ActionPlaceDeployable", "ActionPlaceBase")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Vo = require("scripts/utilities/vo")
local buff_proc_events = BuffSettings.proc_events
local TRAINING_GROUNDS_GAME_MODE_NAME = "training_grounds"

ActionPlaceDeployable._place_unit = function (self, action_settings, position, rotation, placed_on_unit)
	local player_unit = self._player_unit
	local player_or_nil = Managers.state.player_unit_spawn:owner(player_unit)
	local deployable_settings = action_settings.deployable_settings
	local unit_template = deployable_settings.unit_template
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local side_id = side.side_id
	local unit_name, material, placed_unit

	placed_unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template, position, rotation, material, side_id, deployable_settings, placed_on_unit, player_unit)

	local game_mode_name = Managers.state.game_mode:game_mode_name()

	if game_mode_name == TRAINING_GROUNDS_GAME_MODE_NAME then
		Managers.event:trigger("tg_on_pickup_placed", placed_unit)
	end

	if action_settings.use_ability_charge then
		local ability_type = action_settings.ability_type
		local ability_extension = ScriptUnit.extension(player_unit, "ability_system")

		ability_extension:use_ability_charge(ability_type)

		local vo_tag = action_settings.vo_tag

		if vo_tag then
			Vo.play_combat_ability_event(player_unit, vo_tag)
		end
	end

	local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

	if buff_extension then
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.deployable_name = deployable_settings.name
			param_table.position = Vector3Box(position)
			param_table.life_time = deployable_settings.proximity_init_data.life_time

			buff_extension:add_proc_event(buff_proc_events.on_deployable_placed, param_table)
		end
	end

	self:_register_stats_and_telemetry(unit_template, player_or_nil)
end

return ActionPlaceDeployable
