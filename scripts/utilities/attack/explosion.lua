-- chunkname: @scripts/utilities/attack/explosion.lua

local AttackingUnitResolver = require("scripts/utilities/attack/attacking_unit_resolver")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CameraShake = require("scripts/utilities/camera/camera_shake")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local Health = require("scripts/utilities/health")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MaterialQuery = require("scripts/utilities/material_query")
local MinionDeath = require("scripts/utilities/minion_death")
local Suppression = require("scripts/utilities/attack/suppression")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local attack_types = AttackSettings.attack_types
local proc_events = BuffSettings.proc_events
local DEFAULT_LERP_VALUE = WeaponTweakTemplateSettings.DEFAULT_LERP_VALUE
local DEFALT_FALLBACK_LERP_VALUE = WeaponTweakTemplateSettings.DEFALT_FALLBACK_LERP_VALUE
local Explosion = {}
local _play_effects, _play_husk_effects
local hit_units = {}
local broadphase_results = {}
local destructible_broadphase_results = {}
local attack_units_distance_sq = {}
local attack_units_hit_actors = {}
local attack_units_array = {}
local generic_broadphase_filter = {
	"heroes",
	"villains",
	"destructibles",
}
local destructibles_only_filter = {
	"destructibles",
}

Explosion.create_explosion = function (world, physics_world, source_position, optional_impact_normal, attacking_unit, explosion_template, power_level, charge_level, attack_type, is_critical_strike, ignore_cover, item_or_nil, origin_slot_or_nil, optional_hit_units_table, optional_attacking_unit_owner_unit, optional_apply_owner_buffs, predicted)
	local attacking_unit_owner_unit = AttackingUnitResolver.resolve(attacking_unit)
	local attacking_owner_buff_extension = ScriptUnit.has_extension(attacking_unit_owner_unit, "buff_system")
	local attacker_owner_stat_buffs = attacking_owner_buff_extension and attacking_owner_buff_extension:stat_buffs()
	local attacker_unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
	local attacker_breed_or_nil = attacker_unit_data_extension and attacker_unit_data_extension:breed()
	local lerp_values = Explosion.lerp_values(attacking_unit, explosion_template.name)
	local radius, close_radius = Explosion.radii(explosion_template, charge_level, lerp_values, attack_type, attacker_owner_stat_buffs, attacker_breed_or_nil)
	local is_server = Managers.state.game_session:is_server()

	if is_server then
		local rotation = optional_impact_normal and Quaternion.look(optional_impact_normal) or Quaternion.identity()
		local attacking_unit_owner_unit_id = attacking_unit_owner_unit and Managers.state.unit_spawner:game_object_id(attacking_unit_owner_unit) or nil

		Managers.state.game_session:send_rpc_clients("rpc_trigger_husk_explosion", NetworkLookup.explosion_templates[explosion_template.name], source_position, rotation, Vector3(radius, close_radius, radius), charge_level or 1, attacking_unit_owner_unit_id)

		if not DEDICATED_SERVER then
			local wwise_world = Managers.world:wwise_world(world)

			Explosion.create_husk_explosion(world, physics_world, wwise_world, attacking_unit_owner_unit, explosion_template, source_position, rotation, Vector3(radius, close_radius, radius), charge_level or 1)
		end
	end

	if not is_server then
		return
	end

	if explosion_template.scaled_power_level then
		power_level = Managers.state.difficulty:get_table_entry_by_challenge(explosion_template.scaled_power_level)
	else
		power_level = explosion_template.static_power_level or power_level
	end

	Managers.server_metrics:add_annotation("explosion_create", {
		power_level = power_level,
	})

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local num_hits = 0
	local destructibles_num_hits = 0
	local broadphase_categories = explosion_template.broadphase_explosion_filter or generic_broadphase_filter
	local target_destructibles = table.index_of(broadphase_categories, "destructibles")

	if target_destructibles >= 1 then
		broadphase_categories = table.shallow_copy(broadphase_categories)

		table.swap_delete(broadphase_categories, target_destructibles)
	end

	num_hits = broadphase.query(broadphase, source_position, radius, broadphase_results, broadphase_categories)

	if close_radius > 0 and target_destructibles then
		destructibles_num_hits = broadphase.query(broadphase, source_position, close_radius, destructible_broadphase_results, destructibles_only_filter)
	end

	local weapon_system = Managers.state.extension:system("weapon_system")
	local queue_index, data = weapon_system:prepare_queued_explosion()
	local template_friendly_fire_override = explosion_template.override_friendly_fire
	local friendly_fire_override = template_friendly_fire_override
	local side_system = Managers.state.extension:system("side_system")

	table.clear(hit_units)
	table.clear(attack_units_distance_sq)
	table.clear(attack_units_array)
	table.clear(attack_units_hit_actors)

	local number_of_attack_units = 0
	local sticking_to_unit, sticking_to_actor, _
	local locomotion_extension = ScriptUnit.has_extension(attacking_unit, "locomotion_system")

	if locomotion_extension and locomotion_extension.sticking_to_unit then
		sticking_to_unit, _, sticking_to_actor = locomotion_extension:sticking_to_unit()

		if sticking_to_unit and sticking_to_actor then
			hit_units[sticking_to_unit] = true
			number_of_attack_units = number_of_attack_units + 1
			attack_units_array[number_of_attack_units] = sticking_to_unit

			local center_mass_actor_names = HitZone.get_actor_names(sticking_to_unit, HitZone.hit_zone_names.center_mass)
			local center_mass_actor_name = center_mass_actor_names and center_mass_actor_names[1]
			local center_mass_actor = center_mass_actor_name and Unit.actor(sticking_to_unit, center_mass_actor_name)

			attack_units_hit_actors[sticking_to_unit] = center_mass_actor or sticking_to_actor
			attack_units_distance_sq[sticking_to_unit] = 0
		end
	end

	for i = 1, num_hits do
		local hit_unit = broadphase_results[i]

		if not hit_units[hit_unit] then
			local hit_actor
			local center_mass_actor_names = HitZone.get_actor_names(hit_unit, HitZone.hit_zone_names.center_mass)

			if center_mass_actor_names then
				local center_mass_actor_name = center_mass_actor_names[1]

				hit_actor = center_mass_actor_name and Unit.actor(hit_unit, center_mass_actor_name)
			else
				local destructible_actor_index = Unit.find_actor(hit_unit, "c_destructible") or 1

				hit_actor = Unit.actor(hit_unit, destructible_actor_index)
			end

			local hit_zone_or_nil = HitZone.get(hit_unit, hit_actor)
			local is_ragdolled = Health.is_ragdolled(hit_unit)
			local is_valid_target = is_ragdolled or hit_actor

			if not hit_actor then
				Log.error("Explosion", string.format("Explosion hit a unit without a suitable actor (unit: %s)", hit_unit))

				is_valid_target = false
			end

			if is_valid_target then
				hit_units[hit_unit] = true

				if hit_unit ~= attacking_unit_owner_unit or friendly_fire_override then
					local damage_allowed = friendly_fire_override or side_system and not side_system:is_ally(attacking_unit_owner_unit, hit_unit)
					local has_health = ScriptUnit.has_extension(hit_unit, "health_system")

					if damage_allowed and has_health then
						attack_units_distance_sq[hit_unit] = Vector3.distance_squared(source_position, Actor.position(hit_actor))
						attack_units_hit_actors[hit_unit] = hit_actor
						number_of_attack_units = number_of_attack_units + 1
						attack_units_array[number_of_attack_units] = hit_unit

						if optional_hit_units_table then
							optional_hit_units_table[hit_unit] = true
						end
					end
				end
			end
		end
	end

	for i = 1, destructibles_num_hits do
		local hit_unit = destructible_broadphase_results[i]

		if not hit_units[hit_unit] then
			local hit_actor
			local center_mass_actor_names = HitZone.get_actor_names(hit_unit, HitZone.hit_zone_names.center_mass)

			if center_mass_actor_names then
				local center_mass_actor_name = center_mass_actor_names[1]

				hit_actor = center_mass_actor_name and Unit.actor(hit_unit, center_mass_actor_name)
			else
				local destructible_actor_index = Unit.find_actor(hit_unit, "c_destructible") or 1

				hit_actor = Unit.actor(hit_unit, destructible_actor_index)
			end

			local hit_zone_or_nil = HitZone.get(hit_unit, hit_actor)
			local is_ragdolled = Health.is_ragdolled(hit_unit)
			local is_valid_target = is_ragdolled or hit_actor

			if not hit_actor then
				Log.error("Explosion", string.format("Explosion hit a destructible unit without a suitable actor (unit: %s)", hit_unit))
			end

			if is_valid_target then
				hit_units[hit_unit] = true

				if hit_unit ~= attacking_unit_owner_unit or friendly_fire_override then
					local damage_allowed = friendly_fire_override or side_system and not side_system:is_ally(attacking_unit_owner_unit, hit_unit)
					local has_health = ScriptUnit.has_extension(hit_unit, "health_system")

					if damage_allowed and has_health then
						attack_units_distance_sq[hit_unit] = Vector3.distance_squared(source_position, Actor.position(hit_actor))
						attack_units_hit_actors[hit_unit] = hit_actor
						number_of_attack_units = number_of_attack_units + 1
						attack_units_array[number_of_attack_units] = hit_unit

						if optional_hit_units_table then
							optional_hit_units_table[hit_unit] = true
						end
					end
				end
			end
		end
	end

	for i = 1, number_of_attack_units do
		local strided_i = (i - 1) * 2
		local attack_unit = attack_units_array[i]

		data[strided_i + 1] = attack_unit
		data[strided_i + 2] = attack_units_hit_actors[attack_unit]
	end

	data.num_hit_units = number_of_attack_units

	local x, y, z = Vector3.to_elements(source_position)

	data.source_position_x = x
	data.source_position_y = y
	data.source_position_z = z
	data.radius = radius
	data.close_radius = close_radius
	data.explosion_template = explosion_template
	data.ignore_cover = ignore_cover
	data.power_level = power_level
	data.charge_level = charge_level
	data.attack_type = attack_type
	data.attacking_unit = attacking_unit
	data.attacking_unit_owner_unit = attacking_unit_owner_unit
	data.is_critical_strike = is_critical_strike
	data.item_or_nil = item_or_nil
	data.sticking_to_unit = sticking_to_unit
	data.optional_attacking_unit_owner_unit = optional_attacking_unit_owner_unit
	data.optional_apply_owner_buffs = optional_apply_owner_buffs

	if attacking_owner_buff_extension then
		local param_table = attacking_owner_buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.number_of_hit_units = number_of_attack_units
			param_table.attacking_unit = attacking_unit_owner_unit
			param_table.attack_instigator_unit = attacking_unit
			param_table.item_slot_origin = origin_slot_or_nil
			param_table.charge_level = charge_level
			param_table.weapon_special = explosion_template.weapon_special

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

	return queue_index, number_of_attack_units
