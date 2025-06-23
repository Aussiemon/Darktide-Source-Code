-- chunkname: @scripts/settings/buff/force_sword_2h_p1_buff_templates.lua

local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local HazardProp = require("scripts/utilities/level_props/hazard_prop")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local LagCompensation = require("scripts/utilities/lag_compensation")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local RangedAction = require("scripts/utilities/action/ranged_action")
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local templates = {}

table.make_unique(templates)

local CLOSE_RANGE_SQUARED = 9
local _external_properties = {}
local _hit_units = {}

local function _collect_forcesword_wind_slash_hits(template_data, template_context, side, t, talent_extension)
	if not template_context.is_server then
		return
	end

	local tweak_data = template_data.tweak_data
	local slash_settings = tweak_data.slash_settings
	local first_person_component = template_data.first_person_component
	local start_rotation = first_person_component.rotation
	local start_position = first_person_component.position
	local fallback_attack_direction = Quaternion.forward(start_rotation)
	local attack_type = slash_settings.attack_type
	local power_level = slash_settings.power_level or DEFAULT_POWER_LEVEL

	table.clear(_hit_units)

	_hit_units[template_context.unit] = true
	template_data.power_level = power_level
	template_data.attack_type = attack_type

	local slash_dot = slash_settings.dot_check
	local slash_range = slash_settings.range
	local slash_direction = template_data.slash_direction
	local thickness = slash_settings.thickness
	local half_thickness = thickness * 0.5
	local hit_positions = template_data.hit_positions
	local hit_distances = template_data.hit_distances
	local total_range = slash_range
	local previous_range = 0

	while total_range > 0 do
		local range = previous_range > 0 and previous_range * 2 or 2.5
		local slice_radius = range - previous_range

		total_range = total_range - range
		previous_range = range

		local position = start_position + slash_direction * range
		local player = template_context.player
		local is_local_unit = not player.remote
		local rewind_ms = LagCompensation.rewind_ms(true, is_local_unit, player)
		local world = template_context.world
		local physics_world = World.physics_world(world)
		local hit_actors, num_hit_actors = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", position, "size", slice_radius, "collision_filter", "filter_player_character_shooting_raycast_dynamics", "rewind_ms", rewind_ms)

		for ii = 1, num_hit_actors do
			repeat
				local hit_actor = hit_actors[ii]
				local hit_unit = Actor.unit(hit_actor)

				if not _hit_units[hit_unit] then
					_hit_units[hit_unit] = true

					local hit_unit_position = POSITION_LOOKUP[hit_unit] or Unit.world_position(hit_unit, 1)
					local lower_z = hit_unit_position.z
					local upper_z, highest_position
					local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
					local target_breed_or_nil = unit_data_extension and unit_data_extension:breed()
					local is_damagable = Health.is_damagable(hit_unit)

					if not is_damagable then
						break
					end

					local hit_zone_name_or_nil = HitZone.get_name(hit_unit, hit_actor)
					local target_is_hazard_prop, hazard_prop_is_active = HazardProp.status(hit_unit)
					local is_breed_with_hit_zone = target_breed_or_nil and hit_zone_name_or_nil
					local should_deal_damage = target_is_hazard_prop and hazard_prop_is_active or not target_is_hazard_prop and is_breed_with_hit_zone or not target_breed_or_nil

					if not should_deal_damage then
						break
					end

					local breed_or_nil = Breed.unit_breed_or_nil(hit_unit)

					if Breed.is_minion(breed_or_nil) then
						local enemy_head_position = HitZone.hit_zone_center_of_mass(hit_unit, "head")

						upper_z = enemy_head_position.z
						highest_position = enemy_head_position
					elseif Breed.is_prop(breed_or_nil) or Breed.is_living_prop(breed_or_nil) then
						local enemy_center_position = HitZone.hit_zone_center_of_mass(hit_unit, "center_mass")
						local half_height = math.abs(enemy_center_position.z - hit_unit_position.z)

						upper_z = hit_unit_position.z + half_height * 2
						highest_position = hit_unit_position + Vector3.up() * half_height * 2
					end

					if not upper_z or math.abs(lower_z - upper_z) <= 0.001 then
						local _, half_extents = Unit.box(hit_unit)
						local height = half_extents.z * 2

						upper_z = hit_unit_position.z + height
						highest_position = hit_unit_position + Vector3.up() * height
					end

					upper_z = upper_z + half_thickness
					lower_z = lower_z - half_thickness

					local closest_point = Geometry.closest_point_on_line(highest_position, start_position, start_position + slash_direction * slash_range)
					local closest_z = closest_point.z
					local distance_squared = Vector3.distance_squared(hit_unit_position, start_position)
					local attack_direction = Vector3.normalize(hit_unit_position - start_position)

					if Vector3.length_squared(attack_direction) == 0 then
						attack_direction = fallback_attack_direction
					end

					local dot = Vector3.dot(slash_direction, attack_direction)
					local within_angle = slash_dot < dot or distance_squared < CLOSE_RANGE_SQUARED
					local within_height = lower_z <= closest_z and closest_z <= upper_z
					local can_hit = within_angle and within_height

					if can_hit and not hit_distances[hit_unit] then
						template_data.slash_num_hits = template_data.slash_num_hits + 1
						hit_positions[hit_unit] = Vector3Box(hit_unit_position.x, hit_unit_position.y, closest_z)
						hit_distances[hit_unit] = distance_squared
					end
				end
			until true
		end
	end
