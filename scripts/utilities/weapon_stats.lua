local ArmorSettings = require("scripts/settings/damage/armor_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local DamageCalculation = require("scripts/utilities/attack/damage_calculation")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local StaggerCalculation = require("scripts/utilities/attack/stagger_calculation")
local WeaponHandlingTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_handling_templates")
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local WeaponTweakTemplates = require("scripts/extension_systems/weapon/utilities/weapon_tweak_templates")
local WeaponStaminaTemplates = require("scripts/settings/stamina/weapon_stamina_templates")
local WeaponAmmoTemplates = require("scripts/settings/equipment/weapon_handling_templates/weapon_ammo_templates")
local Weapon = require("scripts/extension_systems/weapon/weapon")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponStats = class("WeaponStats")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level

WeaponStats.init = function (self, item)
	self._item = item
	self._ranged = {}
	self._melee = {}
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local weapon_tweak_templates, damage_profile_lerp_values, explosion_template_lerp_values, buffs = Weapon._init_traits(nil, weapon_template, item, nil, nil, {})
	local weapon_stats = self:calculate_stats(weapon_template, weapon_tweak_templates, damage_profile_lerp_values)
	local weapon_traits = self:calculate_traits(buffs)
	self._name = weapon_stats.name
	self._is_ranged_weapon = weapon_stats.is_ranged_weapon
	self._type = weapon_stats.is_ranged_weapon and "Ranged" or "Melee"
	self._dps = weapon_stats.dps or 0
	self._damage = weapon_stats.damage or 0
	self._stagger = weapon_stats.stagger or 0
	self._stamina_block_cost = weapon_stats.stamina_block_cost or 0
	self._stamina_push_cost = weapon_stats.stamina_push_cost or 0
	self._stamina = weapon_stats.stamina or 0
	self._rate_of_fire = weapon_stats.rate_of_fire or 0
	self._bullets_per_second = weapon_stats.bullets_per_second or 0
	self._reload_time = weapon_stats.reload_time or 0
	self._attack_speed = weapon_stats.attack_speed or 0
	self._ammo = weapon_stats.ammo or 0
	self._ammo_reserve = weapon_stats.ammo_reserve or 0
	self._uses_ammunition = weapon_stats.uses_ammunition
	self._uses_overheat = weapon_stats.uses_overheat
	self._ranged = self:get_all_ranged()
	self._melee = self:get_all_melee()
end

WeaponStats.calculate_stats = function (self, weapon_template, weapon_tweak_templates, damage_profile_lerp_values)
	local breed_or_nil, hit_zone_name, target_toughness_extension = nil
	local armor_type = ArmorSettings.types.unarmored
	local breed_name = "chaos_poxwalker"
	local breed = Breeds[breed_name]
	local attacker_stat_buffs = {}
	local target_stat_buffs = {}
	local target_buff_extension = nil
	local charge_level = 1
	local distance = 1
	local is_backstab = false
	local is_flanking = false
	local hit_weakspot = false
	local stagger_count = 0
	local num_triggered_staggers = 0
	local is_attacked_unit_suppressed = false
	local uses_overheat = weapon_template.uses_overheat
	local uses_ammunition = weapon_template.uses_ammunition
	local actions = weapon_template.actions
	local rate_of_fire = nil
	local template_types = WeaponTweakTemplateSettings.template_types
	local ammo_templates = weapon_tweak_templates[template_types.ammo]
	local ammo_template_name = weapon_template.ammo_template or "none"
	local ammo_template = ammo_templates[ammo_template_name]
	local stamina_templates = weapon_tweak_templates[template_types.stamina]
	local stamina_template_name = weapon_template.stamina_template or "none"
	local stamina_template = stamina_templates[stamina_template_name]
	local ammo_clip_size, ammo_reserve_size = nil

	if uses_ammunition then
		ammo_clip_size = ammo_template.ammunition_clip
		ammo_reserve_size = ammo_template.ammunition_reserve
	end

	local block_cost = stamina_template.block_cost_default
	local push_cost = stamina_template.push_cost
	local stamina_modifier = stamina_template.stamina_modifier
	local num_attack_actions = 0
	local total_attacks_damage = 0
	local total_attacks_duration = 0
	local total_stagger_strength = 0
	local reload_time = nil
	local entry_actions = weapon_template.entry_actions
	local is_ranged_weapon = self:_is_weapon_template_ranged(weapon_template)
	local target_index = is_ranged_weapon and "default_target" or 1

	for action_name, action in pairs(actions) do
		local kind = action.kind
		local total_time = action.total_time

		if is_ranged_weapon then
			if kind == "reload_state" then
				reload_time = total_time
			end

			if kind == "reload_shotgun" then
				if reload_time then
					if total_time < reload_time then
						reload_time = reload_time + (ammo_clip_size - 1) * total_time
					else
						reload_time = (ammo_clip_size - 1) * reload_time + total_time
					end
				else
					reload_time = total_time
				end
			end

			local reload_settings = action.reload_settings

			if reload_settings then
				local refill_amount = reload_settings.refill_amount
			end
		end

		if not entry_actions or entry_actions.primary_action == action_name then
			local damage_profile = action.damage_profile
			local fire_configuration = action.fire_configuration
			local attack_type = AttackSettings.attack_types.melee

			if total_time and total_time > 1000 then
				total_time = 0
			end

			if not damage_profile and fire_configuration then
				attack_type = AttackSettings.attack_types.ranged
				local damage_type = fire_configuration.damage_type
				local damage_template = nil

				if fire_configuration.flamer_gas_template then
					damage_template = fire_configuration.flamer_gas_template.damage
				elseif fire_configuration.hit_scan_template then
					damage_template = fire_configuration.hit_scan_template.damage
				elseif fire_configuration.projectile then
					damage_template = fire_configuration.projectile.damage
				elseif fire_configuration.shotshell then
					damage_template = fire_configuration.shotshell.damage
				end

				if damage_template then
					local damage_impact = damage_template.impact
					damage_profile = damage_impact and damage_impact.damage_profile
				end
			end

			if damage_profile then
				local weapon_handling_templates = weapon_tweak_templates[template_types.weapon_handling]
				local weapon_handling_template_name = weapon_template.actions[action_name].weapon_handling_template or "none"
				local weapon_handling_template = weapon_handling_templates[weapon_handling_template_name]
				local critical_strike = weapon_handling_template and weapon_handling_template.critical_strike

				if critical_strike then
					local chance_modifier = critical_strike.chance_modifier
					local max_critical_shots = critical_strike.max_critical_shots
				end

				local fire_rate = weapon_handling_template and weapon_handling_template.fire_rate

				if fire_rate then
					local auto_fire_time = fire_rate.auto_fire_time
					local fire_time = fire_rate.fire_time
					local max_shots = fire_rate.max_shots
					local total_waiting_duration = -total_time
					local total_rate_of_fire = 0

					if not auto_fire_time then
						max_shots = 1

						if fire_time then
							fire_time = total_time
						end
					elseif not max_shots and auto_fire_time then
						max_shots = ammo_clip_size
					end

					local tot_bullets = ammo_clip_size

					while tot_bullets > 0 do
						local burst_rate_of_fire = 0

						for i = 1, max_shots do
							if tot_bullets > 0 then
								if i == 1 then
									burst_rate_of_fire = burst_rate_of_fire + fire_time
								else
									burst_rate_of_fire = burst_rate_of_fire + (auto_fire_time or 0)
								end

								tot_bullets = tot_bullets - 1
							else
								break
							end
						end

						total_rate_of_fire = total_rate_of_fire + burst_rate_of_fire

						if tot_bullets > 0 then
							total_waiting_duration = total_waiting_duration + burst_rate_of_fire
						end

						total_waiting_duration = total_waiting_duration + math.max(total_time, burst_rate_of_fire)
					end

					total_time = total_waiting_duration
					rate_of_fire = total_rate_of_fire
				end

				local num_damage_itterations = 1

				if is_ranged_weapon and ammo_clip_size then
					num_damage_itterations = ammo_clip_size
				end

				local power_level = action.power_level or DEFAULT_POWER_LEVEL
				local damage_targets = damage_profile.targets
				local num_targets_counted = 0
				local num_targets_total_damage = 0
				local num_targets_total_stagger_strength = 0

				for index, target in pairs(damage_targets) do
					if index == target_index then
						local target_settings = DamageProfile.target_settings(damage_profile, target_index)
						local target_damage_values = {
							current_target_settings_lerp_values = damage_profile_lerp_values[action_name]
						}
						local is_critical_strike = false
						local armor_penetrating = false
						local auto_completed_action = false
						local target_unit, attacking_unit, attacker_breed_or_nil = nil
						local dropoff_scalar = DamageProfile.dropoff_scalar(distance, damage_profile, target_damage_values)
						local damage, damage_efficiency = DamageCalculation.calculate(damage_profile, target_settings, target_damage_values, hit_zone_name, power_level, charge_level, breed_or_nil, attacker_breed_or_nil, is_critical_strike, is_backstab, is_flanking, dropoff_scalar, attack_type, attacker_stat_buffs, target_stat_buffs, target_buff_extension, armor_penetrating, target_toughness_extension, armor_type, stagger_count, num_triggered_staggers, is_attacked_unit_suppressed, distance, target_unit, attacking_unit, auto_completed_action)
						damage = damage * num_damage_itterations

						if damage > 0 then
							num_targets_total_damage = num_targets_total_damage + damage
							num_targets_counted = num_targets_counted + 1
						end

						local stagger_strength_pool = 0
						local stagger_reduction_override_or_nil, optional_stagger_strength_multiplier = nil
						local stagger_type, duration_scale, length_scale, stagger_strength, current_hit_stagger_strength = StaggerCalculation.calculate(damage_profile, target_settings, target_damage_values, power_level, charge_level, breed, is_critical_strike, is_backstab, is_flanking, hit_weakspot, dropoff_scalar, stagger_reduction_override_or_nil, stagger_count, attack_type, armor_type, optional_stagger_strength_multiplier, stagger_strength_pool, target_stat_buffs, attacker_stat_buffs)

						if stagger_strength and stagger_strength > 0 then
							num_targets_total_stagger_strength = num_targets_total_stagger_strength + stagger_strength
						end
					end
				end

				if num_targets_counted > 0 then
					local average_action_damage = num_targets_total_damage / num_targets_counted
					local average_action_stagger_strength = num_targets_total_stagger_strength / num_targets_counted
					total_attacks_duration = total_attacks_duration + total_time
					num_attack_actions = num_attack_actions + 1
					total_attacks_damage = total_attacks_damage + average_action_damage
					total_stagger_strength = total_stagger_strength + average_action_stagger_strength
				end
			end
		end
	end

	if is_ranged_weapon and reload_time then
		total_attacks_duration = total_attacks_duration + reload_time
	end

	local average_action_duration = num_attack_actions > 0 and total_attacks_duration > 0 and total_attacks_duration / num_attack_actions or 0
	local average_action_damage = num_attack_actions > 0 and total_attacks_damage > 0 and total_attacks_damage / num_attack_actions or 0
	local average_action_stagger_strength = num_attack_actions > 0 and total_stagger_strength > 0 and total_stagger_strength / num_attack_actions or 0
	local dps_raw = average_action_duration > 0 and average_action_damage > 0 and average_action_damage / average_action_duration or average_action_damage
	local dps = math.round_with_precision(dps_raw, 1)
	local stats = {
		name = weapon_template.name,
		is_ranged_weapon = is_ranged_weapon,
		type = is_ranged_weapon and "Ranged" or "Melee",
		uses_ammunition = uses_ammunition,
		uses_overheat = uses_overheat
	}

	if dps and num_attack_actions > 0 then
		stats.dps = dps
		stats.damage = average_action_damage

		if average_action_stagger_strength then
			stats.stagger = average_action_stagger_strength
		end

		if block_cost and not is_ranged_weapon then
			stats.stamina_block_cost = block_cost
		end

		if push_cost and not is_ranged_weapon then
			stats.stamina_push_cost = push_cost
		end

		if stamina_modifier then
			stats.stamina_modifier = stamina_modifier
		end

		if rate_of_fire then
			local bullets_per_second = math.ceil(1 / (rate_of_fire / ammo_clip_size))
			stats.rate_of_fire = rate_of_fire
			stats.bullets_per_second = bullets_per_second

			if reload_time then
				stats.reload_time = reload_time
			end
		else
			stats.attack_speed = average_action_duration
		end

		if uses_ammunition then
			stats.ammo = ammo_clip_size
			stats.ammo_reserve = ammo_reserve_size
		end
	end

	return stats
end

WeaponStats.construct_placeholder_item = function (self, weapon_template, use_max_traits)
	if use_max_traits then
		local stats = {}

		if weapon_template.base_stats then
			for stat_name, stat_definition in pairs(weapon_template.base_stats) do
				if stat_definition.is_stat_trait == true then
					stats[#stats + 1] = {
						value = 1,
						name = stat_name
					}
				end
			end

			return {
				base_stats = stats
			}
		end
	end

	return {}
end

WeaponStats.is_ranged_weapon = function (self)
	return self._is_ranged_weapon
end

WeaponStats.uses_overheat = function (self)
	return self._uses_overheat
end

WeaponStats._is_weapon_template_ranged = function (self, weapon_template)
	local keywords = weapon_template.keywords
	local search_result = table.find(keywords, "ranged")

	return search_result and search_result > 0
end

WeaponStats.get_all_ranged = function (self)
	local weapons = {}

	for name, weapon_template in pairs(WeaponTemplates) do
		if self:_is_weapon_template_ranged(weapon_template) then
			weapons[name] = weapon_template
		end
	end

	return weapons
end

WeaponStats.get_all_melee = function (self)
	local weapons = {}

	for name, weapon_template in pairs(WeaponTemplates) do
		if not self:_is_weapon_template_ranged(weapon_template) then
			weapons[name] = weapon_template
		end
	end

	return weapons
end

WeaponStats.get_compare_stats_limits = function (self, weapon_template)
	local templates_to_compare = {}
	local min_stats = {}
	local max_stats = {}
	local min_stats_total = {}
	local max_stats_total = {}

	if self:_is_weapon_template_ranged(weapon_template) then
		templates_to_compare = self._ranged
	else
		templates_to_compare = self._melee
	end

	local stats_list = {
		"damage",
		"stagger",
		"stamina_block_cost",
		"rate_of_fire",
		"bullets_per_second",
		"reload_time",
		"attack_speed"
	}

	for name, compare_weapon_template in pairs(templates_to_compare) do
		local min_item = self:construct_placeholder_item(compare_weapon_template)
		local weapon_tweak_templates, damage_profile_lerp_values, explosion_template_lerp_values, buffs = Weapon._init_traits(nil, compare_weapon_template, min_item, nil, nil, {})
		local min_compare_stats = self:calculate_stats(compare_weapon_template, weapon_tweak_templates, damage_profile_lerp_values)
		local max_item = self:construct_placeholder_item(compare_weapon_template, true)
		weapon_tweak_templates, damage_profile_lerp_values, explosion_template_lerp_values, buffs = Weapon._init_traits(nil, compare_weapon_template, max_item, nil, nil, {})
		local max_compare_stats = self:calculate_stats(compare_weapon_template, weapon_tweak_templates, damage_profile_lerp_values)

		for i = 1, #stats_list do
			local stat_name = stats_list[i]
			local min_compare_stat = min_compare_stats[stat_name] or 0
			local max_compare_stat = max_compare_stats[stat_name] or 0
			min_stats[stat_name] = min_stats[stat_name] and min_stats[stat_name] < min_compare_stat and min_stats[stat_name] or min_compare_stat
			max_stats[stat_name] = max_stats[stat_name] and max_compare_stat < max_stats[stat_name] and max_stats[stat_name] or max_compare_stat
			min_stats_total[stat_name] = (min_stats_total[stat_name] or 0) + min_compare_stat
			max_stats_total[stat_name] = (max_stats_total[stat_name] or 0) + max_compare_stat
		end
	end

	local stats = {}
	local num_compare_templates = table.size(templates_to_compare)

	for i = 1, #stats_list do
		local stat_name = stats_list[i]
		stats[stat_name] = {
			min = min_stats[stat_name],
			max = max_stats[stat_name],
			min_average = min_stats_total[stat_name] / num_compare_templates,
			max_average = max_stats_total[stat_name] / num_compare_templates
		}
	end

	return stats
end

WeaponStats.get_attributes = function (self)
	return {}
end

WeaponStats.get_compairing_stats = function (self)
	local item = self._item
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local item_base_stats = item.base_stats
	local weapon_base_stats = weapon_template.base_stats
	local values = {}

	if item_base_stats then
		for i = 1, #item_base_stats do
			local stat = item_base_stats[i]
			local stat_name = stat.name
			local stat_value = stat.value or 0
			local stat_template = weapon_base_stats[stat_name]

			if stat_template then
				local display_name = stat_template.display_name
				values[#values + 1] = {
					min = 0,
					max = 1,
					display_name = display_name,
					fraction = stat_value,
					current = stat_value
				}
			end
		end
	end

	for key, stat in pairs(values) do
		stat.type = key
	end

	return values
end

WeaponStats.calculate_traits = function (self, buffs)
	table.dump(buffs.perks or {}, nil, 4)
	table.dump(buffs.trais or {}, nil, 4)

	return {}
end

WeaponStats.get_main_stats = function (self)
	return {
		dps = self._dps,
		stamina_push_cost = self._stamina_push_cost,
		stamina = self._stamina,
		magazine = self._uses_ammunition and {
			ammo = self._ammo,
			reserve = self._ammo_reserve
		}
	}
end

return WeaponStats
