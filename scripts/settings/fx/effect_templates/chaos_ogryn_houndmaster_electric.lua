-- chunkname: @scripts/settings/fx/effect_templates/chaos_ogryn_houndmaster_electric.lua

local Effect = require("scripts/extension_systems/fx/utilities/effect")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local FX_SOURCE_NAME = "fx_impact_01"
local LIGHT_NAME = "light"
local VFX = {
	"content/fx/particles/enemies/chaos_ogryn/houndmaster_poker_activate",
	"content/fx/particles/enemies/chaos_ogryn/houndmaster_poker",
}
local SFX = "wwise/events/minions/play_chaos_hound_master_rod_blast"
local resources = {
	vfx = VFX,
	sfx = SFX,
}

local function _start_effect(unit, position, node, template_data, template_context)
	local world = template_context.world

	for i = 1, #VFX do
		local fx_name = VFX[i]
		local vfx_particle_id = World.create_particles(world, fx_name, position, Quaternion.identity(), nil, template_data.particle_group)

		World.link_particles(world, vfx_particle_id, unit, node, Matrix4x4.identity(), "stop")
		table.insert(template_data.vfx_particle_ids, vfx_particle_id)
	end
end

local MAX_INTENSITY_LUMEN = 80
local scalar_addative_value = 0.5
local DEFAULT_LIGHT_INTENSITY = 5
local var_name = "emissive_multiplier"
local effect_template = {
	name = "chaos_ogryn_houndmaster_electric",
	resources = resources,
	start = function (template_data, template_context)
		local wwise_world = template_context.wwise_world
		local unit = template_data.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local inventory_unit = visual_loadout_extension:slot_unit("slot_melee_weapon")

		template_data.inventory_unit = inventory_unit

		local source_id = WwiseWorld.make_manual_source(wwise_world, inventory_unit)

		WwiseWorld.trigger_resource_event(wwise_world, SFX, source_id)

		local game_session = Managers.state.game_session:game_session()
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		WwiseWorld.set_source_parameter(wwise_world, source_id, "charge_level", 0.5)

		local light = Unit.light(inventory_unit, LIGHT_NAME)

		Light.set_enabled(light, true)

		template_data.light = light
		template_data.vfx_particle_ids = {}

		local inventory_item = visual_loadout_extension:slot_item("slot_melee_weapon")
		local optional_lookup_fx_sources = false
		local attachment_unit, node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, FX_SOURCE_NAME, optional_lookup_fx_sources)
		local position = Unit.world_position(attachment_unit, node_index)

		_start_effect(attachment_unit, position, node_index, template_data, template_context)

		template_data.source_id = source_id
		template_data.game_session, template_data.game_object_id = game_session, game_object_id
		template_data.lumen = 0
		template_data.material_scalar_variable = 0
		template_data.current_tick = 0

		local t = Managers.time:time("gameplay")

		template_data.t_til_scope = t + 1
	end,
	update = function (template_data, template_context, dt, t)
		local game_session, game_object_id = template_data.game_session, template_data.game_object_id
		local wwise_world, source_id = template_context.wwise_world, template_data.source_id
		local target_unit = MinionPerception.target_unit(game_session, game_object_id)
		local was_camera_following_target = template_data.was_camera_following_target
		local is_camera_following_target = Effect.update_targeted_in_melee_wwise_parameters(target_unit, wwise_world, source_id, was_camera_following_target)

		template_data.was_camera_following_target = is_camera_following_target

		if not template_data.t_before_next_tick then
			template_data.t_before_next_tick = t + 1
		end

		if t > template_data.t_before_next_tick then
			template_data.lumen = math.clamp(template_data.lumen + 1, DEFAULT_LIGHT_INTENSITY, MAX_INTENSITY_LUMEN)

			local inventory_unit = template_data.inventory_unit

			template_data.material_scalar_variable = template_data.material_scalar_variable + scalar_addative_value

			Unit.set_scalar_for_materials(inventory_unit, var_name, template_data.material_scalar_variable, true)

			local light = template_data.light

			Light.set_intensity(light, template_data.lumen)

			template_data.current_tick = template_data.current_tick + 1
		end
	end,
	stop = function (template_data, template_context)
		local light = template_data.light

		Light.set_intensity(light, DEFAULT_LIGHT_INTENSITY)

		local inventory_unit = template_data.inventory_unit

		Unit.set_scalar_for_materials(inventory_unit, "emissive_multiplier", 6, true)

		local wwise_world = template_context.wwise_world
		local source_id = template_data.source_id

		WwiseWorld.destroy_manual_source(wwise_world, source_id)

		local world = template_context.world
		local vfx_particle_ids = template_data.vfx_particle_ids

		for i = 1, #vfx_particle_ids do
			local vfx_particle_id = vfx_particle_ids[i]

			World.stop_spawning_particles(world, vfx_particle_id)
		end
	end,
}

return effect_template
