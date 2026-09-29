-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_wizard_upheaval_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Attack = require("scripts/utilities/attack/attack")
local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local BtWizardUpheavalAction = class("BtWizardUpheavalAction", "BtNode")

BtWizardUpheavalAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local anim_events = action_data.anim_events

	scratchpad.anim_events = anim_events
	scratchpad.idx = 1

	self:_play_animation(unit, breed, blackboard, scratchpad, action_data, t)

	scratchpad.fx_system = Managers.state.extension:system("fx_system")
end

BtWizardUpheavalAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local abilites_component = Blackboard.write_component(blackboard, "abilites")

	abilites_component.current_ability = ""

	abilites_component.ability_position:store(0, 0, 0)

	if scratchpad.global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(scratchpad.global_effect_id)
	end
end

BtWizardUpheavalAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if not scratchpad.anim_damage_timings then
		scratchpad.anim_damage_timings = action_data.effect_lerp_duration + t
	end

	local anim_duration = scratchpad.anim_duration

	if not scratchpad.effect_started then
		self:_start_effect_template(unit, breed, blackboard, scratchpad, action_data, t)
	end

	if scratchpad.anim_damage_timings and t > scratchpad.anim_damage_timings and not scratchpad.upheaval_done then
		self:_upheaval(unit, breed, blackboard, scratchpad, action_data, dt, t)

		local vector_fields_system = Managers.state.extension:system("vector_fields_system")

		vector_fields_system:awake_vector_field("wind", 15, blackboard.abilites.ability_position, QuaternionBox(Quaternion.identity()), 20, 15, "filter_all")

		scratchpad.upheaval_done = true
	end

	local idx = scratchpad.idx

	if anim_duration and anim_duration < t then
		if idx >= #scratchpad.anim_events then
			return "done"
		elseif idx < #scratchpad.anim_events then
			scratchpad.idx = scratchpad.idx + 1

			self:_play_animation(unit, breed, blackboard, scratchpad, action_data, t)
		end
	end

	return "running"
end

BtWizardUpheavalAction._upheaval = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local players = Managers.player:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if ALIVE[player_unit] then
			local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

			if buff_extension and not buff_extension:has_keyword("in_tether") then
				local attack_position = Unit.world_position(player_unit, 1)

				Attack.execute(player_unit, DamageProfileTemplates.renegade_wizard_z_catapult, "power_level", 2000, "attack_direction", Vector3.up(), "hit_world_position", attack_position)
			end
		end
	end

	local spawned_minions = Managers.state.minion_spawn:spawned_minions()

	for ii = 1, #spawned_minions do
		local spawned_minion = spawned_minions[ii]

		if spawned_minion ~= unit then
			local buff_extension = ScriptUnit.has_extension(spawned_minion, "buff_system")

			if buff_extension and not buff_extension:has_keyword("in_tether") then
				local target_blackboard = BLACKBOARDS[spawned_minion]
				local has_gib_override = Blackboard.has_component(target_blackboard, "gib_override")

				if has_gib_override then
					local gib_override = Blackboard.write_component(target_blackboard, "gib_override")

					gib_override.should_override = true
					gib_override.target_template = "havoc_self_gib"
					gib_override.override_hit_zone_name = "center_mass"
				end

				Attack.execute(spawned_minion, DamageProfileTemplates.default, "power_level", 2000, "attack_direction", Vector3.up(), "instakill", true)
			end
		end
	end
end

BtWizardUpheavalAction._start_effect_template = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id
	local unboxed_from_position = blackboard.abilites.ability_position:unbox()
	local to_position = Vector3(unboxed_from_position[1], unboxed_from_position[2], unboxed_from_position[3] + 5)

	GameSession.set_game_object_field(game_session, game_object_id, "from_position", unboxed_from_position)
	GameSession.set_game_object_field(game_session, game_object_id, "to_position", to_position)

	if not scratchpad.global_effect_id then
		local fx_system = scratchpad.fx_system
		local effect_name = action_data.effect_name
		local effect_template = EffectTemplates[effect_name]
		local global_effect_id = fx_system:start_template_effect(effect_template, unit)

		scratchpad.global_effect_id = global_effect_id
	end
end

BtWizardUpheavalAction._play_animation = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local anim_events = action_data.anim_events
	local current_animation = anim_events[scratchpad.idx]
	local anim_duration = action_data.anim_duration[current_animation]

	if anim_duration then
		scratchpad.anim_duration = anim_duration + t
	end

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(current_animation)
end

return BtWizardUpheavalAction
