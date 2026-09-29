-- chunkname: @scripts/settings/fx/effect_templates/renegade_wizard_hazard_indicator.lua

local anticipation = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_staff_anticipation_nurgle_01"
local climax = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_staff_climax_nurgle_01"
local slot_name = "slot_ranged_weapon"
local INTENSITY_VARIABLE_NAME = "intensity"
local INTENSITY_LERP_DURATION = 2
local resources = {
	vfx = {
		"content/fx/particles/enemies/renegade_wizard/renegade_wizard_staff_anticipation_nurgle_01",
		"content/fx/particles/enemies/renegade_wizard/renegade_wizard_staff_climax_nurgle_01",
	},
}
local effect_template = {
	name = "renegade_wizard_hazard_indicator",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local slot_data = visual_loadout_extension:slot_item(slot_name)
		local slot_unit = slot_data.unit
		local unit_node = Unit.node(slot_unit, "vfx")
		local unit_position = Unit.world_position(slot_unit, unit_node)
		local world = template_context.world
		local staff_indiactor_effect_id = World.create_particles(world, anticipation, unit_position)
		local orphaned_policy = "destroy"

		World.link_particles(world, staff_indiactor_effect_id, slot_unit, unit_node, Matrix4x4.identity(), orphaned_policy)

		template_data.effect_id = staff_indiactor_effect_id
		template_data.unit_node = unit_node
		template_data.slot_unit = slot_unit
		template_data.start_t = Managers.time:time("gameplay")
	end,
	update = function (template_data, template_context, dt, t)
		local effect_id = template_data.effect_id

		if not effect_id then
			return
		end

		local world = template_context.world
		local intensity = math.clamp01(math.ilerp(template_data.start_t, template_data.start_t + INTENSITY_LERP_DURATION, t))
		local intensity_variable = World.find_particles_variable(world, anticipation, INTENSITY_VARIABLE_NAME)

		World.set_particles_variable(world, effect_id, intensity_variable, Vector3(intensity, 0, 0))
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local slot_unit = template_data.slot_unit
		local unit_node = Unit.node(slot_unit, "vfx")
		local unit_position = Unit.world_position(slot_unit, unit_node)
		local effect_id = template_data.effect_id
		local linked_efffect_id = World.create_particles(world, climax, unit_position)
		local orphaned_policy = "destroy"

		World.link_particles(world, linked_efffect_id, slot_unit, unit_node, Matrix4x4.identity(), orphaned_policy)

		if effect_id then
			World.stop_spawning_particles(world, effect_id)

			template_data.effect_id = nil
		end
	end,
}

return effect_template
