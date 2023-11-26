-- chunkname: @scripts/utilities/weapon_stats.lua

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
local UISettings = require("scripts/settings/ui/ui_settings")
local WeaponStats = class("WeaponStats")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local template_types = WeaponTweakTemplateSettings.template_types
local Action = require("scripts/utilities/weapon/action")
local WeaponUIStatsTemplates = require("scripts/settings/equipment/weapon_ui_stats_templates")
local WeaponUIStatsDamageSettings = require("scripts/settings/equipment/weapon_ui_stats_damage_settings")
local WeaponTweakStatsUIData = require("scripts/settings/equipment/weapon_tweak_stats_ui_data")
local DAMAGE_BODY = WeaponUIStatsDamageSettings.DAMAGE_BODY
local DAMAGE_FINESSE = WeaponUIStatsDamageSettings.DAMAGE_FINESSE
local WeaponTweakStatsUIDataGroups = WeaponTweakStatsUIData.groups
local _get_display_data_from_path, _calculate_weapon_statistics, _resolve_damage_template_lerps, _resolve_explosion_template_lerps, _get_weapon_stats

local function _resolve_stat_path(table_tree, path, start_idx, end_idx)
	local resolved_value = table_tree

	for i = start_idx, end_idx do
		if not resolved_value then
			return nil
		end

		local current_path_segment = path[i]

		if type(current_path_segment) == "table" then
			local min_range = math.min(current_path_segment[1], #resolved_value)
			local max_range = math.min(current_path_segment[2], #resolved_value)
			local sum = 0

			for sub_tree_idx = min_range, max_range do
				sum = sum + _resolve_stat_path(resolved_value[sub_tree_idx], path, i + 1, end_idx)
			end

			return sum / (max_range - min_range + 1)
		else
			resolved_value = resolved_value[current_path_segment]
		end
	end

	return resolved_value
end

local EMPTY_TABLE = {}

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
	self._stamina = weapon_stats.stamina_modifier or 0
	self._rate_of_fire = weapon_stats.rate_of_fire or 0
	self._bullets_per_second = weapon_stats.bullets_per_second or 0
	self._reload_time = weapon_stats.reload_time or 0
	self._attack_speed = weapon_stats.attack_speed or 0
	self._ammo = weapon_stats.ammo or 0
	self._ammo_reserve = weapon_stats.ammo_reserve or 0
	self._uses_ammunition = weapon_stats.uses_ammunition
	self._uses_overheat = weapon_stats.uses_overheat
	self._charge_duration = weapon_stats.charge_duration or 0
	self._ranged = self:get_all_ranged()
	self._melee = self:get_all_melee()

	local grouped_stats = {}
	local late_group_stats = {}
	local late_groups = {}

	self._weapon_statistics = _calculate_weapon_statistics(weapon_template, weapon_tweak_templates, damage_profile_lerp_values) or {}

	if self._weapon_statistics then
		local bar_breakdown = {}
		local bar_stats = item.base_stats or EMPTY_TABLE
		local bar_stats_template = weapon_template.base_stats or {}

		for base_stat_idx = 1, #bar_stats do
			local bar_def = bar_stats[base_stat_idx]
			local bar_name = bar_def.name
			local bar_lerp_value = bar_def.value
			local bar_stats_def = bar_stats_template[bar_name] or EMPTY_TABLE
			local entry = {
				name = bar_name,
				display_name = bar_stats_def.display_name,
				description = bar_stats_def.description,
				value = bar_lerp_value
			}
			local stat_n = 0

			for template_name, target in pairs(bar_stats_def) do
				if rawget(template_types, template_name) then
					for target_name, target_data in pairs(target) do
						local display_data = target_data.display_data
						local display_stats = display_data and display_data.display_stats

						if display_stats then
							local all_basic_stats = display_stats.__all_basic_stats

							for stat_group_idx = 1, #target_data do
								local stat_group = target_data[stat_group_idx]

								for modified_stat_idx = 1, #stat_group do
									local stat_data = stat_group[modified_stat_idx]
									local stat_display_data = _get_display_data_from_path(display_stats, stat_data) or all_basic_stats and EMPTY_TABLE

									if stat_display_data then
										local ui_data = stat_display_data.use_override_only and stat_display_data or WeaponTweakTemplates.get_stat_ui_data(template_name, stat_data)

										if ui_data then
											local min, max
											local custom_range = stat_display_data.custom_range or ui_data.custom_range

											if custom_range then
												min = custom_range[1]
												max = custom_range[2]
											elseif template_name == template_types.damage then
												min, max = WeaponTweakTemplates.get_base_stats_lerp_values(stat_data)
												min, max = _resolve_damage_template_lerps(weapon_template, target_name, stat_data, min, max)
											elseif template_name == template_types.explosion then
												min, max = WeaponTweakTemplates.get_base_stats_lerp_values(stat_data)
												min, max = _resolve_explosion_template_lerps(weapon_template, target_name, stat_data, min, max)
											else
												local base_stats = WeaponTweakTemplates.get_base_stats(weapon_template, template_name, target_name)

												min, max = WeaponTweakTemplates.get_base_stats_values(base_stats, stat_data)
											end

											if min and max then
												local current = math.lerp(min, max, bar_lerp_value)
												local normalize = stat_display_data.normalize == nil and ui_data.normalize or stat_display_data.normalize

												if normalize then
													max = 2 - min / max
													current = 2 - min / current
													min = 1
												end

												local group_key = stat_display_data.stat_group_key or ui_data.stat_group_key

												if group_key then
													local group_rule = stat_display_data.stat_group_rule or ui_data.stat_group_rule
													local grouped_stat = grouped_stats[group_key]

													if grouped_stat then
														if group_rule == "sum" then
															grouped_stat.min = grouped_stat.min + min
															grouped_stat.max = grouped_stat.max + max
															grouped_stat.current = grouped_stat.current + current
														elseif group_rule == "average" then
															grouped_stat.min = grouped_stat.min + min
															grouped_stat.max = grouped_stat.max + max
															grouped_stat.current = grouped_stat.current + current
															grouped_stat.count = grouped_stat.count + 1
														elseif group_rule == "min" then
															grouped_stat.min = math.min(grouped_stat.min, min)
															grouped_stat.max = math.min(grouped_stat.max, max)
															grouped_stat.current = math.min(grouped_stat.current, current)
														elseif group_rule == "max" then
															grouped_stat.min = math.max(grouped_stat.min, min)
															grouped_stat.max = math.max(grouped_stat.max, max)
															grouped_stat.current = math.max(grouped_stat.current, current)
														end
													else
														grouped_stat = {
															count = 1,
															min = min,
															max = max,
															current = current
														}
														grouped_stats[group_key] = grouped_stat

														if stat_display_data.store_for_late_resolve then
															late_group_stats[group_key] = grouped_stat
														end
													end
												elseif min ~= max then
													local rounding_func = ui_data.rounding

													if rounding_func then
														min = rounding_func(min)
														max = rounding_func(max)
														current = rounding_func(current)
													end

													stat_n = stat_n + 1
													entry[stat_n] = {
														group_type_data = display_data,
														type_data = ui_data,
														override_data = stat_display_data,
														min = min,
														max = max,
														value = current
													}
												end
											end
										end
									end
								end
							end
						end

						local overrides = target_data.overrides

						if overrides and (template_name == template_types.damage or template_name == template_types.explosion) then
							for override_name, stat_override_data in pairs(overrides) do
								local override_display_data = stat_override_data.display_data
								local override_display_stats = override_display_data and override_display_data.display_stats

								if override_display_stats then
									local all_basic_stats = override_display_stats.__all_basic_stats

									for stat_group_idx = 1, #stat_override_data do
										local stat_group = stat_override_data[stat_group_idx]

										for modified_stat_idx = 1, #stat_group do
											local stat_data = stat_group[modified_stat_idx]
											local stat_display_data = _get_display_data_from_path(override_display_stats, stat_data) or all_basic_stats and EMPTY_TABLE

											if stat_display_data then
												local ui_data = WeaponTweakTemplates.get_stat_ui_data(template_name, stat_data)

												if ui_data then
													local damage_profile_path = override_display_data.damage_profile_path
													local from_weapon_template = damage_profile_path.from_weapon_template
													local actions = weapon_template.actions
													local action = actions and actions[target_name]
													local damage_profile = from_weapon_template and weapon_template or action

													for i = 1, #damage_profile_path do
														local path_segment = damage_profile_path[i]

														damage_profile = damage_profile[path_segment]

														if not damage_profile then
															break
														end
													end

													if damage_profile then
														local min, max

														if template_name == template_types.damage then
															min, max = WeaponTweakTemplates.get_base_stats_lerp_values(stat_data)
															min, max = _resolve_damage_template_lerps(weapon_template, target_name, stat_data, min, max, nil, damage_profile)
														elseif template_name == template_types.explosion then
															min, max = WeaponTweakTemplates.get_base_stats_lerp_values(stat_data)
															min, max = _resolve_explosion_template_lerps(weapon_template, target_name, stat_data, min, max, nil, damage_profile)
														end

														if min ~= max then
															local current = math.lerp(min, max, bar_lerp_value)

															stat_n = stat_n + 1
															entry[stat_n] = {
																group_type_data = override_display_data,
																type_data = ui_data,
																override_data = stat_display_data,
																min = min,
																max = max,
																value = current
															}
														end
													end
												end
											end
										end
									end
								end
							end
						end

						for grouped_stat_key, grouped_stat in pairs(grouped_stats) do
							local count = grouped_stat.count

							grouped_stat.min = grouped_stat.min / count
							grouped_stat.max = grouped_stat.max / count
							grouped_stat.current = grouped_stat.current / count
						end

						local display_group_stats = display_data and display_data.display_group_stats

						if display_group_stats then
							local _, lerped_identifier = WeaponTweakTemplates.get_template_identifiers(weapon_template, template_name, target_name)

							for group_name, group_data in pairs(display_group_stats) do
								local group_description = WeaponTweakStatsUIDataGroups[group_name]

								if group_description then
									local extra_dependancies = group_description.extra_dependancies

									if extra_dependancies then
										for dependancy_key, dependancy_path in pairs(extra_dependancies) do
											if not grouped_stats[dependancy_key] then
												local resolved_table = weapon_tweak_templates[template_name][lerped_identifier]

												if resolved_table then
													local value = _resolve_stat_path(resolved_table, dependancy_path, 1, #dependancy_path)

													if value then
														grouped_stats[dependancy_key] = {
															min = value,
															max = value,
															current = value
														}
													end
												end
											end
										end
									end

									if group_data.resolve_late then
										late_groups[group_name] = group_data
									else
										local func = group_data.func or group_description.func
										local override_data = group_data.type_data or EMPTY_TABLE
										local min, max, current = func(grouped_stats, weapon_stats)

										if min ~= max then
											stat_n = stat_n + 1
											entry[stat_n] = {
												group_type_data = display_data,
												type_data = group_description.type_data,
												override_data = override_data,
												min = min,
												max = max,
												value = current
											}
										end
									end
								end
							end
						end

						table.clear(grouped_stats)
					end
				end
			end

			for group_name, group_data in pairs(late_groups) do
				local group_description = WeaponTweakStatsUIDataGroups[group_name]
				local func = group_data.func or group_description.func
				local override_data = group_data.type_data or EMPTY_TABLE
				local min, max, current = func(late_group_stats, weapon_stats)

				if min ~= max then
					stat_n = stat_n + 1
					entry[stat_n] = {
						group_type_data = EMPTY_TABLE,
						type_data = group_description.type_data,
						override_data = override_data,
						min = min,
						max = max,
						value = current
					}
				end
			end

			table.clear(late_group_stats)
			table.clear(late_groups)

			bar_breakdown[base_stat_idx] = entry
		end

		self._weapon_statistics.bar_breakdown = bar_breakdown
	end
end

WeaponStats.calculate_stats = function (self, weapon_template, weapon_tweak_templates, damage_profile_lerp_values)
	local breed_or_nil, hit_zone_name, target_toughness_extension
	local armor_type = ArmorSettings.types.unarmored
	local breed_name = "chaos_poxwalker"
	local breed = Breeds[breed_name]
	local attacker_stat_buffs = {}
	local target_stat_buffs = {}
	local target_buff_extension
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
	local rate_of_fire
	local template_types = WeaponTweakTemplateSettings.template_types
	local ammo_templates = weapon_tweak_templates[template_types.ammo]
	local ammo_template_name = weapon_template.ammo_template or "none"
	local ammo_template = ammo_templates[ammo_template_name]
	local stamina_templates = weapon_tweak_templates[template_types.stamina]
	local stamina_template_name = weapon_template.stamina_template or "none"
	local stamina_template = stamina_templates[stamina_template_name]
	local ammo_clip_size, ammo_reserve_size

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
	local reload_time = 0
	local entry_actions = weapon_template.entry_actions
	local is_ranged_weapon = self:_is_weapon_template_ranged(weapon_template)
	local target_index = is_ranged_weapon and "default_target" or 1
	local weapon_handling = weapon_tweak_templates[template_types.weapon_handling]
	local charge_settings = weapon_tweak_templates[template_types.charge]
	local reload_start_ammo_refil = 0
	local reload_start_time
	local reload_loop_ammo_refil = 0
	local reload_loop_time, reload_start_scale, reload_loop_scale, reload_scale
	local charge_duration = 0

	for action_name, action in pairs(actions) do
		local kind = action.kind
		local action_time_scale = 1

		if weapon_handling then
			local _, lerped_identifier = WeaponTweakTemplates.get_template_identifiers(weapon_template, template_types.weapon_handling, action_name)

			if lerped_identifier then
				local action_stats = weapon_handling[lerped_identifier]

				action_time_scale = action_stats and action_stats.time_scale or action_time_scale
			end
		end

		local total_time = action.total_time / action_time_scale

		if is_ranged_weapon then
			if kind == "reload_state" then
				reload_time = total_time
				reload_scale = action_time_scale
			end

			if kind == "reload_shotgun" then
				local refill_amount = action.reload_settings.refill_amount

				if action.start_input then
					reload_start_time = total_time
					reload_start_ammo_refil = refill_amount
					reload_start_scale = action_time_scale
				else
					reload_loop_time = total_time
					reload_loop_ammo_refil = refill_amount
					reload_loop_scale = action_time_scale
				end
			end

			if action.start_input == "charge" and charge_settings then
				local _, lerped_identifier = WeaponTweakTemplates.get_template_identifiers(weapon_template, template_types.charge, action_name)
				local action_stats = charge_settings[lerped_identifier]

				if action_stats then
					charge_duration = action_stats.charge_duration
				end
			end
		end

		if not entry_actions or entry_actions.primary_action == action_name then
			local damage_profile = Action.damage_template(action)
			local attack_type = AttackSettings.attack_types.melee

			if total_time and total_time > 1000 then
				total_time = 0
			end

			if damage_profile then
				local weapon_handling_templates = weapon_tweak_templates[template_types.weapon_handling]
				local weapon_handling_template_name = weapon_template.actions[action_name].weapon_handling_template or "none"
				local weapon_handling_template = weapon_handling_templates[weapon_handling_template_name]
				local damage_type = damage_profile.damage_type
				local fire_rate = weapon_handling_template and weapon_handling_template.fire_rate
				local _, lerped_identifier = WeaponTweakTemplates.get_template_identifiers(weapon_template, template_types.weapon_handling, action_name)

				if lerped_identifier then
					local action_stats = weapon_handling[lerped_identifier]

					fire_rate = action_stats.fire_rate
				end

				if fire_rate and ammo_clip_size or action.charge_template and action.start_input == "shoot_pressed" or action.ammunition_usage and action.fire_configuration then
					local auto_fire_time = fire_rate and fire_rate.auto_fire_time

					if auto_fire_time then
						rate_of_fire = auto_fire_time

						if weapon_handling then
							local _, lerped_identifier = WeaponTweakTemplates.get_template_identifiers(weapon_template, template_types.weapon_handling, action_name)

							if lerped_identifier then
								local action_stats = weapon_handling[lerped_identifier]

								if action_stats then
									rate_of_fire = action_stats.fire_rate.auto_fire_time
								end
							end
						end
					else
						local chain_actions = action.allowed_chain_actions

						for chain_input, chain_data in pairs(chain_actions) do
							if action_name == chain_data.action_name then
								rate_of_fire = math.min(chain_data.chain_time or math.huge, total_time) / action_time_scale

								break
							end
						end

						rate_of_fire = rate_of_fire or total_time / action_time_scale
					end
				end

				local num_damage_iterations = 1

				if is_ranged_weapon and ammo_clip_size then
					num_damage_iterations = ammo_clip_size
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
						local target_unit, attacker_breed_or_nil
						local hit_shield = false
						local dropoff_scalar = DamageProfile.dropoff_scalar(distance, damage_profile, target_damage_values)
						local damage, damage_efficiency = DamageCalculation.calculate(damage_profile, damage_type, target_settings, target_damage_values, hit_zone_name, power_level, charge_level, breed_or_nil, attacker_breed_or_nil, is_critical_strike, hit_weakspot, hit_shield, is_backstab, is_flanking, dropoff_scalar, attack_type, attacker_stat_buffs, target_stat_buffs, target_buff_extension, armor_penetrating, target_toughness_extension, armor_type, stagger_count, num_triggered_staggers, is_attacked_unit_suppressed, distance, target_unit, auto_completed_action)

						damage = damage * num_damage_iterations

						if damage > 0 then
							num_targets_total_damage = num_targets_total_damage + damage
							num_targets_counted = num_targets_counted + 1
						end

						local stagger_strength_pool = 0
						local stagger_reduction_override_or_nil, optional_stagger_strength_multiplier
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
	local stats = {}

	stats.name = weapon_template.name
	stats.is_ranged_weapon = is_ranged_weapon
	stats.type = is_ranged_weapon and "Ranged" or "Melee"
	stats.uses_ammunition = uses_ammunition
	stats.uses_overheat = uses_overheat
	stats.charge_duration = charge_duration

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
			stats.rate_of_fire = rate_of_fire
			stats.bullets_per_second = 0

			if reload_time and ammo_clip_size then
				if reload_loop_time and reload_start_time then
					local ammo_to_refill = math.ceil((ammo_clip_size - reload_start_ammo_refil) / reload_loop_ammo_refil)

					stats.reload_time = reload_start_time + reload_loop_time * ammo_to_refill
					stats.base_reload_time = reload_start_time * reload_start_scale + reload_loop_time * reload_loop_scale * ammo_to_refill
					stats.base_reload_start_time = reload_start_time * reload_start_scale
					stats.base_reload_loop_time = reload_loop_time * reload_loop_scale
					stats.reload_start_ammo_refill = reload_start_ammo_refil
					stats.reload_loop_ammo_refill = reload_loop_ammo_refil
				else
					stats.reload_time = reload_time
					stats.base_reload_time = reload_time * reload_scale

					if ammo_clip_size == 1 then
						stats.rate_of_fire = reload_time
					end
				end
			end
		else
			stats.attack_speed = average_action_duration
		end
	end

	if uses_ammunition and ammo_clip_size and ammo_reserve_size then
		stats.ammo = ammo_clip_size
		stats.ammo_reserve = ammo_reserve_size
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

			min_stats[stat_name] = min_stats[stat_name] and min_compare_stat > min_stats[stat_name] and min_stats[stat_name] or min_compare_stat
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
				local description = stat_template.description

				values[#values + 1] = {
					min = 0,
					max = 1,
					display_name = display_name,
					description = description,
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
		},
		attack_speed = self._attack_speed,
		rate_of_fire = self._rate_of_fire,
		reload_time = self._reload_time,
		charge_duration = self._charge_duration
	}
end

local function _calculcate_action_damage(action_power_level, damage_profile, current_hit_lerp_values, target_index, charge_level, dropoff_scalar, attack_settings)
	local target_settings = DamageProfile.target_settings(damage_profile, target_index)
	local armor_penetrating = false

	if target_settings.power_level_multiplier then
		local power_level_lerp_value = DamageProfile.lerp_value_from_path(current_hit_lerp_values, "targets", 1, "power_level_multiplier")

		action_power_level = action_power_level * DamageProfile.lerp_damage_profile_entry(target_settings.power_level_multiplier, power_level_lerp_value)
	end

	local scaled_base_attack_power, scaled_base_impact_power = DamageCalculation.base_ui_damage(damage_profile, target_settings, action_power_level, charge_level, dropoff_scalar, current_hit_lerp_values)
	local attack_settings_size = #attack_settings
	local num_armor_types = attack_settings_size / 3
	local attack_idx = 1
	local attack = Script.new_array(num_armor_types * 2 * 4)
	local impact = Script.new_array(num_armor_types * 2 * 4)

	attack.base_power = scaled_base_attack_power
	impact.base_power = scaled_base_impact_power

	for i = 1, attack_settings_size, 3 do
		local armor_type = attack_settings[i]
		local attack_flags = attack_settings[i + 1]
		local impact_flags = attack_settings[i + 2]
		local finesse_mult = DamageCalculation.ui_finesse_multiplier(damage_profile, target_settings, armor_type, true, false, current_hit_lerp_values)
		local crit_mult = DamageCalculation.ui_finesse_multiplier(damage_profile, target_settings, armor_type, false, true, current_hit_lerp_values)
		local finesse_crit_mult = DamageCalculation.ui_finesse_multiplier(damage_profile, target_settings, armor_type, true, true, current_hit_lerp_values)
		local normal_dmg = 0
		local finnesse_dmg = 0
		local crit_dmg = 0
		local crit_finesse_dmg = 0
		local armor_mod = DamageProfile.armor_damage_modifier("attack", damage_profile, target_settings, current_hit_lerp_values, armor_type, false, dropoff_scalar, armor_penetrating)

		if bit.band(attack_flags, DAMAGE_BODY) == DAMAGE_BODY then
			normal_dmg = scaled_base_attack_power * armor_mod
		end

		if bit.band(attack_flags, DAMAGE_FINESSE) == DAMAGE_FINESSE then
			local armor_mod_crit = DamageProfile.armor_damage_modifier("attack", damage_profile, target_settings, current_hit_lerp_values, armor_type, true, dropoff_scalar, armor_penetrating)

			finnesse_dmg = scaled_base_attack_power * armor_mod * finesse_mult
			crit_dmg = scaled_base_attack_power * armor_mod_crit * crit_mult
			crit_finesse_dmg = scaled_base_attack_power * armor_mod_crit * finesse_crit_mult
		end

		attack[attack_idx] = normal_dmg
		attack[attack_idx + 1] = finnesse_dmg
		attack[attack_idx + 2] = crit_dmg
		attack[attack_idx + 3] = crit_finesse_dmg

		local normal_imp = 0
		local finnesse_imp = 0
		local crit_imp = 0
		local crit_finesse_imp = 0
		local impact_armor_mod = DamageProfile.armor_damage_modifier("impact", damage_profile, target_settings, current_hit_lerp_values, armor_type, false, dropoff_scalar, armor_penetrating)

		if bit.band(impact_flags, DAMAGE_BODY) == DAMAGE_BODY then
			normal_imp = scaled_base_impact_power * impact_armor_mod
		end

		if bit.band(impact_flags, DAMAGE_FINESSE) == DAMAGE_FINESSE then
			local impact_armor_mod_crit = DamageProfile.armor_damage_modifier("impact", damage_profile, target_settings, current_hit_lerp_values, armor_type, true, dropoff_scalar, armor_penetrating)

			finnesse_imp = scaled_base_impact_power * impact_armor_mod * finesse_mult
			crit_imp = scaled_base_impact_power * impact_armor_mod_crit * crit_mult
			crit_finesse_imp = scaled_base_impact_power * impact_armor_mod_crit * finesse_crit_mult
		end

		impact[attack_idx] = normal_imp
		impact[attack_idx + 1] = finnesse_imp
		impact[attack_idx + 2] = crit_imp
		impact[attack_idx + 3] = crit_finesse_imp
		attack_idx = attack_idx + 4
	end

	return attack, impact
end

local function _calculate_action_stats(action_name, damage_profile, weapon_template, lerp_values, damage_profile_leprs, action_stats_template)
	local stats = {}
	local stats_n = 0
	local damage_template_stats = action_stats_template.damage_profile_stats

	for stat_group_idx = 1, #damage_template_stats do
		local stat_group = damage_template_stats[stat_group_idx]
		local damage_profile_key = stat_group.damage_profile_key
		local group_data = damage_profile[damage_profile_key]

		for stat_ids = 1, #stat_group do
			local stat_data = stat_group[stat_ids]
			local stat_key = stat_data.stat_key
			local value = group_data[stat_key]
			local lerpable_value = type(value) == "table"

			if lerpable_value then
				local lerp_value = DamageProfile.lerp_value_from_path(damage_profile_leprs, damage_profile_key, stat_key)

				value = DamageProfile.lerp_damage_profile_entry(value, lerp_value)
			end

			stats_n = stats_n + 1
			stats[stats_n] = {
				value = value,
				type_data = stat_data
			}
		end
	end

	local action_stats = action_stats_template.per_action_stats

	for stat_group_idx = 1, #action_stats do
		local stat_group = action_stats[stat_group_idx]
		local stat_type_name = stat_group.template_type
		local stat_template = lerp_values[stat_type_name]
		local template_key_name = stat_group.template_key_name
		local action_stat_template_name = weapon_template.actions[action_name][template_key_name] or "none"
		local action_tweak_stats = stat_template[action_stat_template_name]
		local stat_group_name = stat_group.stat_group_name
		local action_tweak_stats_group = action_tweak_stats[stat_group_name]

		for stat_idx = 1, #stat_group do
			local stat_data = stat_group[stat_idx]
			local stat_key = stat_data.stat_key

			stats_n = stats_n + 1
			stats[stats_n] = {
				value = action_tweak_stats_group[stat_key],
				type_data = stat_data
			}
		end
	end

	return stats
end

function _get_display_data_from_path(display_stats, stat_data)
	local resolved_table = display_stats

	for i = 1, #stat_data - 1 do
		local path_name = stat_data[i]

		if resolved_table._array_range then
			local array_range = resolved_table._array_range
			local path_index = tonumber(path_name)

			if path_index >= array_range[1] and path_index <= array_range[2] then
				resolved_table = array_range
			else
				return nil
			end
		else
			resolved_table = resolved_table[path_name]

			if not resolved_table then
				return nil
			end
		end
	end

	return resolved_table
end

function _resolve_damage_template_lerps(weapon_template, target_name, stat_data, min, max, path_length_offset, optional_damage_profile)
	local actions = weapon_template.actions
	local action = actions and actions[target_name]

	if action then
		local damage_profile = optional_damage_profile or Action.damage_template(action)

		if damage_profile then
			local resolved_table = damage_profile

			for i = 1, #stat_data - (path_length_offset or 1) do
				local path_name = stat_data[i]

				resolved_table = resolved_table[path_name]

				if not resolved_table then
					break
				end
			end

			if resolved_table and type(resolved_table) == "table" then
				local resolved_min = min and DamageProfile.lerp_damage_profile_entry(resolved_table, min)
				local resolved_max = max and DamageProfile.lerp_damage_profile_entry(resolved_table, max)

				return resolved_min, resolved_max
			else
				return resolved_table, resolved_table
			end
		end
	end

	return min, max
end

function _resolve_explosion_template_lerps(weapon_template, target_name, stat_data, min, max, path_length_offset, optional_explosion_template)
	local actions = weapon_template.actions
	local action = actions and actions[target_name]

	if action or optional_explosion_template then
		local explosion_template = optional_explosion_template or Action.explosion_template(action)

		if explosion_template then
			local resolved_table = explosion_template

			for i = 1, #stat_data - (path_length_offset or 1) do
				local path_name = stat_data[i]

				resolved_table = resolved_table[path_name]

				if not resolved_table then
					break
				end
			end

			if resolved_table and type(resolved_table) == "table" then
				local resolved_min = min and DamageProfile.lerp_damage_profile_entry(resolved_table, min)
				local resolved_max = max and DamageProfile.lerp_damage_profile_entry(resolved_table, max)

				return resolved_min, resolved_max
			else
				return resolved_table, resolved_table
			end
		end
	end

	return min, max
end

function _get_weapon_stats(weapon_template, lerp_values, damage_profile_lerp_values, stats_to_represent)
	local stats = {}
	local stats_n = 0

	for stat_group_idx = 1, #stats_to_represent do
		local stat_data = stats_to_represent[stat_group_idx]
		local template_type = stat_data.template_type
		local target_name = stat_data.target
		local ui_data = WeaponTweakTemplates.get_stat_ui_data(template_type, stat_data, 0)

		if ui_data then
			local current

			if template_type == template_types.damage then
				local resolved_table = damage_profile_lerp_values[target_name]

				if resolved_table then
					for i = 1, #stat_data do
						local path = stat_data[i]

						resolved_table = resolved_table[path]

						if not resolved_table then
							resolved_table = WeaponTweakTemplateSettings.DEFALT_FALLBACK_LERP_VALUE

							break
						end
					end
				end

				local default_lerp = WeaponTweakTemplateSettings.DEFALT_FALLBACK_LERP_VALUE

				current = _resolve_damage_template_lerps(weapon_template, target_name, stat_data, resolved_table or default_lerp, nil, 0)
			else
				local base_identifier, lerped_identifier = WeaponTweakTemplates.get_template_identifiers(weapon_template, template_type, target_name)
				local resolved_table = lerp_values[template_type][lerped_identifier]

				if resolved_table then
					for i = 1, #stat_data do
						local path = stat_data[i]

						resolved_table = resolved_table[path]

						if not resolved_table then
							break
						end
					end
				end

				current = resolved_table
			end

			if current then
				local rounding_func = ui_data.rounding

				if rounding_func then
					current = rounding_func(current)
				end

				stats_n = stats_n + 1
				stats[stats_n] = {
					type_data = ui_data,
					value = current
				}

				local ui_identifier = stat_data.ui_identifier

				if ui_identifier then
					stats[ui_identifier] = stats[stats_n]
				end
			end
		end
	end

	return stats
end

local function _calculate_power_stat(action, action_name, damage_profile, power_level, damage_profile_lerp_values, target_index, charge_level, dropoff_scalar)
	local target_settings = DamageProfile.target_settings(damage_profile, target_index)
	local damage_profile_name = damage_profile.name
	local cur_lerps = damage_profile_lerp_values[action_name] and damage_profile_lerp_values[action_name] or EMPTY_TABLE

	cur_lerps = cur_lerps[damage_profile_name] or cur_lerps

	local targets = cur_lerps.targets
	local target_settings_lerp_values = targets and (targets[target_index] or targets.default_target) or EMPTY_TABLE
	local old_current_target_settings_lerp_values = cur_lerps.current_target_settings_lerp_values

	cur_lerps.current_target_settings_lerp_values = target_settings_lerp_values

	if target_settings.power_level_multiplier then
		local power_level_lerp_value = DamageProfile.lerp_value_from_path(cur_lerps, "targets", 1, "power_level_multiplier")

		power_level = power_level * DamageProfile.lerp_damage_profile_entry(target_settings.power_level_multiplier, power_level_lerp_value)
	end

	local scaled_base_attack_power, scaled_base_impact_power = DamageCalculation.base_ui_damage(damage_profile, target_settings, power_level, charge_level, dropoff_scalar, cur_lerps)

	cur_lerps.current_target_settings_lerp_values = old_current_target_settings_lerp_values

	return scaled_base_attack_power, scaled_base_impact_power
end

local function _get_weapon_power_stats(weapon_template, damage_profile_lerp_values, actions_to_represent)
	local weapon_actions = weapon_template.actions
	local power_stats = {}
	local power_stats_n = 0

	for action_idx = 1, #actions_to_represent do
		local action_data = actions_to_represent[action_idx]
		local action_name = action_data.action_name
		local target_index = action_data.target_index
		local charge_level = action_data.charge_level
		local dropoff_scalar = action_data.dropoff_scalar
		local action = weapon_actions[action_name]
		local damage_profile, special_damage_profile = Action.damage_template(action)
		local explosion_template = Action.explosion_template(action)

		if damage_profile then
			local action_power_level = Action.power_level(action)
			local scaled_base_attack_power, scaled_base_impact_power = _calculate_power_stat(action, action_name, damage_profile, action_power_level, damage_profile_lerp_values, target_index, charge_level, dropoff_scalar)

			if explosion_template then
				local inner = explosion_template.close_damage_profile

				if inner and inner ~= damage_profile then
					local explosion_power = explosion_template.static_power_level or action_power_level
					local explosion_scaled_base_attack_power, explosion_scaled_base_impact_power = _calculate_power_stat(action, action_name, inner, explosion_power, damage_profile_lerp_values, target_index, charge_level, dropoff_scalar)

					scaled_base_attack_power = scaled_base_attack_power + explosion_scaled_base_attack_power
					scaled_base_impact_power = scaled_base_impact_power + explosion_scaled_base_impact_power
				end
			end

			power_stats_n = power_stats_n + 1
			power_stats[power_stats_n] = {
				attack = scaled_base_attack_power,
				impact = scaled_base_impact_power,
				type_data = action_data
			}
		end
	end

	return power_stats
end

local function _calculate_damage(weapon_template, action, action_name, action_data, damage_profile, explosion_template, damage_profile_lerp_values, lerp_values, target_index, charge_level, dropoff_scalar)
	local action_power_level = Action.power_level(action)
	local damage_profile_name = damage_profile.name
	local cur_lerps = damage_profile_lerp_values[action_name] and damage_profile_lerp_values[action_name] or EMPTY_TABLE

	cur_lerps = cur_lerps[damage_profile_name] or cur_lerps

	local targets = cur_lerps.targets
	local target_settings_lerp_values = targets and (targets[target_index] or targets.default_target) or EMPTY_TABLE
	local old_current_target_settings_lerp_values = cur_lerps.current_target_settings_lerp_values

	cur_lerps.current_target_settings_lerp_values = target_settings_lerp_values

	local attack, impact = _calculcate_action_damage(action_power_level, damage_profile, cur_lerps, target_index, charge_level, dropoff_scalar, action_data.attack, action_data.impact)

	cur_lerps.current_target_settings_lerp_values = old_current_target_settings_lerp_values

	if explosion_template then
		local inner = explosion_template.close_damage_profile

		if inner and inner ~= damage_profile then
			damage_profile_name = inner.name
			cur_lerps = damage_profile_lerp_values[action_name] and damage_profile_lerp_values[action_name] or EMPTY_TABLE
			cur_lerps = cur_lerps[damage_profile_name] or cur_lerps
			targets = cur_lerps.targets
			target_settings_lerp_values = targets and (targets[target_index] or targets.default_target) or EMPTY_TABLE
			old_current_target_settings_lerp_values = cur_lerps.current_target_settings_lerp_values
			cur_lerps.current_target_settings_lerp_values = target_settings_lerp_values

			local explosion_power = explosion_template.static_power_level or action_power_level
			local special_attack, special_impact = _calculcate_action_damage(explosion_power, inner, cur_lerps, target_index, charge_level, dropoff_scalar, action_data.attack, action_data.impact)

			for i = 1, #special_attack do
				attack[i] = attack[i] + special_attack[i]
				impact[i] = impact[i] + special_impact[i]
			end

			cur_lerps.current_target_settings_lerp_values = old_current_target_settings_lerp_values
		end
	end

	local action_stats = _calculate_action_stats(action_name, damage_profile, weapon_template, lerp_values, cur_lerps, action_data)

	return attack, impact, action_stats
end

function _calculate_weapon_statistics(weapon_template, lerp_values, damage_profile_lerp_values)
	local statistics_template = weapon_template.displayed_weapon_stats and WeaponUIStatsTemplates[weapon_template.displayed_weapon_stats] or weapon_template.displayed_weapon_stats_table

	if not statistics_template then
		return
	end

	local hit_types = {
		{
			display_name = "loc_weapon_details_body",
			name = "body"
		},
		{
			display_name = "loc_weapon_details_weakspot",
			name = "weakspot"
		},
		{
			display_name = "loc_weapon_details_crit",
			name = "critical"
		},
		{
			display_name = "loc_weapon_details_crit_hs",
			name = "critical weakspot"
		}
	}
	local stats = _get_weapon_stats(weapon_template, lerp_values, damage_profile_lerp_values, statistics_template.stats)
	local power_stats = _get_weapon_power_stats(weapon_template, damage_profile_lerp_values, statistics_template.power_stats)
	local damage = {}
	local out_stats = {
		stats = stats,
		damage = damage,
		power_stats = power_stats,
		hit_types = hit_types
	}
	local damage_stats = statistics_template.damage
	local weapon_actions = weapon_template.actions

	for action_idx = 1, #damage_stats do
		local chain_entry = {}
		local chain_data = damage_stats[action_idx]

		for chain_index = 1, #chain_data do
			local action_data = chain_data[chain_index]
			local action_name = action_data.action_name
			local action = weapon_actions[action_name]
			local entry = {
				type_data = action_data
			}
			local target_index = action_data.target_index
			local charge_level = action_data.charge_level
			local dropoff_scalar = action_data.dropoff_scalar
			local damage_profile = Action.damage_template(action)
			local explosion_template = Action.explosion_template(action)

			if damage_profile then
				local attack, impact, action_stats = _calculate_damage(weapon_template, action, action_name, action_data, damage_profile, explosion_template, damage_profile_lerp_values, lerp_values, target_index, charge_level, dropoff_scalar)

				entry.attack, entry.impact, entry.action_stats = attack, impact, action_stats
				chain_entry[#chain_entry + 1] = entry
			end
		end

		damage[#damage + 1] = chain_entry
	end

	return out_stats
end

return WeaponStats
