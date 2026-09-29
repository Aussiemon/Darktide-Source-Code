-- chunkname: @scripts/settings/fx/effect_templates/renegade_wizard_boss_teleport.lua

local MinionDissolveUtility = require("scripts/extension_systems/scripted_scenario/minion_dissolve_utility")
local VFX = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_teleport_trail"
local DIS_VFX = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_teleport_dissipate"
local resources = {
	"content/fx/particles/enemies/renegade_wizard/renegade_wizard_teleport_trail",
	"content/fx/particles/enemies/renegade_wizard/renegade_wizard_teleport_dissipate",
}
local SFX = {
	wwise_teleport_in = "wwise/events/minions/play_enemy_psyker_teleport_out",
	wwise_teleport_out = "wwise/events/minions/play_enemy_psyker_teleport_in",
}
local DISSOLVE_OUT_DURATION = 0.7666666666666667
local DISSOLVE_IN_DURATION = 0.7666666666666667
local DISSOLVE_DELAY = 1.3
local TOXIN_GREEN_HSV = Vector3Box(0.15, 0.5, 0)
local _create_particles, _stop_spawning_particles, _start_dissolve, _update_dissolve, _set_dissolve_shield
local uptime = 1
local height_offset = 3
local effect_template = {
	name = "renegade_wizard_boss_teleport",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local t = Managers.time:time("gameplay")

		template_data.dissolve_delay_t = t + DISSOLVE_DELAY
		template_data.game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		template_data.lerp_time = 0
		template_data.phase = "dissolving_out"

		if template_context.is_server then
			local fx_system = Managers.state.extension:system("fx_system")
			local position = Unit.world_position(unit, 1)

			fx_system:trigger_wwise_event(SFX.wwise_teleport_in, position)
		end
	end,
	update = function (template_data, template_context, dt, t)
		local unit = template_data.unit
		local game_object_id = template_data.game_object_id
		local game_session = template_context.game_session
		local phase = template_data.phase

		if template_data.dissolve_delay_t and t < template_data.dissolve_delay_t then
			return
		elseif not template_data.init_start_dissolve then
			template_data.init_start_dissolve = true
			template_data.dissolve_data = _start_dissolve(unit, t, false, DISSOLVE_OUT_DURATION, template_data, template_context)
		end

		if phase == "dissolving_out" then
			_update_dissolve(unit, template_data.dissolve_data, t)
			_set_dissolve_shield(template_data, template_context, true)

			local unit_moved = GameSession.game_object_field(game_session, game_object_id, "teleport_unit_moved")

			if unit_moved then
				Unit.set_unit_visibility(unit, false, true)

				template_data.phase = "traveling"
			end

			return
		end

		if phase == "traveling" then
			local from_pos_raw = GameSession.game_object_field(game_session, game_object_id, "from_position")
			local to_pos_raw = GameSession.game_object_field(game_session, game_object_id, "to_position")

			if not from_pos_raw or not to_pos_raw then
				return
			end

			if not template_data.effect_started then
				local start_pos = from_pos_raw + Vector3(0, 0, 2.5)
				local end_pos = to_pos_raw + Vector3(0, 0, 1.5)

				template_data.start_pos_box = Vector3Box(start_pos)
				template_data.end_pos_box = Vector3Box(end_pos)

				local mid_point = (start_pos + end_pos) * 0.5
				local cp_z = end_pos.z < start_pos.z and start_pos.z + height_offset or math.max(start_pos.z, end_pos.z) + height_offset

				template_data.control_point_box = Vector3Box(Vector3(mid_point.x, mid_point.y, cp_z))

				_create_particles(template_data, template_context, start_pos, VFX)

				template_data.effect_started = true

				return
			end

			template_data.lerp_time = template_data.lerp_time + dt

			if template_data.effect_id then
				local linear_t = math.min(template_data.lerp_time / uptime, 1)
				local t_pct = math.smoothstep(linear_t, 0, 1)
				local p0 = template_data.start_pos_box:unbox()
				local p1 = template_data.control_point_box:unbox()
				local p2 = template_data.end_pos_box:unbox()
				local inv_t = 1 - t_pct
				local final_position = p0 * (inv_t * inv_t) + p1 * (2 * inv_t * t_pct) + p2 * (t_pct * t_pct)

				World.move_particles(template_context.world, template_data.effect_id, final_position)

				if template_context.is_server and linear_t >= 0.8 and not template_data.sfx_played then
					template_data.sfx_played = true

					local fx_system = Managers.state.extension:system("fx_system")
					local position = Unit.world_position(unit, 1)

					fx_system:trigger_wwise_event(SFX.wwise_teleport_in, position)
				end

				if linear_t >= 1 then
					Unit.set_unit_visibility(unit, true, true)

					template_data.dissolve_data = _start_dissolve(unit, t, true, DISSOLVE_IN_DURATION, template_data, template_context)
					template_data.phase = "dissolving_in"

					_stop_spawning_particles(template_data, template_context)

					if template_context.is_server then
						GameSession.set_game_object_field(game_session, game_object_id, "teleport_position_reached", true)
					end

					_set_dissolve_shield(template_data, template_context, false)
				end
			end

			return
		end

		if phase == "dissolving_in" then
			if not template_data.dissolve_finished then
				local is_done = _update_dissolve(unit, template_data.dissolve_data, t)

				if is_done then
					template_data.dissolve_finished = true
				end
			end

			return
		end
	end,
	stop = function (template_data, template_context)
		_stop_spawning_particles(template_data, template_context)

		local unit = template_data.unit

		if unit and Unit.alive(unit) then
			if not template_data.dissolve_finished then
				MinionDissolveUtility.restore_solid(unit, template_data.dissolve_data)
			end

			Unit.set_unit_visibility(unit, true, true)
			_set_dissolve_shield(template_data, template_context, false)
		end
	end,
}

