-- chunkname: @scripts/settings/fx/effect_templates/renegade_executor_chainaxe.lua

local Effect = require("scripts/extension_systems/fx/utilities/effect")
local MinionPerception = require("scripts/utilities/minion_perception")
local INTERPOLATION_INCREASE_SPEED = 2
local INTERPOLATION_DECREASE_SPEED = -4
local MIN_WEAPON_INTENSITY = 0
local MAX_WEAPON_INTENSITY = 1
local START_SOUND_EVENT = "wwise/events/weapon/play_combat_weapon_chainaxe_chaos"
local STOP_SOUND_EVENT = "wwise/events/weapon/stop_combat_weapon_chainaxe_chaos"
local resources = {
	start_sound_event = START_SOUND_EVENT,
	stop_sound_event = STOP_SOUND_EVENT,
}
local effect_template = {
	name = "renegade_executor_chainaxe",
	resources = resources,
	start = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local unit = template_data.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local inventory_unit = visual_loadout_extension:slot_unit("slot_melee_weapon")
		local source_id = WwiseWorld.make_manual_source(wwise_world, inventory_unit)

		WwiseWorld.trigger_resource_event(wwise_world, START_SOUND_EVENT, source_id)

		local game_session = Managers.state.game_session:game_session()
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		local weapon_intensity = GameSession.game_object_field(game_session, game_object_id, "weapon_intensity")

		WwiseWorld.set_source_parameter(wwise_world, source_id, "combat_chainsword_throttle", weapon_intensity)

		template_data.source_id = source_id
		template_data.game_session, template_data.game_object_id = game_session, game_object_id
		template_data.weapon_intensity = weapon_intensity
	end,
	update = function (template_data, template_context, dt, t)
		local game_session, game_object_id = template_data.game_session, template_data.game_object_id
		local wanted_weapon_intensity = GameSession.game_object_field(game_session, game_object_id, "weapon_intensity")
		local weapon_intensity, interpolation_speed = template_data.weapon_intensity

		if weapon_intensity < wanted_weapon_intensity then
			interpolation_speed = INTERPOLATION_INCREASE_SPEED
		elseif wanted_weapon_intensity < weapon_intensity then
			interpolation_speed = INTERPOLATION_DECREASE_SPEED
		end

		local wwise_world, source_id = template_context.wwise_world, template_data.source_id

		if interpolation_speed then
			local new_weapon_intensity = math.clamp(weapon_intensity + interpolation_speed * dt, MIN_WEAPON_INTENSITY, MAX_WEAPON_INTENSITY)

			WwiseWorld.set_source_parameter(wwise_world, source_id, "combat_chainsword_throttle", new_weapon_intensity)

			template_data.weapon_intensity = new_weapon_intensity
		end

		local target_unit = MinionPerception.target_unit(game_session, game_object_id)
		local was_camera_following_target = template_data.was_camera_following_target
		local is_camera_following_target = Effect.update_targeted_in_melee_wwise_parameters(target_unit, wwise_world, source_id, was_camera_following_target)

		template_data.was_camera_following_target = is_camera_following_target
	end,
	stop = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		WwiseWorld.trigger_resource_event(wwise_world, STOP_SOUND_EVENT, source_id)
		WwiseWorld.destroy_manual_source(wwise_world, source_id)
	end,
}

return effect_template
