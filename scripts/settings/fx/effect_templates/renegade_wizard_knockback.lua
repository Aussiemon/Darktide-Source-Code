-- chunkname: @scripts/settings/fx/effect_templates/renegade_wizard_knockback.lua

local VFX = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_barrier_warp"
local resources = {}
local _create_particles, _stop_spawning_particles, _set_outline
local OUTLINE = "stimmed_color"
local OUTLINE_COLOR = {
	on = Vector3Box(0.15, 0.008, 0.04),
	off = Vector3Box(0, 0, 0),
}
local effect_template = {
	name = "renegade_wizard_knockback",
	resources = resources,
	start = function (template_data, template_context)
		_create_particles(template_data, template_context)
		_set_outline(template_data.unit, true)
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		_stop_spawning_particles(template_data, template_context)
		_set_outline(template_data.unit, false)
	end,
}

function _set_outline(unit, outline_on)
	local state_key = outline_on and "on" or "off"

	Unit.set_vector3_for_materials_in_unit_and_childs(unit, OUTLINE, OUTLINE_COLOR[state_key]:unbox())
end

function _create_particles(template_data, template_context)
	local world = template_context.world
	local unit = template_data.unit

	if template_data.effect_id then
		return
	end

	local unit_position = Unit.world_position(unit, 1)
	local effect_id = World.create_particles(world, VFX, unit_position)

	template_data.effect_id = effect_id
end

function _stop_spawning_particles(template_data, template_context)
	local world = template_context.world
	local effect_id = template_data.effect_id

	if effect_id then
		World.stop_spawning_particles(world, effect_id)

		template_data.effect_id = nil
	end
end

return effect_template
