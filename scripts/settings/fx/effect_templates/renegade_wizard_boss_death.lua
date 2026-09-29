-- chunkname: @scripts/settings/fx/effect_templates/renegade_wizard_boss_death.lua

local MinionDissolveUtility = require("scripts/extension_systems/scripted_scenario/minion_dissolve_utility")
local DIS_VFX = "content/fx/particles/enemies/nurgle_flies_dissipate"
local resources = {}
local DISSOLVE_DURATION = 4.666666666666667
local effect_template = {
	name = "renegade_wizard_boss_death",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local t = Managers.time:time("gameplay")
		local toxin_green_hsv = Vector3(0.15, 0.5, 0)
		local dissolve_data = MinionDissolveUtility.start_dissolve(unit, t, false, toxin_green_hsv)

		if dissolve_data then
			dissolve_data.duration = DISSOLVE_DURATION
			dissolve_data.done_t = t + DISSOLVE_DURATION

			local uv_offset = Vector3(0.75, 0.75, 0)

			Unit.set_vector3_for_materials(unit, "shape_mask_uv_offset", uv_offset, true)
		end

		local create_flies_t = t + DISSOLVE_DURATION * 0.75

		template_data.create_flies_t = create_flies_t

		local hide_t = t + DISSOLVE_DURATION * 0.5

		template_data.hide_t = hide_t
		template_data.dissolve_data = dissolve_data
	end,
	update = function (template_data, template_context, dt, t)
		if template_data.finished then
			return
		end

		local unit = template_data.unit
		local hide_t = template_data.create_flies_t

		if hide_t < t and not template_data.hidden then
			Unit.set_unit_visibility(unit, false, true)

			template_data.hidden = true
		end

		local create_flies_t = template_data.create_flies_t

		if create_flies_t < t and not template_data.flies_spawned then
			local node = Unit.node(unit, "j_spine")
			local pos = Unit.world_position(unit, node)

			World.create_particles(template_context.world, DIS_VFX, pos)

			template_data.flies_spawned = true
		end

		local dissolve_data = template_data.dissolve_data
		local is_done = MinionDissolveUtility.update_dissolve(unit, dissolve_data, t)
		local chest_node = Unit.has_node(unit, "j_spine") and Unit.node(unit, "j_spine") or 1
		local chest_local_pos = Unit.local_position(unit, chest_node)

		Unit.set_vector3_for_materials(unit, "wound_position_01", chest_local_pos, true)

		if is_done then
			template_data.finished = true
		end
	end,
	stop = function (template_data, template_context)
		return
	end,
}

return effect_template
