require("scripts/extension_systems/weapon/actions/action_ability_base")

local Vo = require("scripts/utilities/vo")
local BROADPHASE_RESULTS = {}
local ActionProximityTag = class("ActionProximityTag", "ActionAbilityBase")

ActionProximityTag.init = function (self, action_context, action_params, action_settings)
	ActionProximityTag.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
end

ActionProximityTag.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionProximityTag.super.start(self, action_settings, t, time_scale, action_start_params)

	local anim = action_settings.anim
	local anim_3p = action_settings.anim_3p or anim
	local vo_tag = action_settings.vo_tag
	local locomotion_component = self._locomotion_component
	local ability_template_tweak_data = self._ability_template_tweak_data
	local player_unit = self._player_unit
	local buff_to_add = ability_template_tweak_data.buff_to_add
	local player_position = locomotion_component.position

	if self._is_local_unit then
		self._fx_extension:trigger_wwise_event("wwise/events/player/play_player_ability_shout", false, player_position)

		local vo_event = action_settings.vo_event

		if vo_event then
			local source = self._fx_extension:sound_source("voice")

			WwiseWorld.trigger_resource_event(self._wwise_world, vo_event, source)
		end
	end

	if anim then
		self:trigger_anim_event(anim, anim_3p)
	end

	if vo_tag then
		Vo.play_combat_ability_event(player_unit, vo_tag)
	end

	if buff_to_add then
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

		buff_extension:add_internally_controlled_buff(buff_to_add, t)
	end

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local query_position = POSITION_LOOKUP[player_unit]
	local query_radius = action_settings.radius
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local has_outline_system = Managers.state.extension:has_system("outline_system")

	if has_outline_system then
		local outline_system = Managers.state.extension:system("outline_system")

		table.clear(BROADPHASE_RESULTS)

		local broadphase = broadphase_system.broadphase
		local num_results = broadphase:query(query_position, query_radius, BROADPHASE_RESULTS, enemy_side_names)

		for i = 1, num_results do
			local enemy_unit = BROADPHASE_RESULTS[i]

			if HEALTH_ALIVE[enemy_unit] then
				outline_system:add_outline(enemy_unit, "special_target")
			end
		end
	end
end

return ActionProximityTag
