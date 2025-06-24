-- chunkname: @scripts/settings/fx/effect_templates/renegade_flamer_mutator_throw.lua

local Component = require("scripts/utilities/component")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local FX_SOURCE_NAME = "fx_muzzle_01"
local VFX = {
	"content/fx/particles/enemies/renegade_flamer/renegade_flame_thrower_show",
}
local SFX = {
	looping_sfx_start_event = "wwise/events/weapon/play_minion_flamethrower_mutator_start",
	looping_sfx_stop_event = "wwise/events/weapon/play_minion_flamethrower_mutator_stop",
	sfx_windup_event = "wwise/events/weapon/play_minion_flamethrower_mutator_wind_up",
}
local resources = {
	vfx = VFX,
	sfx = SFX,
}

local function _start_effect(unit, position, node, template_data, template_context)
	local world = template_context.world

	for i = 1, #VFX do
		local fx_name = VFX[i]
		local vfx_particle_id = World.create_particles(world, fx_name, position, Quaternion.identity())

		World.link_particles(world, vfx_particle_id, unit, node, Matrix4x4.identity(), "stop")
		table.insert(template_data.vfx_particle_ids, vfx_particle_id)
	end
end

local effect_template = {
	name = "renegade_flamer_mutator_throw",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit

		template_data.vfx_particle_ids = {}

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local inventory_item = visual_loadout_extension:slot_item("slot_ranged_weapon")
		local optional_lookup_fx_sources = false
		local attachment_unit, node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, FX_SOURCE_NAME, optional_lookup_fx_sources)
		local position = Unit.world_position(attachment_unit, node_index)
		local wwise_world = template_context.wwise_world
		local inventory_unit = visual_loadout_extension:slot_unit("slot_ranged_weapon")
		local source_id = WwiseWorld.make_manual_source(wwise_world, inventory_unit)
		local chance = math.random()

		if chance > 0.3 then
			WwiseWorld.trigger_resource_event(wwise_world, SFX.sfx_windup_event, source_id)
		end

		WwiseWorld.trigger_resource_event(wwise_world, SFX.looping_sfx_start_event, source_id)

		template_data.source_id = source_id

		_start_effect(attachment_unit, position, node_index, template_data, template_context)

		template_data.attachment_unit = attachment_unit

		local unit_components = Component.get_components_by_name(attachment_unit, "WeaponMaterialVariables")

		template_data.unit_components = unit_components

		local world = template_context.world
		local t = World.time(world)

		for _, component in pairs(unit_components) do
			component:set_start_time(t, attachment_unit)
		end
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local vfx_particle_ids = template_data.vfx_particle_ids

		for i = 1, #vfx_particle_ids do
			local vfx_particle_id = vfx_particle_ids[i]

			World.stop_spawning_particles(world, vfx_particle_id)
		end

		local looping_sfx_stop_event = SFX.looping_sfx_stop_event

		if looping_sfx_stop_event then
			local source_id = template_data.source_id
			local unit = template_data.unit
			local wwise_world = template_context.wwise_world

			if source_id and HEALTH_ALIVE[unit] then
				WwiseWorld.trigger_resource_event(wwise_world, looping_sfx_stop_event, source_id)
			end
		end

		local unit_components, attachment_unit = template_data.unit_components, template_data.attachment_unit
		local t = World.time(world)

		for _, component in pairs(unit_components) do
			component:set_stop_time(t, attachment_unit)
		end
	end,
}

return effect_template
