-- chunkname: @scripts/extension_systems/locomotion/utilities/true_flight_functions/true_flight_wizard_force_ball.lua

local ProjectileLocomotion = require("scripts/extension_systems/locomotion/utilities/projectile_locomotion")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local Breed = require("scripts/utilities/breed")
local projectile_impact_results = ProjectileLocomotionSettings.impact_results
local TrueFlightWizardForceBall = {}
local _die, _move_and_check_for_collision, _modify_inital_direction, _calculate_speed, _check_collisions, _handle_collision_grace_period, _register_collision, _handle_collision_on_impact, _apply_collision, _catapult_units, _handle_recoil, _initialize_recoil, _handle_recoil_lifetime, _calculate_recoil_move_delta, _calculate_recoil_rotation, _calculate_screw_factor, _find_target_unit, _handle_recoil_stall

TrueFlightWizardForceBall.wizard_force_ball_update_towards_position = function (target_position, physics_world, integration_data, dt, t, optional_validate_impact_func, optional_on_impact_func)
	local collision_scratchpad = integration_data.collision_scratchpad
	local collision_data = collision_scratchpad.collision_data
	local sweep_hit_data = collision_scratchpad.sweep_hit
	local position, rotation

	if sweep_hit_data then
		position, rotation = _handle_recoil(t, dt, physics_world, integration_data, collision_data, sweep_hit_data)
	elseif collision_data then
		position, rotation = _handle_collision_grace_period(t, dt, integration_data, collision_data)
	else
		position, rotation = _move_and_check_for_collision(t, dt, integration_data, target_position, physics_world, optional_validate_impact_func, optional_on_impact_func)
	end

	return position, rotation
end

TrueFlightWizardForceBall.wizard_force_ball_impact_valid = function (hit_unit, integration_data)
	if hit_unit == integration_data.projectile_unit then
		return false
	end

	local is_projectile = ScriptUnit.has_extension(hit_unit, "projectile_damage_system")

	if is_projectile then
		return false
	end

	return true
end

TrueFlightWizardForceBall.wizard_forceball_target_lost = function (integration_data)
	_die(integration_data.projectile_unit, integration_data)
end

function _die(unit, integration_data)
	Managers.event:trigger("unit_died", unit)

	integration_data.integrate = false
end

local RECOIL_COLLISION_FILTER = "filter_player_character_shooting_projectile"
local HEAT_SEEKING_FACTOR = 0.6

function _handle_recoil(t, dt, physics_world, integration_data, collision_data, sweep_hit)
	local unit = integration_data.projectile_unit
	local previous_position = integration_data.position

	if not sweep_hit.initialized then
		_initialize_recoil(sweep_hit, integration_data)
	end

	_handle_recoil_lifetime(t, sweep_hit, unit, integration_data)

	local base_pos = sweep_hit.base_pos:unbox()
	local sweep_dir = sweep_hit.sweep_dir:unbox()
	local attacker_to_projectile_dir = sweep_hit.attacker_to_projectile_dir:unbox()
	local speed = sweep_hit.speed
	local hit_t = sweep_hit.hit_t
	local target_pos = sweep_hit.target_location
	local attacker_to_target = target_pos and Vector3.normalize(target_pos - base_pos)
	local direction = attacker_to_target and Vector3.lerp(attacker_to_projectile_dir, attacker_to_target, HEAT_SEEKING_FACTOR) or attacker_to_projectile_dir
	local rotation, travel_direction, rotation_offset

	speed, base_pos, travel_direction, rotation = _calculate_recoil_move_delta(t, dt, hit_t, sweep_dir, direction, speed, base_pos)
	rotation_offset = _calculate_recoil_rotation(sweep_hit, travel_direction, t, dt)

	local final_position = base_pos + rotation_offset

	sweep_hit.base_pos:store(base_pos)

	sweep_hit.speed = speed

	local velocity = dt > 0 and (final_position - previous_position) * (1 / dt) or Vector3.zero()

	integration_data.velocity = velocity

	if _handle_recoil_stall(t, sweep_hit, velocity) then
		_die(unit, integration_data)

		return previous_position, rotation
	end

	_check_collisions(physics_world, integration_data, integration_data.position, final_position, dt, t, nil, nil, _handle_collision_on_impact, RECOIL_COLLISION_FILTER)

	return final_position, rotation
