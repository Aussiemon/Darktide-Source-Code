-- chunkname: @scripts/settings/fx/effect_templates/renegade_wizard_hazard_indicator_warp.lua

local anticipation = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_staff_anticipation_warp_shockwave_01"
local slot_name = "slot_ranged_weapon"
local SIZE_VARIABLE_NAME = "size"
local LIFETIME_VARIABLE_NAME = "lifetime"
local INDICATOR_DURATION_FIELD = "indicator_duration"
local DEFAULT_DURATION = 2
local SIZE_RAMP_END = 0.85
local LIFETIME_START = 2
local LIFETIME_END = 0.75
local resources = {
	vfx = {
		"content/fx/particles/enemies/renegade_wizard/renegade_wizard_staff_anticipation_warp_shockwave_01",
	},
}
local _get_indicator_duration
local duration_subtrack = 1.4
local effect_template = {
	name = "renegade_wizard_hazard_indicator_warp",
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

		local start_t = Managers.time:time("gameplay")
		local duration = _get_indicator_duration(template_context, unit)

		template_data.start_t = start_t
		template_data.end_t = start_t + (duration - duration_subtrack)
	end,
	update = function (template_data, template_context, dt, t)
		local effect_id = template_data.effect_id

		if not effect_id then
			return
		end

		local world = template_context.world
		local progress = math.clamp01(math.ilerp(template_data.start_t, template_data.end_t, t))
		local size

		if progress <= SIZE_RAMP_END then
			size = math.ease_out_quad(progress / SIZE_RAMP_END)
		else
			size = 1 - math.ease_in_quad((progress - SIZE_RAMP_END) / (1 - SIZE_RAMP_END))
		end

		local lifetime = math.lerp(LIFETIME_START, LIFETIME_END, progress)
		local size_variable = World.find_particles_variable(world, anticipation, SIZE_VARIABLE_NAME)

		World.set_particles_variable(world, effect_id, size_variable, Vector3(size, 0, 0))

		local lifetime_variable = World.find_particles_variable(world, anticipation, LIFETIME_VARIABLE_NAME)

		World.set_particles_variable(world, effect_id, lifetime_variable, Vector3(lifetime, 0, 0))
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local effect_id = template_data.effect_id

		if effect_id then
			World.stop_spawning_particles(world, effect_id)

			template_data.effect_id = nil
		end
	end,
}

function _get_indicator_duration(template_context, unit)
	local game_session = template_context.game_session
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

	if not game_object_id or not GameSession.game_object_exists(game_session, game_object_id) then
		return DEFAULT_DURATION
	end

	local duration = GameSession.game_object_field(game_session, game_object_id, INDICATOR_DURATION_FIELD)

	if not duration or duration <= 0 then
		duration = DEFAULT_DURATION
	end

	return duration
end

return effect_template