end

Explosion.create_husk_explosion = function (world, physics_world, wwise_world, attacking_owner_unit_or_nil, explosion_template, position, rotation, radius_variables, charge_level)
	local explosion_template_name = explosion_template.name
	local radius = radius_variables.x
	local close_radius = radius_variables.y
	local close_radius_squared = close_radius * close_radius

	_play_husk_effects(world, physics_world, wwise_world, attacking_owner_unit_or_nil, explosion_template, charge_level, position, rotation, radius)

	local attack_ragdolls_enabled_locally = Application.user_setting("gore_settings", "attack_ragdolls_enabled")

	if attack_ragdolls_enabled_locally and not explosion_template.skip_ragdoll_interaction then
		table.clear(hit_units)

		local number_of_attack_units = 0
		local collision_filter = "filter_player_character_husk_explosion"
		local hit_actors, num_actors = PhysicsWorld.immediate_overlap(physics_world, "position", position, "size", radius, "shape", "sphere", "types", "both", "collision_filter", collision_filter)

		for i = 1, num_actors do
			local hit_actor = hit_actors[i]
			local hit_unit = Actor.unit(hit_actor)

			if not hit_units[hit_unit] then
				local is_ragdolled = Health.is_ragdolled(hit_unit)

				if is_ragdolled then
					hit_units[hit_unit] = true

					local hit_zone_or_nil = HitZone.get(hit_unit, hit_actor)
					local hit_zone_name_or_nil = hit_zone_or_nil and hit_zone_or_nil.name
					local hit_actor_position = Actor.position(hit_actor)
					local hit_distance_squared = Vector3.distance_squared(position, hit_actor_position)
					local hit_direction = Vector3.normalize(hit_actor_position - position)
					local close_hit = close_radius > 0 and hit_distance_squared < close_radius_squared

					if close_hit then
						MinionDeath.attack_ragdoll(hit_unit, hit_direction, explosion_template.close_damage_profile, nil, hit_zone_name_or_nil, nil, nil)
					else
						MinionDeath.attack_ragdoll(hit_unit, hit_direction, explosion_template.damage_profile, nil, hit_zone_name_or_nil, nil, nil)
					end

					number_of_attack_units = number_of_attack_units + 1
				end
			end
		end
	end