end

local SPIN_RATE = 18
local MAX_OFFSET_LENGTH = 0.6
local OFFSET_DECAY = 2.2
local OFFSET_RAMP_TIME = 0.08

function _calculate_recoil_rotation(sweep_hit, travel_direction, t, dt)
	local screw = sweep_hit.screw_factor

	if screw == 0 then
		return Vector3.zero()
	end

	local angle = sweep_hit.angle + SPIN_RATE * screw * dt

	sweep_hit.angle = angle

	local side = Vector3.cross(travel_direction, Vector3.up())
	local side_length = Vector3.length(side)

	if side_length < 0.001 then
		return Vector3.zero()
	end

	side = side / side_length

	local elapsed = t - sweep_hit.hit_t
	local ramp = math.clamp01(elapsed / OFFSET_RAMP_TIME)
	local decay = math.exp(-OFFSET_DECAY * elapsed)
	local offset_length = MAX_OFFSET_LENGTH * math.abs(screw) * decay * ramp

	sweep_hit.offset_length = offset_length

	return Quaternion.rotate(Quaternion(travel_direction, angle), side) * offset_length
end

function _move_and_check_for_collision(t, dt, integration_data, target_position, physics_world, optional_validate_impact_func, optional_on_impact_func)
	local position = integration_data.position
	local velocity = integration_data.velocity
	local current_direction = Vector3.normalize(velocity)
	local true_flight_template = integration_data.true_flight_template
	local required_velocity = target_position - position
	local wanted_direction = Vector3.normalize(required_velocity)

	wanted_direction = _modify_inital_direction(t, dt, wanted_direction, integration_data, true_flight_template)

	local current_rotation = Quaternion.look(current_direction)
	local wanted_rotation = Quaternion.look(wanted_direction)
	local lerp_value = 1
	local new_rotation = Quaternion.lerp(current_rotation, wanted_rotation, lerp_value)
	local new_direction = Quaternion.forward(new_rotation)
	local speed = _calculate_speed(t, dt, integration_data, true_flight_template)
	local new_distance = speed * dt
	local new_position = position + new_direction * new_distance
	local new_velocity = new_direction * speed

	integration_data.velocity = new_velocity

	local final_rotation = Quaternion.look(velocity)

	new_position = _check_collisions(physics_world, integration_data, position, new_position, dt, t, optional_validate_impact_func, optional_on_impact_func, _register_collision, integration_data.collision_filter)

	return new_position, final_rotation
end

function _calculate_speed(t, dt, integration_data, true_flight_template)
	local highest_speed = true_flight_template.highest_speed
	local lowest_speed = true_flight_template.lowest_speed
	local initial_deceleration_duration = true_flight_template.initial_deceleration_duration
	local alpha = 1 - math.clamp01(math.ilerp(0, initial_deceleration_duration, integration_data.time_since_start))

	return math.lerp(lowest_speed, highest_speed, alpha)
end

local DOT_THRESHOLD = 0.5
local FORWARD_DIRECTIONAL_WEIGHT = 2

