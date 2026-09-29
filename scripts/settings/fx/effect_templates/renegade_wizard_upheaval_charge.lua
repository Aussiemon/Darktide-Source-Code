-- chunkname: @scripts/settings/fx/effect_templates/renegade_wizard_upheaval_charge.lua

local VFX = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_warp_proj_warpy_big"
local BreedActions = require("scripts/settings/breed/breed_actions")
local action_data = BreedActions.renegade_wizard
local resources = {}
local _create_particles, _stop_spawning_particles
local uptime = action_data.upheaval.effect_lerp_duration
local effect_template = {
	name = "renegade_wizard_upheaval_charge",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		template_data.game_object_id = game_object_id
		template_data.lerp_percentage = 0

		local pps = uptime / 100

		template_data.pps = pps
	end,
	update = function (template_data, template_context, dt, t)
		local game_object_id = template_data.game_object_id
		local game_session = template_context.game_session
		local from_position = GameSession.game_object_field(game_session, game_object_id, "from_position")

		template_data.from_position = from_position

		local to_position = GameSession.game_object_field(game_session, game_object_id, "to_position")

		template_data.to_position = to_position

		if from_position and to_position then
			if not template_data.effect_started then
				_create_particles(template_data, template_context)

				template_data.effect_started = true
				template_data.lerp_time = 0
				template_data.lerp_duration = uptime

				return
			end

			template_data.lerp_time = template_data.lerp_time + dt

			if template_data.effect_id and not template_data.lerp_finished then
				local percentage = math.min(template_data.lerp_time / template_data.lerp_duration, 1)
				local new_pos = Vector3.lerp(to_position, from_position, percentage)
				local world = template_context.world

				World.move_particles(world, template_data.effect_id, new_pos)

				if percentage >= 1 then
					template_data.lerp_finished = true
				end
			end
		end
	end,
	stop = function (template_data, template_context)
		_stop_spawning_particles(template_data, template_context)
	end,
}

function _create_particles(template_data, template_context)
	local world = template_context.world
	local effect_id = World.create_particles(world, VFX, template_data.from_position)

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
