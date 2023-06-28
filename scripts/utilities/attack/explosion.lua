local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local AttackingUnitResolver = require("scripts/utilities/attack/attacking_unit_resolver")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionDeath = require("scripts/utilities/minion_death")
local Suppression = require("scripts/utilities/attack/suppression")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local attack_types = AttackSettings.attack_types
local proc_events = BuffSettings.proc_events
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local DEFALT_FALLBACK_LERP_VALUE = WeaponTweakTemplateSettings.DEFALT_FALLBACK_LERP_VALUE
local HIT_DISTANCE_EPSILON = 0.001
local Explosion = {}
local _get_radii, _play_effects = nil
local hit_units = {}

Explosion.create_explosion = function (world, physics_world, source_position, optional_impact_normal, attacking_unit, explosion_template, power_level, charge_level, attack_type, is_critical_strike, ignore_cover, item_or_nil, origin_slot_or_nil, optional_attack_result_table)
	power_level = explosion_template.static_power_level or power_level

	Managers.server_metrics:add_annotation("explosion_create", {
		power_level = power_level
	})

	local attacking_unit_owner_unit = AttackingUnitResolver.resolve(attacking_unit)
	local attacking_owner_buff_extension = ScriptUnit.has_extension(attacking_unit_owner_unit, "buff_system")
	local attacker_owner_stat_buffs = attacking_owner_buff_extension and attacking_owner_buff_extension:stat_buffs()
	local attacker_unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
	local attacker_breed_or_nil = attacker_unit_data_extension and attacker_unit_data_extension:breed()
	local lerp_values = Explosion.lerp_values(attacking_unit, explosion_template.name)
	local t = FixedFrame.get_latest_fixed_time()
	local collision_filter = explosion_template.collision_filter
	local radius, close_radius = _get_radii(explosion_template, charge_level, lerp_values, attack_type, attacker_owner_stat_buffs, attacker_breed_or_nil)
	local hit_actors, num_actors = PhysicsWorld.immediate_overlap(physics_world, "position", source_position, "size", radius, "shape", "sphere", "types", "both", "collision_filter", collision_filter)
	local override_friendly_fire = explosion_template.override_friendly_fire
	local side_system = Managers.state.extension:system("side_system")

	table.clear(hit_units)

	local number_of_hit_units = 0

	for i = 1, num_actors do
		local hit_actor = hit_actors[i]
		local hit_unit = Actor.unit(hit_actor)

		if hit_unit ~= attacking_unit_owner_unit or override_friendly_fire then
			local damage_allowed = side_system and not side_system:is_ally(attacking_unit_owner_unit, hit_unit) or override_friendly_fire

			if damage_allowed then
				local hit_position = Unit.world_position(hit_unit, Actor.node(hit_actor))
				local direction = Vector3.normalize(hit_position - source_position)
				local hit_zone_or_nil = HitZone.get(hit_unit, hit_actor)
				local hit_zone_name_or_nil = hit_zone_or_nil and hit_zone_or_nil.name
				local has_health = ScriptUnit.has_extension(hit_unit, "health_system")
				local hit_distance = Vector3.distance(source_position, hit_position)
				local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
				local breed_or_nil = unit_data_extension and unit_data_extension:breed()

				if breed_or_nil and breed_or_nil.explosion_radius then
					hit_distance = math.max(hit_distance - breed_or_nil.explosion_radius, 0)
				end

				local close_hit = close_radius > 0 and hit_distance < close_radius

				if Health.is_ragdolled(hit_unit) and not hit_units[hit_unit] then
					if close_hit then
						MinionDeath.attack_ragdoll(hit_unit, direction, explosion_template.close_damage_profile, nil, hit_zone_name_or_nil, nil, nil)
					else
						MinionDeath.attack_ragdoll(hit_unit, direction, explosion_template.damage_profile, nil, hit_zone_name_or_nil, nil, nil)
					end

					hit_units[hit_unit] = true
				elseif not hit_units[hit_unit] then
					local is_valid_target = not hit_zone_or_nil or hit_zone_or_nil.name == HitZone.hit_zone_names.center_mass

					if is_valid_target and has_health then
						local intervening_cover = false
						local cover_actor, _ = nil

						if not ignore_cover and HIT_DISTANCE_EPSILON < hit_distance then
							intervening_cover, _, _, _, cover_actor = PhysicsWorld.raycast(physics_world, hit_position, -direction, 0.95 * hit_distance, "closest", "types", "statics", "collision_filter", "filter_explosion_cover")
						end

						if intervening_cover and cover_actor then
							local cover_unit = Actor.unit(cover_actor)
							local cover_has_health = ScriptUnit.has_extension(cover_unit, "health_system")
							intervening_cover = not cover_has_health
						end

						local valid_target = true

						if Breed.is_prop(breed_or_nil) then
							valid_target = close_hit
						end

						if valid_target and not intervening_cover then
							hit_units[hit_unit] = true
							local damage_profile, damage_type = nil

							if close_hit then
								damage_profile = explosion_template.close_damage_profile
								damage_type = explosion_template.close_damage_type
							else
								damage_profile = explosion_template.damage_profile
								damage_type = explosion_template.damage_type
							end

							local dropoff_scalar = false

							if not close_hit and explosion_template.damage_falloff then
								dropoff_scalar = (hit_distance - close_radius) / (radius - close_radius)
								dropoff_scalar = math.clamp(dropoff_scalar * dropoff_scalar, 0, 1)
							end

							if HEALTH_ALIVE[hit_unit] then
								number_of_hit_units = number_of_hit_units + 1
							end

							local _, attack_result = Attack.execute(hit_unit, damage_profile, "power_level", power_level, "charge_level", charge_level, "attack_direction", direction, "dropoff_scalar", dropoff_scalar, "hit_zone_name", hit_zone_name_or_nil, "hit_actor", hit_actor, "attack_type", attack_type, "attacking_unit", attacking_unit, "damage_type", damage_type, "is_critical_strike", is_critical_strike, "item", item_or_nil, "hit_world_position", source_position)

							if optional_attack_result_table then
								optional_attack_result_table[hit_unit] = attack_result
							end

							local on_hit_buff_template_name = explosion_template.on_hit_buff_template_name

							if on_hit_buff_template_name and HEALTH_ALIVE[hit_unit] then
								local enemy_buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

								if enemy_buff_extension then
									enemy_buff_extension:add_internally_controlled_buff(on_hit_buff_template_name, t, "owner_unit", attacking_unit_owner_unit, "source_item", item_or_nil)
								end
							end
						end
					end
				end
			end
		end
	end

	if attacking_owner_buff_extension then
		local param_table = attacking_owner_buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.number_of_hit_units = number_of_hit_units
			param_table.attacking_unit = attacking_unit_owner_unit
			param_table.attack_instigator_unit = attacking_unit
			param_table.item_slot_origin = origin_slot_or_nil
			param_table.charge_level = charge_level

			attacking_owner_buff_extension:add_proc_event(proc_events.on_explosion_hit, param_table)
		end
	end

	local suppression_settings = explosion_template.explosion_area_suppression

	if suppression_settings and attacking_unit_owner_unit then
		local optional_relation = suppression_settings.relation
		local optional_include_self = suppression_settings.include_self
		local progressed_lerp_values = DamageProfile.progress_lerp_values_path(lerp_values, "explosion_area_suppression")

		Suppression.apply_area_explosion_suppression(attacking_unit_owner_unit, suppression_settings, source_position, optional_relation, optional_include_self, progressed_lerp_values)
	end

	_play_effects(world, attacking_unit_owner_unit, explosion_template, charge_level, source_position, optional_impact_normal, radius)