function _set_dissolve_shield(template_data, template_context, state)
	if not template_context.is_server or template_data.shield_dissolving == state then
		return
	end

	template_data.shield_dissolving = state

	GameSession.set_game_object_field(template_context.game_session, template_data.game_object_id, "dissolve_shield", state)
end

function _start_dissolve(unit, t, reverted, duration, template_data, template_context)
	local dissolve_data = MinionDissolveUtility.start_dissolve(unit, t, reverted, TOXIN_GREEN_HSV:unbox())

	if dissolve_data then
		dissolve_data.duration = duration
		dissolve_data.done_t = t + duration

		dissolve_data.wound.shape_mask_uv_offset:store(Vector2(0.5, 0.75))

		local uv_offset = Vector3(0.5, 0.75, 0)

		Unit.set_vector3_for_materials(unit, "shape_mask_uv_offset", uv_offset, true)

		if not DEDICATED_SERVER then
			local flesh_unit = dissolve_data.visual_loadout_extension:slot_unit("slot_flesh")

			if flesh_unit and Unit.alive(flesh_unit) then
				Unit.set_unit_visibility(flesh_unit, false, true)
			end

			local sequence_direction = reverted and "top_down" or "bottom_up"
			local sequence_duration = duration / 2
			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:start_sequence(unit, "wizard_vanish", sequence_direction, sequence_duration)
		end
	end

	return dissolve_data
end

function _update_dissolve(unit, dissolve_data, t)
	if not dissolve_data then
		return true
	end

	local is_done = MinionDissolveUtility.update_dissolve(unit, dissolve_data, t)
	local chest_node = Unit.has_node(unit, "j_spine") and Unit.node(unit, "j_spine") or 1
	local chest_local_pos = Unit.local_position(unit, chest_node)

	Unit.set_vector3_for_materials(unit, "wound_position_01", chest_local_pos, true)

	return is_done
end

function _create_particles(template_data, template_context, pos, name)
	template_data.effect_id = World.create_particles(template_context.world, name, pos)
end

function _stop_spawning_particles(template_data, template_context)
	local effect_id = template_data.effect_id

	if effect_id then
		World.stop_spawning_particles(template_context.world, effect_id)

		template_data.effect_id = nil
	end
end

return effect_template