function _modify_inital_direction(t, dt, wanted_direction, integration_data, true_flight_template)
	local owner_unit = integration_data.owner_unit
	local time_since_start = integration_data.time_since_start
	local initial_deceleration_duration = true_flight_template.initial_deceleration_duration
	local alpha = math.clamp01(math.ilerp(0, initial_deceleration_duration, time_since_start))
	local forward

	if integration_data.is_target_below_owner == nil then
		integration_data.is_target_below_owner = Vector3.dot(wanted_direction, Vector3.down()) > DOT_THRESHOLD
	end

	if integration_data.is_target_below_owner and HEALTH_ALIVE[owner_unit] then
		forward = Quaternion.forward(Unit.local_rotation(owner_unit, 1)) * FORWARD_DIRECTIONAL_WEIGHT
	else
		forward = wanted_direction
	end

	local initial_direction = Vector3.normalize(forward + Vector3.up())

	return Vector3.lerp(initial_direction, wanted_direction, alpha)
end

local LIGHT_ATTACK_SPEED = 20
local HEAVY_ATTACK_SPEED = 30
local HIT_LIFETIME = 4

function _initialize_recoil(sweep_hit, integration_data)
	sweep_hit.speed = sweep_hit.is_light_attack and LIGHT_ATTACK_SPEED or HEAVY_ATTACK_SPEED
	sweep_hit.base_pos = Vector3Box(sweep_hit.hit_position:unbox())
	sweep_hit.angle = 0
	sweep_hit.offset_length = 0
	sweep_hit.screw_factor = _calculate_screw_factor(sweep_hit)

	local target_unit = _find_target_unit(sweep_hit.base_pos, sweep_hit.sweep_dir:unbox())

	sweep_hit.target_unit = target_unit
	sweep_hit.target_location = target_unit and Vector3Box(Unit.world_position(target_unit, 1))

	integration_data.fx_extension:reattach_vfx("spawn")

	sweep_hit.initialized = true
	integration_data.owner_unit = sweep_hit.attacker_unit

	integration_data.damage_extension:set_owner_unit(sweep_hit.attacker_unit)
	integration_data.damage_extension:set_template_state("rebounding")

	integration_data.target_unit = sweep_hit.target_unit or integration_data.target_unit
end

local MIN_SCREW_DOT = 0.15
local FULL_SCREW_DOT = 0.55

function _calculate_screw_factor(sweep_hit)
	local attacker_unit = sweep_hit.attacker_unit

	if not attacker_unit or not HEALTH_ALIVE[attacker_unit] then
		return 0
	end

	local right = Quaternion.right(Unit.local_rotation(attacker_unit, 1))
	local sweep_dir = sweep_hit.sweep_dir:unbox()
	local lateral = Vector3.dot(sweep_dir, right)
	local sign = lateral < 0 and -1 or 1
	local magnitude = math.clamp01(math.ilerp(MIN_SCREW_DOT, FULL_SCREW_DOT, math.abs(lateral)))

	return sign * magnitude
end

local broadphase_results_target = {}
local broadphase_categories_target = {
	"villains",
}
local broadphase_radius_target = 50

function _find_target_unit(position, rotation)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase

	table.clear(broadphase_results_target)
	broadphase.query(broadphase, position, broadphase_radius_target, broadphase_results_target, broadphase_categories_target)

	local target_unit
	local highest_dot_product = 0

	for _, unit in pairs(broadphase_results_target) do
		local target_pos = Unit.world_position(unit, 1)
		local direction_to_target = Vector3.normalize(target_pos - position)
		local dot_product = Vector3.dot(direction_to_target, rotation)

		if highest_dot_product < dot_product then
			highest_dot_product = dot_product
			target_unit = unit
		end
	end

	return target_unit
end

local MIN_ALLOWED_VELOCITY = 4
local STALL_DURATION = 0.25

function _handle_recoil_stall(t, sweep_hit, velocity)
	if Vector3.length(velocity) >= MIN_ALLOWED_VELOCITY then
		sweep_hit.stalled_t = nil

		return false
	end

	sweep_hit.stalled_t = sweep_hit.stalled_t or t

	return t > sweep_hit.stalled_t + STALL_DURATION
end

function _handle_recoil_lifetime(t, sweep_hit, unit, integration_data)
	if t > sweep_hit.hit_t + HIT_LIFETIME then
		_die(unit, integration_data)
	end