end

local NO_LERP_VALUES = {}

Explosion.lerp_values = function (attacking_unit, explosion_template_name_or_nil)
	local weapon_extension = ScriptUnit.has_extension(attacking_unit, "weapon_system")

	if not weapon_extension then
		return NO_LERP_VALUES
	end

	local lerp_values = weapon_extension:explosion_template_lerp_values(explosion_template_name_or_nil)

	return lerp_values
end

local EMPTY_PATH = {
	[DEFAULT_LERP_VALUE] = 0
}

Explosion.lerp_value_from_path = function (lerp_values, ...)
	local default_lerp_value_or_nil = lerp_values[DEFAULT_LERP_VALUE]
	local local_lerp_values = lerp_values
	local depth = select("#", ...)

	for i = 1, depth - 1 do
		local id = select(i, ...)
		local_lerp_values = local_lerp_values[id] or EMPTY_PATH
	end

	local last_id = select(depth, ...)
	local lerp_value = local_lerp_values[last_id] or default_lerp_value_or_nil or DEFALT_FALLBACK_LERP_VALUE

	return lerp_value
end

Explosion.lerp_entry = function (entry, lerp_value)
	local min = entry[1]
	local max = entry[2]
	local t = lerp_value

	return math.lerp(min, max, t)
end

function _get_radii(explosion_template, charge_level, lerp_values, attack_type, attacker_stat_buffs, attacker_breed_or_nil)
	local radius, close_radius = nil

	if not explosion_template.scalable_radius then
		charge_level = 1
	end

	local explosion_template_radius = explosion_template.radius

	if type(explosion_template_radius) == "table" then
		local lerp_value = Explosion.lerp_value_from_path(lerp_values, "radius")
		explosion_template_radius = Explosion.lerp_entry(explosion_template_radius, lerp_value)
	end

	local min_radius = explosion_template.min_radius

	if min_radius then
		if type(min_radius) == "table" then
			local lerp_value = Explosion.lerp_value_from_path(lerp_values, "min_radius")
			min_radius = Explosion.lerp_entry(min_radius, lerp_value)
		end

		radius = math.lerp(min_radius, explosion_template_radius, charge_level)
	else
		radius = explosion_template_radius * charge_level
	end

	local explosion_template_close_radius = explosion_template.close_radius

	if type(explosion_template_close_radius) == "table" then
		local lerp_value = Explosion.lerp_value_from_path(lerp_values, "close_radius")
		explosion_template_close_radius = Explosion.lerp_entry(explosion_template_close_radius, lerp_value)
	end

	if explosion_template_close_radius then
		local min_close_radius = explosion_template.min_close_radius

		if min_close_radius then
			if type(min_close_radius) == "table" then
				local lerp_value = Explosion.lerp_value_from_path(lerp_values, "min_close_radius")
				min_close_radius = Explosion.lerp_entry(min_close_radius, lerp_value)
			end

			close_radius = math.lerp(min_close_radius, explosion_template_close_radius, charge_level)
		else
			close_radius = explosion_template_close_radius * charge_level
		end
	else
		close_radius = 0
	end

	return radius, close_radius