end

local function _update_forcesword_wind_slash(template_data, template_context, dt, t)
	if not template_context.is_server then
		return
	end

	if not template_data.slash_time_remaining then
		return
	end

	local tweak_data = template_data.tweak_data
	local slash_settings = tweak_data.slash_settings
	local slash_distance_traveled = template_data.slash_distance_traveled
	local hit_positions = template_data.hit_positions
	local hit_distances = template_data.hit_distances
	local damage_profile = template_data.damage_profile
	local player_unit = template_context.unit
	local power_level = template_data.power_level
	local damage_type = template_data.damage_type
	local attack_type = template_data.attack_type
	local start_position = template_data.start_position:unbox()
	local attack_direction = template_data.attack_direction:unbox()
	local is_critical_strike = template_data.is_critical_strike
	local distance_traveled_squared = slash_distance_traveled * slash_distance_traveled

	for unit, distance_squared in pairs(hit_distances) do
		if not HEALTH_ALIVE[unit] then
			hit_positions[unit] = nil
			hit_distances[unit] = nil
		elseif distance_squared <= distance_traveled_squared then
			local hit_zone_name = slash_settings.hit_zone_name
			local target_index, hit_actor
			local hit_position = hit_positions[unit]:unbox()
			local distance = math.sqrt(distance_squared)
			local hit_normal = -attack_direction
			local penetrated = false
			local lerp_values = DamageProfile.lerp_values(damage_profile, player_unit)
			local charge_level
			local instakill = false
			local weapon_item = template_context.source_item
			local triggered_proc_events_or_nil
			local damage_dealt, attack_result, damage_efficiency, hit_weakspot = RangedAction.execute_attack(target_index, player_unit, unit, hit_actor, hit_position, distance, attack_direction, hit_normal, hit_zone_name, damage_profile, lerp_values, power_level, charge_level, penetrated, instakill, damage_type, is_critical_strike, weapon_item, triggered_proc_events_or_nil)

			ImpactEffect.play(unit, nil, damage_dealt, damage_type, hit_zone_name, attack_result, hit_position, nil, attack_direction, player_unit, nil, false, attack_type, damage_efficiency, damage_profile)

			hit_position[unit] = nil
			hit_distances[unit] = nil
		end
	end

	local position = start_position + attack_direction * slash_distance_traveled
	local owner_unit = template_context.owner_unit
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[owner_unit]
	local new_time_remaining = template_data.slash_time_remaining - dt

	template_data.slash_time_remaining = new_time_remaining > 0 and new_time_remaining or nil
	template_data.slash_distance_traveled = slash_distance_traveled + template_data.slash_speed * dt
end

local function _force_sword_weapon_special_tweak_data(template_data, template_context)
	local tweak_data = template_data.tweak_data
	local visual_loadout_extension = template_data.visual_loadout_extension

	if not visual_loadout_extension or not tweak_data then
		visual_loadout_extension = ScriptUnit.extension(template_context.unit, "visual_loadout_system")
		template_data.visual_loadout_extension = visual_loadout_extension

		local slot_name = template_context.item_slot_name
		local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_name)

		tweak_data = weapon_template.weapon_special_tweak_data
		template_data.tweak_data = tweak_data
	end

	return tweak_data
end

local function _forcesword_wind_slash_trigger_generator_func(level)
	return {
		predicted = false,
		force_predicted_proc = true,
		class_name = "proc_buff",
		active_duration = 3,
		proc_events = {
			[proc_events.on_sweep_start] = 1,
			[proc_events.on_weapon_special_deactivate] = 1
		},
		conditional_exit_func = function (template_data, template_context)
			local special_active = template_data.inventory_slot_component.special_active

			return not special_active
		end,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		start_func = function (template_data, template_context)
			local unit = template_context.unit

			template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
			template_data.weapon_extension = ScriptUnit.has_extension(unit, "weapon_system")
			template_data.buff_finished = false

			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local slot_name = template_context.item_slot_name

			template_data.inventory_slot_component = unit_data_extension:write_component(slot_name)
		end,
		proc_func = function (params, template_data, template_context, t)
			local buff_to_add = string.format("forcesword_wind_slash_weapon_special_effect_%s", level)
			local buff_extension = template_data.buff_extension

			buff_extension:add_internally_controlled_buff(buff_to_add, t, "item_slot_name", template_context.item_slot_name)
			template_data.weapon_extension:set_wielded_weapon_weapon_special_active(t, false, "max_activations")
		end
	}
end