end

local CURVE_LOWER_THRESHOLD = 0.1
local CURVE_UPPER_THRESHOLD = 0.6
local CURVE_SPEED = 2
local SPEED_DECAY = 10
local MIN_SPEED = 10
local MAX_SPEED = 40

function _calculate_recoil_move_delta(t, dt, hit_t, sweep_dir, target_dir, speed, base_pos)
	local alpha = math.clamp((t - hit_t) * CURVE_SPEED, CURVE_LOWER_THRESHOLD, CURVE_UPPER_THRESHOLD)
	local direction = Vector3.lerp(sweep_dir, target_dir, alpha)

	speed = speed - SPEED_DECAY * dt
	speed = math.clamp(speed, MIN_SPEED, MAX_SPEED)

	local new_base_pos = base_pos + direction * speed * dt
	local rotation = Quaternion.look(direction)

	return speed, new_base_pos, direction, rotation
end

function _check_collisions(physics_world, integration_data, previus_position, new_position, dt, t, optional_validate_impact_func, optional_on_impact_func, collision_func, collision_filter)
	local true_flight_template = integration_data.true_flight_template
	local radius = integration_data.radius
	local target_unit_or_nil = integration_data.target_unit
	local have_target = target_unit_or_nil ~= nil
	local have_target_collision_filter_override = true_flight_template.have_target_collision_filter_override

	if have_target and have_target_collision_filter_override then
		collision_filter = have_target_collision_filter_override
	end

	local travel_vector = new_position - previus_position
	local travel_direction = Vector3.normalize(travel_vector)
	local travel_distance = Vector3.length(travel_vector)
	local integrator_parameters = integration_data.integrator_parameters
	local statics_radius = integrator_parameters.statics_radius
	local statics_raycast = integrator_parameters.statics_raycast
	local skip_static = false
	local hits = ProjectileLocomotion.projectile_cast(physics_world, previus_position, new_position, travel_direction, travel_distance, collision_filter, radius, skip_static, statics_radius, statics_raycast)

	if hits and #hits > 0 then
		local hit_direction = travel_direction
		local current_speed = Vector3.length(integration_data.velocity)
		local hit = hits[1]
		local hit_position = hit.position or hit[1]
		local hit_actor = hit.actor or hit[4]
		local hit_unit = Actor.unit(hit_actor)
		local is_valid_true_flight = not optional_validate_impact_func or optional_validate_impact_func(hit_unit, integration_data)
		local is_valid_collision = is_valid_true_flight and ProjectileLocomotion.check_collision(hit_unit, hit_position, integration_data)

		if is_valid_collision then
			local collision_scratchpad = integration_data.collision_scratchpad

			if have_target and target_unit_or_nil ~= hit_unit then
				-- Nothing
			end

			local is_target_unit = true
			local offset = new_position - Unit.world_position(hit_unit, 1)

			collision_func(t, collision_scratchpad, current_speed, optional_on_impact_func, integration_data, hit_actor, hit_unit, hit, is_target_unit, hit_direction, travel_direction.z, offset)
		end
	end

	return new_position
end

local GRACE_TIME = 0.8

function _register_collision(t, collision_scratchpad, current_speed, optional_on_impact_func, integration_data, hit_actor, hit_unit, hit, is_target_unit, hit_direction, z_delta, offset, skip_unlink)
	local collision_data = {}

	collision_data.time_stamp = t
	collision_data.optional_on_impact_func = optional_on_impact_func
	collision_data.speed = current_speed
	collision_data.actor = hit_actor
	collision_data.unit = hit_unit
	collision_data.hit_normal = hit.normal or hit[3]
	collision_data.is_target_unit = is_target_unit
	collision_data.position = Vector3Box(POSITION_LOOKUP[integration_data.projectile_unit])
	collision_data.travel_direction = Vector3Box(hit_direction)
	collision_data.collision_t = t
	collision_data.z_delta = z_delta
	collision_data.offset = Vector3Box(offset)
	collision_data.world = Unit.world(integration_data.projectile_unit)
	collision_scratchpad.collision_data = collision_data

	if not skip_unlink then
		integration_data.fx_extension:lerp_vfx_towards_target(hit_unit, "spawn", t + GRACE_TIME, z_delta)
	end