end

function _play_effects(world, attacking_unit, explosion_template, charge_level, source_position, optional_impact_normal, radius)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local fx_extension = player_unit_spawn_manager:owner(attacking_unit) and ScriptUnit.extension(attacking_unit, "fx_system")
	local rotation = optional_impact_normal and Quaternion.look(optional_impact_normal) or Quaternion.identity()
	local fx_system = Managers.state.extension:system("fx_system")
	local charge_wwise_parameter_name = explosion_template.charge_wwise_parameter_name
	local scalable_vfx = explosion_template.scalable_vfx
	local vfx = explosion_template.vfx

	if scalable_vfx then
		for i = #scalable_vfx, 1, -1 do
			local vfx_data = scalable_vfx[i]
			local min_radius = vfx_data.min_radius

			if min_radius < radius then
				local effects = vfx_data.effects
				local num_effects = #effects

				for j = 1, num_effects do
					local effect_name = effects[j]

					if fx_extension and fx_extension.spawn_particles then
						local scale = nil
						local radius_variable_name = vfx_data.radius_variable_name

						fx_extension:spawn_particles(effect_name, source_position, rotation, scale, radius_variable_name, Vector3(radius, radius, radius))
					else
						fx_system:trigger_vfx(effect_name, source_position, rotation)
					end
				end

				break
			end
		end
	elseif vfx then
		local num_vfx = #explosion_template.vfx

		for i = 1, num_vfx do
			local effect_name = vfx[i]

			if fx_extension and fx_extension.spawn_particles then
				fx_extension:spawn_particles(effect_name, source_position, rotation)
			else
				fx_system:trigger_vfx(effect_name, source_position, rotation)
			end
		end
	end

	local sfx = explosion_template.sfx

	if sfx then
		local num_sfx = #sfx

		for i = 1, num_sfx do
			local event_name_or_table = sfx[i]

			if type(event_name_or_table) == "string" then
				fx_system:trigger_wwise_event(event_name_or_table, source_position, nil, nil, charge_wwise_parameter_name, charge_level)
			else
				local event_name = event_name_or_table.event_name

				if fx_extension then
					local has_husk_events = event_name_or_table.has_husk_events

					fx_extension:trigger_wwise_event_server_controlled(event_name, has_husk_events, source_position, charge_wwise_parameter_name, charge_level)
				else
					fx_system:trigger_wwise_event(event_name_or_table, source_position, nil, nil, charge_wwise_parameter_name, charge_level)
				end
			end
		end
	end
end

return Explosion