end

local NO_LERP_VALUES = {}

Explosion.lerp_values = function (attacking_unit, explosion_template_name_or_nil, override_action_name_or_nil)
	local weapon_extension = ScriptUnit.has_extension(attacking_unit, "weapon_system")

	if not weapon_extension then
		return NO_LERP_VALUES
	end

	local lerp_values = weapon_extension:explosion_template_lerp_values(explosion_template_name_or_nil, override_action_name_or_nil)

	return lerp_values
end

local EMPTY_PATH = {
	[DEFAULT_LERP_VALUE] = 0,
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
	local min, max = entry[1], entry[2]
	local t = lerp_value

	return math.lerp(min, max, t)
end

Explosion.radii = function (explosion_template, charge_level, lerp_values, attack_type, attacker_stat_buffs, attacker_breed_or_nil)
	local radius, close_radius

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

	local is_prop = Breed.is_prop(attacker_breed_or_nil)

	if not is_prop and attacker_stat_buffs and attack_type == attack_types.explosion then
		local explosion_radius_modifier = attacker_stat_buffs.explosion_radius_modifier or 1
		local radius_stat_buffs = explosion_template.radius_stat_buffs

		if radius_stat_buffs then
			for index, stat_buff in pairs(radius_stat_buffs) do
				local radius_stat_buffs = (attacker_stat_buffs[stat_buff] or 1) - 1

				explosion_radius_modifier = explosion_radius_modifier + radius_stat_buffs
			end
		end

		radius = radius * explosion_radius_modifier
		close_radius = close_radius * explosion_radius_modifier
	end

	return radius, close_radius
end

function _play_effects(world, physics_world, attacking_unit_owner_unit, explosion_template, charge_level, source_position, optional_impact_normal, radius, predicted, is_server)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local fx_extension = player_unit_spawn_manager:is_player_unit(attacking_unit_owner_unit) and ScriptUnit.extension(attacking_unit_owner_unit, "fx_system")

	if not is_server and (not predicted or not fx_extension) then
		return
	end

	local all_clients = not predicted or not fx_extension
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

					if fx_extension then
						local scale
						local radius_variable_name = vfx_data.radius_variable_name

						fx_extension:spawn_particles(effect_name, source_position, rotation, scale, radius_variable_name, Vector3(radius, radius, radius), all_clients)
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

			if fx_extension then
				fx_extension:spawn_particles(effect_name, source_position, rotation, nil, nil, nil, all_clients)
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
				if fx_extension then
					local _, material, _, _, _, _ = MaterialQuery.query_material(physics_world, source_position + Vector3.up() * 0.5, source_position + Vector3.down() * 0.5)

					fx_extension:trigger_explosion_wwise_event(event_name_or_table, false, source_position, charge_wwise_parameter_name, charge_level, material, all_clients)
				else
					fx_system:trigger_wwise_event(event_name_or_table, source_position, nil, nil, charge_wwise_parameter_name, charge_level)
				end
			else
				local event_name = event_name_or_table.event_name

				if fx_extension then
					local has_husk_events = event_name_or_table.has_husk_events
					local _, material, _, _, _, _ = MaterialQuery.query_material(physics_world, source_position + Vector3.up() * 0.5, source_position + Vector3.down() * 0.5)

					fx_extension:trigger_explosion_wwise_event(event_name, has_husk_events, source_position, charge_wwise_parameter_name, charge_level, material, all_clients)
				else
					fx_system:trigger_wwise_event(event_name_or_table, source_position, nil, nil, charge_wwise_parameter_name, charge_level)
				end
			end
		end
	end
end

function _play_husk_effects(world, physics_world, wwise_world, attacking_owner_unit_or_nil, explosion_template, charge_level, position, rotation, radius)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local source_is_player = attacking_owner_unit_or_nil and player_unit_spawn_manager:is_player_unit(attacking_owner_unit_or_nil)
	local vfx_extension

	if source_is_player then
		vfx_extension = ScriptUnit.extension(attacking_owner_unit_or_nil, "fx_system")
	end

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
					local radius_variable_name = vfx_data.radius_variable_name
					local particle_id

					if vfx_extension then
						particle_id = vfx_extension:spawn_particles(effect_name, position)
					else
						particle_id = World.create_particles(world, effect_name, position, rotation)
					end

					if particle_id and radius_variable_name then
						local variable_index = World.find_particles_variable(world, effect_name, radius_variable_name)

						World.set_particles_variable(world, particle_id, variable_index, Vector3(radius, radius, radius))
					end
				end

				break
			end
		end
	elseif vfx then
		local num_vfx = #explosion_template.vfx

		for i = 1, num_vfx do
			local effect_name = vfx[i]

			if vfx_extension then
				vfx_extension:spawn_particles(effect_name, position)
			else
				World.create_particles(world, effect_name, position, rotation)
			end
		end
	end

	local sfx = explosion_template.sfx

	if sfx then
		local should_play_husk_effect, surface_material_hit, material_or_nil

		if source_is_player then
			surface_material_hit, material_or_nil = MaterialQuery.query_material(physics_world, position + Vector3.up() * 0.5, position + Vector3.down() * 0.5)

			local source_player_fx_extension = ScriptUnit.has_extension(attacking_owner_unit_or_nil, "fx_system")

			should_play_husk_effect = source_player_fx_extension and source_player_fx_extension:should_play_husk_effect()
		end

		local num_sfx = #sfx

		for i = 1, num_sfx do
			local event_name_or_table = sfx[i]
			local event_name = event_name_or_table

			if type(event_name_or_table) == "table" then
				local has_husk_events = event_name_or_table.has_husk_events

				event_name = should_play_husk_effect and has_husk_events and event_name_or_table.event_name .. "_husk" or event_name_or_table.event_name
			end

			local source_id = WwiseWorld.make_auto_source(wwise_world, position)

			if charge_wwise_parameter_name then
				WwiseWorld.set_source_parameter(wwise_world, source_id, charge_wwise_parameter_name, charge_level)
			end

			if material_or_nil then
				WwiseWorld.set_switch(wwise_world, "surface_material", material_or_nil, source_id)
			end

			WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
		end
	end
end

return Explosion
