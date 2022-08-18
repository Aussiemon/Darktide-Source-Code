local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local FX_SOURCE_NAME = "fx_shaft"
local VFX = "content/fx/particles/enemies/renegade_captain/renegade_captain_2h_heavy_swing_trail"
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
	name = "renegade_captain_power_sword_sweep",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local inventory_item = visual_loadout_extension:slot_item("slot_power_sword")
		local attachment_unit, node_index = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, FX_SOURCE_NAME)
		local position = Unit.world_position(attachment_unit, node_index)

		_start_vfx(attachment_unit, position, node_index, template_data, template_context)
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local vfx_particle_id = template_data.vfx_particle_id

		World.stop_spawning_particles(world, vfx_particle_id)
	end
}

return effect_template