end

function _handle_collision_on_impact(t, collision_scratchpad, current_speed, optional_on_impact_func, integration_data, hit_actor, hit_unit, hit, is_target_unit, hit_direction, z_delta, offset)
	_register_collision(t, collision_scratchpad, current_speed, optional_on_impact_func, integration_data, hit_actor, hit_unit, hit, is_target_unit, hit_direction, z_delta, offset, true)
	_apply_collision(collision_scratchpad.collision_data, collision_scratchpad.sweep_hit, integration_data, t)
end

function _handle_collision_grace_period(t, dt, integration_data, collision_data)
	if not HEALTH_ALIVE[collision_data.unit] then
		_die(collision_data.unit, integration_data)

		return integration_data.position, Quaternion.identity()
	end

	local old_pos = integration_data.position
	local pos

	if t > collision_data.time_stamp + GRACE_TIME then
		pos = _apply_collision(collision_data, integration_data.collision_scratchpad.sweep_hit, integration_data, t)
	else
		local target_unit_pos = POSITION_LOOKUP[collision_data.unit]
		local offset = collision_data.offset:unbox()

		pos = target_unit_pos + offset
	end

	return pos, Quaternion.look(pos - old_pos)
end

function _apply_collision(collision_data, sweep_hit, integration_data, t)
	local is_target_unit = collision_data.is_target_unit
	local hit_direction = collision_data.travel_direction:unbox()
	local current_speed = collision_data.speed
	local damage_extension = integration_data.damage_extension
	local fx_extension = integration_data.fx_extension
	local hit_position = collision_data.position:unbox()
	local hit_actor = collision_data.actor
	local hit_unit = collision_data.unit
	local hit_normal = collision_data.normal
	local new_position

	integration_data.has_hit = true

	local force_delete = false

	new_position = hit_position

	local impact_result

	if damage_extension then
		impact_result = damage_extension:on_impact(hit_position, hit_unit, hit_actor, hit_direction, hit_normal, current_speed, force_delete, is_target_unit)

		local catapult_data = integration_data.damage_extension._projectile_template.catapult_data

		if sweep_hit and sweep_hit.initialized and catapult_data then
			_catapult_units(hit_position, catapult_data.CATEGORIES, catapult_data.RADIUS, catapult_data.FORCE, catapult_data.Z_FORCE)
		end
	end

	if fx_extension then
		fx_extension:on_impact(hit_position, hit_actor, hit_direction, hit_normal, current_speed)
	end

	if impact_result == projectile_impact_results.removed then
		integration_data.integrate = false
	end

	return new_position
end

local broadphase_results_catapult = {}

function _catapult_units(position, categories, radius, FORCE, Z_FORCE)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase

	table.clear(broadphase_results_catapult)
	broadphase.query(broadphase, position, radius, broadphase_results_catapult, categories)

	for _, unit in pairs(broadphase_results_catapult) do
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
		local can_be_catapulted = unit_data_extension and Breed.is_player(unit_data_extension:breed())

		if can_be_catapulted then
			local new_direction = Vector3.normalize(Vector3.flat(POSITION_LOOKUP[unit] - position))
			local catapult_force = FORCE
			local catapult_z_force = Z_FORCE
			local velocity = new_direction * catapult_force

			velocity.z = catapult_z_force

			local catapulted_state_input = unit_data_extension:write_component("catapulted_state_input")

			Catapulted.apply(catapulted_state_input, velocity)
		end
	end
end

return TrueFlightWizardForceBall
