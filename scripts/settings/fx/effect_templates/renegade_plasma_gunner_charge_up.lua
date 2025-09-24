-- chunkname: @scripts/settings/fx/effect_templates/renegade_plasma_gunner_charge_up.lua

local Effect = require("scripts/extension_systems/fx/utilities/effect")
local MinionPerception = require("scripts/utilities/minion_perception")
local START_SOUND_EVENT = "wwise/events/weapon/play_minion_plasmapistol_charge"
local STOP_SOUND_EVENT = "wwise/events/weapon/stop_minion_plasmapistol_charge"
local MUZZLE_VFX = "content/fx/particles/enemies/renegade_plasma_trooper/renegade_plasma_charge_up"
local LIGHT_NAME = "plasma_light"
local resources = {
	start_sound_event = START_SOUND_EVENT,
	stop_sound_event = STOP_SOUND_EVENT,
	muzzle_vfx = MUZZLE_VFX,
}
local MAX_INTENSITY_LUMEN = 45
local GREEN = 0.09803921568627451
local BLUE = 0
local RED = 100
local scalar_addative_value = 0.5
local var_name = "emissive_multiplier"
local effect_template = {
	name = "renegade_plasma_gunner_charge_up",
	resources = resources,
	start = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local unit = template_data.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local inventory_unit = visual_loadout_extension:slot_unit("slot_ranged_weapon")

		template_data.inventory_unit = inventory_unit

		local source_id = WwiseWorld.make_manual_source(wwise_world, inventory_unit)

		WwiseWorld.trigger_resource_event(wwise_world, START_SOUND_EVENT, source_id)

		local game_session = Managers.state.game_session:game_session()
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		WwiseWorld.set_source_parameter(wwise_world, source_id, "charge_level", 0.5)

		local light = Unit.light(inventory_unit, LIGHT_NAME)

		Light.set_enabled(light, true)

		template_data.light = light
		template_data.source_id = source_id
		template_data.game_session, template_data.game_object_id = game_session, game_object_id
		template_data.lumen = 0
		template_data.material_scalar_variable = 0
		template_data.delay_before_shoot = 1.5

		local wanted_ticks = template_data.delay_before_shoot * 20
		local tick_delay = template_data.delay_before_shoot / wanted_ticks

		template_data.tick_delay = tick_delay
		template_data.lumen_increase_per_tick = MAX_INTENSITY_LUMEN / wanted_ticks
		template_data.current_tick = 0
	end,
	update = function (template_data, template_context, dt, t)
		local game_session, game_object_id = template_data.game_session, template_data.game_object_id
		local wwise_world, source_id = template_context.wwise_world, template_data.source_id
		local target_unit = MinionPerception.target_unit(game_session, game_object_id)
		local was_camera_following_target = template_data.was_camera_following_target
		local is_camera_following_target = Effect.update_targeted_in_melee_wwise_parameters(target_unit, wwise_world, source_id, was_camera_following_target)

		template_data.was_camera_following_target = is_camera_following_target

		if not template_data.t_before_next_tick then
			template_data.t_before_next_tick = t + template_data.tick_delay
		end

		if t > template_data.t_before_next_tick then
			template_data.lumen = math.clamp(template_data.lumen + template_data.lumen_increase_per_tick, 0, MAX_INTENSITY_LUMEN)

			local inventory_unit = template_data.inventory_unit

			template_data.material_scalar_variable = template_data.material_scalar_variable + scalar_addative_value

			Unit.set_scalar_for_materials(inventory_unit, var_name, template_data.material_scalar_variable, true)

			local light = template_data.light
			local red = (100 + template_data.current_tick * 10) / 255

			Light.set_color_filter(template_data.light, Vector3(red, GREEN, BLUE))
			Light.set_intensity(light, template_data.lumen)

			template_data.current_tick = template_data.current_tick + 1
		end
	end,
	stop = function (template_data, template_context)
		local light = template_data.light

		Light.set_intensity(light, 0)

		local inventory_unit = template_data.inventory_unit

		Unit.set_scalar_for_materials(inventory_unit, "emissive_multiplier", 1, true)

		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		WwiseWorld.trigger_resource_event(wwise_world, STOP_SOUND_EVENT, source_id)
		WwiseWorld.destroy_manual_source(wwise_world, source_id)
	end,
}

return effect_template
