﻿-- chunkname: @scripts/settings/fx/effect_templates/cultist_gunner_stubber.lua

local Effect = require("scripts/extension_systems/fx/utilities/effect")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local shooting_difficulty_settings = MinionDifficultySettings.shooting.cultist_gunner
local WWISE_GUN_START = "wwise/events/weapon/play_minion_cultist_heavy_stubber_auto"
local WWISE_GUN_STOP = "wwise/events/weapon/stop_minion_cultist_heavy_stubber_auto"
local SHOOT_VFX = "content/fx/particles/weapons/rifles/gunner/gunner_muzzle"
local FIRE_RATE_PARAMETER_NAME = "wpn_fire_interval"
local STIMMED_PARAMETER_NAME = "minion_stimmed"
local resources = {
	shoot_vfx = SHOOT_VFX,
	wwise_gun_start = WWISE_GUN_START,
	wwise_gun_stop = WWISE_GUN_STOP,
}
local FX_MUZZLE_1_SOURCE_NAME = "muzzle"
local ORPHANED_POLICY = "stop"
local effect_template = {
	name = "cultist_gunner_stubber",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local inventory_item = visual_loadout_extension:slot_item("slot_ranged_weapon")
		local attachment_unit, fx_muzzle_node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, FX_MUZZLE_1_SOURCE_NAME)
		local wwise_world = template_context.wwise_world
		local source_id = WwiseWorld.make_manual_source(wwise_world, attachment_unit, fx_muzzle_node_index)

		WwiseWorld.trigger_resource_event(wwise_world, WWISE_GUN_START, source_id)

		template_data.source_id = source_id

		local game_session, game_object_id = template_context.game_session, Managers.state.unit_spawner:game_object_id(unit)
		local target_unit = MinionPerception.target_unit(game_session, game_object_id)

		template_data.target_unit = target_unit
		template_data.was_camera_following_target = Effect.update_targeted_by_ranged_minion_wwise_parameters(target_unit, wwise_world, source_id, nil)

		local world, position, pose = template_context.world, Vector3.zero(), Matrix4x4.identity()
		local muzzle_particle_id = World.create_particles(world, SHOOT_VFX, position)

		World.link_particles(world, muzzle_particle_id, attachment_unit, fx_muzzle_node_index, pose, ORPHANED_POLICY)

		template_data.muzzle_particle_id = muzzle_particle_id

		Unit.animation_event(unit, "offset_shotgun_standing_shoot_loop_01")

		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
		local fire_rate_modifier = 1

		if buff_extension then
			local stat_buffs = buff_extension:stat_buffs()

			if stat_buffs.ranged_attack_speed then
				fire_rate_modifier = stat_buffs.ranged_attack_speed
			end

			if buff_extension:has_keyword("stimmed") then
				WwiseWorld.set_source_parameter(wwise_world, source_id, STIMMED_PARAMETER_NAME, 1)
			end
		end

		local time_per_shot = shooting_difficulty_settings.time_per_shot
		local diff_time_per_shot = Managers.state.difficulty:get_table_entry_by_challenge(time_per_shot)
		local parameter_value = diff_time_per_shot[1]

		WwiseWorld.set_source_parameter(wwise_world, source_id, FIRE_RATE_PARAMETER_NAME, parameter_value / fire_rate_modifier)
	end,
	update = function (template_data, template_context, dt, t)
		local wwise_world = template_context.wwise_world
		local target_unit, source_id = template_data.target_unit, template_data.source_id
		local was_camera_following_target = template_data.was_camera_following_target
		local is_camera_following_target = Effect.update_targeted_by_ranged_minion_wwise_parameters(target_unit, wwise_world, source_id, was_camera_following_target)

		template_data.was_camera_following_target = is_camera_following_target
	end,
	stop = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		WwiseWorld.trigger_resource_event(wwise_world, WWISE_GUN_STOP, source_id)
		WwiseWorld.destroy_manual_source(wwise_world, source_id)

		local world = template_context.world
		local muzzle_particle_id = template_data.muzzle_particle_id

		World.stop_spawning_particles(world, muzzle_particle_id)

		local unit = template_data.unit

		Unit.animation_event(unit, "shoot_finished")
	end,
}

return effect_template