local function _forcesword_wind_slash_effect_generator_func(level)
	return {
		class_name = "buff",
		predicted = false,
		duration = 3,
		conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
		check_proc_func = function (params, template_data, template_context)
			return params.is_weapon_special_active
		end,
		start_func = function (template_data, template_context)
			local unit = template_context.unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

			template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
			template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			local slot_name = template_context.item_slot_name

			template_data.inventory_slot_component = unit_data_extension:write_component(slot_name)
			template_data.locomotion_component = unit_data_extension:read_component("locomotion")
			template_data.first_person_component = unit_data_extension:read_component("first_person")
			template_data.critical_strike_component = unit_data_extension:read_component("critical_strike")
			template_data.slash_direction = nil
			template_data.start_position = Vector3Box()
			template_data.attack_direction = Vector3Box()
			template_data.hit_positions = {}
			template_data.hit_distances = {}
			template_data.slash_distance_traveled = 0
			template_data.slash_num_hits = 0
			template_data.slash_speed = 0
			template_data.slash_range = 0
			template_data.slash_num_hits = 0

			local t = FixedFrame.get_latest_fixed_time()
			local guaranteed_wind_slash_critical_strike = template_context.buff_extension:has_keyword(buff_keywords.guaranteed_wind_slash_critical_strike)

			template_data.is_critical_strike = template_data.critical_strike_component.is_active or guaranteed_wind_slash_critical_strike
			template_data.sweep_start_t = t
		end,
		update_func = function (template_data, template_context, dt, t)
			local tweak_data = _force_sword_weapon_special_tweak_data(template_data, template_context)
			local slash_settings = tweak_data.slash_settings
			local sweep_start_t = template_data.sweep_start_t

			if sweep_start_t then
				local time_since_start = t - sweep_start_t

				if not ConditionalFunctions.is_item_slot_wielded(template_data, template_context) then
					template_data.sweep_start_t = nil
				elseif time_since_start > slash_settings.start_time and not template_data.slash_time_remaining then
					local levels = slash_settings.levels
					local damage_profile = levels[level].damage_profile
					local damage_type = levels[level].damage_type

					template_data.selected_level = level
					template_data.damage_profile = damage_profile
					template_data.damage_type = damage_type

					table.clear(_external_properties)

					_external_properties.level = level

					local range = slash_settings.range
					local total_time = slash_settings.total_time
					local particle_alias = slash_settings.particle_alias
					local sound_alias = slash_settings.sound_alias
					local first_person_component = template_data.first_person_component
					local position = first_person_component.position
					local rotation = first_person_component.rotation
					local forward = Quaternion.forward(rotation)
					local fx_extension = template_data.fx_extension

					fx_extension:spawn_moving_player_fx_alias(particle_alias, sound_alias, _external_properties, position, forward, range, total_time)

					local player_unit = template_context.unit

					template_data.slash_direction = forward

					template_data.start_position:store(position)
					template_data.attack_direction:store(forward)

					template_data.slash_distance_traveled = 0
					template_data.slash_time_remaining = total_time
					template_data.slash_range = range
					template_data.slash_speed = range / total_time
					template_data.slash_num_hits = 0

					if not template_context.is_server then
						return
					end

					local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")
					local side_system = Managers.state.extension:system("side_system")
					local side = side_system.side_by_unit[player_unit]

					_collect_forcesword_wind_slash_hits(template_data, template_context, side, t, talent_extension)

					template_data.sweep_start_t = nil
				end
			end

			_update_forcesword_wind_slash(template_data, template_context, dt, t)
		end
	}
end

templates.forcesword_wind_slash_weapon_special_primer = {
	force_predicted_proc = true,
	predicted = false,
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_weapon_special_activate] = 1
	},
	conditional_proc_func = ConditionalFunctions.is_item_slot_wielded,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		local num_special_charges = params.num_special_charges or 0
		local tweak_data = _force_sword_weapon_special_tweak_data(template_data, template_context)
		local slash_settings = tweak_data.slash_settings
		local thresholds = tweak_data.thresholds
		local buff_to_add = "forcesword_wind_slash_weapon_special_trigger_low"

		for ii = #thresholds, 1, -1 do
			if num_special_charges >= thresholds[ii].threshold then
				buff_to_add = slash_settings.levels[thresholds[ii].name].buff_to_add

				break
			end
		end

		local buff_extension = template_data.buff_extension

		if not buff_extension:has_buff_using_buff_template(buff_to_add) then
			local buff_id = buff_extension:add_internally_controlled_buff(buff_to_add, t, "item_slot_name", template_context.item_slot_name)

			template_data.trigger_buff_id = buff_id
		end
	end
}
templates.forcesword_wind_slash_weapon_special_trigger_low = _forcesword_wind_slash_trigger_generator_func("low")
templates.forcesword_wind_slash_weapon_special_trigger_middle = _forcesword_wind_slash_trigger_generator_func("middle")
templates.forcesword_wind_slash_weapon_special_trigger_high = _forcesword_wind_slash_trigger_generator_func("high")
templates.forcesword_wind_slash_weapon_special_effect_low = _forcesword_wind_slash_effect_generator_func("low")
templates.forcesword_wind_slash_weapon_special_effect_middle = _forcesword_wind_slash_effect_generator_func("middle")
templates.forcesword_wind_slash_weapon_special_effect_high = _forcesword_wind_slash_effect_generator_func("high")

return templates
