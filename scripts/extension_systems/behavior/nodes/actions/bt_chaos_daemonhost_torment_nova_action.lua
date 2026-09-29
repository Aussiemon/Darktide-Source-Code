-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_chaos_daemonhost_torment_nova_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local Push = require("scripts/extension_systems/character_state_machine/character_states/utilities/push")
local Suppression = require("scripts/utilities/attack/suppression")
local PLAYER_BREED_TYPE = BreedSettings.types.player
local SHOCKWAVE_EFFECT_TEMPLATE = EffectTemplates.chaos_daemonhost_torment_nova_shockwave
local SHOCKWAVE_SFX = "wwise/events/world/play_event_daemonhost_aoe_shockwave"
local AREA_EFFECT_TEMPLATE = EffectTemplates.chaos_daemonhost_torment_nova_area
local BROADPHASE_RESULTS = {}

local function _deal_damage(unit, action_data, scratchpad)
	local broadphase = scratchpad.broadphase
	local side = scratchpad.side
	local enemy_side_names = scratchpad.enemy_side_names
	local valid_enemy_player_units = side.valid_enemy_player_units
	local radius = action_data.radius
	local from = POSITION_LOOKUP[unit]
	local num_results = broadphase.query(broadphase, from, radius, BROADPHASE_RESULTS, enemy_side_names, PLAYER_BREED_TYPE)

	if num_results < 1 then
		return
	end

	local hit_zone_name = action_data.hit_zone_name
	local power_level = action_data.power_level
	local damage_profile = action_data.damage_profile
	local damage_type = action_data.damage_type

	for i = 1, num_results do
		local hit_unit = BROADPHASE_RESULTS[i]

		if hit_unit ~= unit and valid_enemy_player_units[hit_unit] then
			local to = POSITION_LOOKUP[hit_unit]
			local direction = Vector3.normalize(to - from)
			local length_sq = Vector3.length_squared(direction)

			if length_sq ~= 0 then
				local damage, result, damage_efficiency = Attack.execute(hit_unit, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_direction", direction, "hit_zone_name", hit_zone_name, "damage_type", damage_type)

				ImpactEffect.play(hit_unit, nil, damage, damage_type, nil, result, to, nil, direction, unit, nil, nil, nil, damage_efficiency, damage_profile)

				local target_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
				local locomotion_push_component = target_unit_data_extension:write_component("locomotion_push")

				Push.add(hit_unit, locomotion_push_component, direction, action_data.push_template, "push")
			end
		end
	end

	local suppression = action_data.suppression

	if suppression then
		local relation = "allied"

		Suppression.apply_area_minion_suppression(unit, suppression, from, relation)
	end
end

local StateTelegraph = {}

StateTelegraph.enter = function (self, unit, scratchpad, action_data, t)
	scratchpad.wave_index = scratchpad.wave_index + 1

	local telegraph_duration = action_data.telegraph_durations[scratchpad.wave_index]

	scratchpad.telegraph_duration_t = t + telegraph_duration

	scratchpad.animation_extension:anim_event(action_data.telegraph_anim_event)
end

StateTelegraph.update = function (self, unit, scratchpad, action_data, t)
	if t >= scratchpad.telegraph_duration_t then
		return "nova_emit"
	end
end

local StateEmit = {}

StateEmit.enter = function (self, unit, scratchpad, action_data, t)
	local anim_event = Animation.random_event(action_data.attack_anim_events)

	scratchpad.animation_extension:anim_event(anim_event)

	scratchpad.attack_duration_t = t + action_data.attack_anim_durations[anim_event]
	scratchpad.behavior_component.move_state = "attacking"

	local fx_system = scratchpad.fx_system

	if scratchpad.shockwave_effect_id then
		fx_system:stop_template_effect(scratchpad.shockwave_effect_id)
	end

	scratchpad.shockwave_effect_id = fx_system:start_template_effect(SHOCKWAVE_EFFECT_TEMPLATE, unit)

	fx_system:trigger_wwise_event(SHOCKWAVE_SFX, POSITION_LOOKUP[unit])
	_deal_damage(unit, action_data, scratchpad)
end

StateEmit.update = function (self, unit, scratchpad, action_data, t)
	if t > scratchpad.attack_duration_t then
		if scratchpad.wave_index < #action_data.telegraph_durations then
			return "nova_telegraph"
		end

		return "done"
	end
end

local STATES = {
	nova_telegraph = StateTelegraph,
	nova_emit = StateEmit,
}
local BtChaosDaemonhostTormentNovaAction = class("BtChaosDaemonhostTormentNovaAction", "BtNode")

BtChaosDaemonhostTormentNovaAction.init_values = function (self, blackboard, action_data, node_data)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.warp_nova_cooldown = 0
	behavior_component.death_leave_cooldown = Managers.time:time("gameplay") + action_data.leave_cooldown
end

BtChaosDaemonhostTormentNovaAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	scratchpad.behavior_component = behavior_component
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]

	scratchpad.side = side
	scratchpad.enemy_side_names = side:relation_side_names("enemy")

	local broadphase_system = Managers.state.extension:system("broadphase_system")

	scratchpad.broadphase = broadphase_system.broadphase

	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.area_effect_id = fx_system:start_template_effect(AREA_EFFECT_TEMPLATE, unit)
	scratchpad.fx_system = fx_system
	scratchpad.wave_index = 0

	self:_change_state("nova_telegraph", unit, scratchpad, action_data, t)
end

BtChaosDaemonhostTormentNovaAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local fx_system = scratchpad.fx_system

	fx_system:stop_template_effect(scratchpad.area_effect_id)

	if scratchpad.shockwave_effect_id then
		fx_system:stop_template_effect(scratchpad.shockwave_effect_id)
	end

	local cooldown_duration = action_data.cooldown_duration

	if type(cooldown_duration) == "table" then
		cooldown_duration = math.random_range(cooldown_duration[1], cooldown_duration[2])
	end

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.warp_nova_cooldown = t + cooldown_duration
end

BtChaosDaemonhostTormentNovaAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local next_state = scratchpad.state:update(unit, scratchpad, action_data, t)

	if next_state == "done" then
		return "done"
	elseif next_state then
		self:_change_state(next_state, unit, scratchpad, action_data, t)
	end

	return "running"
end

BtChaosDaemonhostTormentNovaAction._change_state = function (self, state_name, unit, scratchpad, action_data, t)
	local state = STATES[state_name]

	scratchpad.state = state

	state:enter(unit, scratchpad, action_data, t)
end

return BtChaosDaemonhostTormentNovaAction
