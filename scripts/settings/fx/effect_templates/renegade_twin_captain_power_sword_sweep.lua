local Component = require("scripts/utilities/component")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local FX_SOURCE_NAME = "fx_shaft"
local VFX = "content/fx/particles/enemies/twins/twins_aoe_sweep_windup"
local resources = {
	vfx = VFX
}

local function _start_vfx(unit, position, node, template_data, template_context)
	local world = template_context.world
	local vfx_particle_id = World.create_particles(world, VFX, position, Quaternion.identity())

	World.link_particles(world, vfx_particle_id, unit, node, Matrix4x4.identity(), "stop")

	template_data.vfx_particle_id = vfx_particle_id
end

local effect_template = {
	name = "renegade_twin_captain_power_sword_sweep",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local inventory_item = visual_loadout_extension:slot_item("slot_power_sword")
		local attachment_unit, node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, FX_SOURCE_NAME)
		local position = Unit.world_position(attachment_unit, node_index)

		_start_vfx(attachment_unit, position, node_index, template_data, template_context)

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
		local vfx_particle_id = template_data.vfx_particle_id

		World.stop_spawning_particles(world, vfx_particle_id)

		local unit_components = template_data.unit_components
		local attachment_unit = template_data.attachment_unit
		local t = World.time(world)

		for _, component in pairs(unit_components) do
			component:set_stop_time(t, attachment_unit)
		end
	end
}

return effect_template
