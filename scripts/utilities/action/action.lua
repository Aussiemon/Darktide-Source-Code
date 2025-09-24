-- chunkname: @scripts/utilities/action/action.lua

local MultiFireModes = require("scripts/settings/equipment/weapon_templates/multi_fire_modes")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local Action = {}

Action.current_action = function (weapon_action_component, weapon_template)
	local current_action_name = weapon_action_component.current_action_name

	if current_action_name == "none" then
		return "none", nil
	end

	if not weapon_template then
		return "none", nil
	end

	local current_action_settings = Action.action_settings(weapon_template, current_action_name)

	return current_action_name, current_action_settings
end

Action.previous_action = function (weapon_action_component, weapon_template)
	local action_name = weapon_action_component.previous_action_name

	if action_name == "none" then
		return "none", nil
	end

	if not weapon_template then
		return "none", nil
	end

	local action_settings = Action.action_settings(weapon_template, action_name)

	return action_name, action_settings
end

Action.action_settings = function (weapon_template, action_name)
	local action_settings = weapon_template.actions[action_name]

	return action_settings
end

Action.current_action_settings_from_component = function (weapon_action_component, weapon_actions)
	local current_action_name = weapon_action_component.current_action_name
	local action_settings = current_action_name and weapon_actions[current_action_name]

	return action_settings
end

Action.time_left = function (action_component, t)
	local is_infinite_duration = action_component.is_infinite_duration
	local end_t = is_infinite_duration and math.huge or action_component.end_t

	return end_t - t
end

local _fire_configs_temp = {}

Action.damage_template = function (action)
	local damage_profile = action.damage_profile or action.inner_damage_profile

	if damage_profile then
		local sticky_hit = action.hit_stickyness_settings_special_active or action.hit_stickyness_settings
		local special_damage_profile = sticky_hit and sticky_hit.damage.last_damage_profile or action.damage_profile_special_active

		return damage_profile, special_damage_profile
	end

	local fire_configurations = action.fire_configurations

	if not fire_configurations then
		_fire_configs_temp[1] = action.fire_configuration
		fire_configurations = _fire_configs_temp
	end

	local fire_configuration, damage_template

	for i = 1, #fire_configurations do
		local current_fire_config = fire_configurations[i]
		local current_damage_template

		if current_fire_config.flamer_gas_template then
			current_damage_template = current_fire_config.flamer_gas_template.damage
		elseif current_fire_config.hit_scan_template then
			current_damage_template = current_fire_config.hit_scan_template.damage
		elseif current_fire_config.projectile then
			current_damage_template = current_fire_config.projectile.damage
		elseif current_fire_config.shotshell then
			current_damage_template = current_fire_config.shotshell.damage
		end

		damage_template = current_damage_template
		fire_configuration = current_fire_config
	end

	if damage_template then
		if fire_configuration.shotshell_special then
			return damage_template.impact.damage_profile, fire_configuration.shotshell_special.damage.impact.damage_profile
		end

		local damage_impact = damage_template.impact

		if damage_impact then
			local explosion_template = damage_impact.explosion_template

			return damage_impact.damage_profile, explosion_template and explosion_template.close_damage_profile
		end
	end

	local fire_configuration = action.fire_configuration or action.fire_configurations and action.fire_configurations[1]

	if fire_configuration then
		-- Nothing
	end

	local projectile_template = action.projectile_template

	if projectile_template then
		return projectile_template.damage.impact.damage_profile
	end

	local explosion_template = action.explosion_template

	if explosion_template then
		return explosion_template.close_damage_profile or explosion_template.damage_profile
	end
end

Action.explosion_template = function (action)
	local fire_configurations = action.fire_configurations

	if not fire_configurations then
		_fire_configs_temp[1] = action.fire_configuration
		fire_configurations = _fire_configs_temp
	end

	local damage_template

	for i = 1, #fire_configurations do
		local current_fire_config = fire_configurations[i]
		local current_damage_template

		if current_fire_config.flamer_gas_template then
			current_damage_template = current_fire_config.flamer_gas_template.damage
		elseif current_fire_config.hit_scan_template then
			current_damage_template = current_fire_config.hit_scan_template.damage
		elseif current_fire_config.projectile then
			current_damage_template = current_fire_config.projectile.damage
		elseif current_fire_config.shotshell then
			current_damage_template = current_fire_config.shotshell.damage
		end

		damage_template = current_damage_template
	end

	if damage_template then
		local damage_impact = damage_template.impact

		if damage_impact then
			local explosion_template = damage_impact.explosion_template

			if explosion_template then
				return explosion_template
			end
		end
	end

	local projectile_template = action.projectile_template

	if projectile_template then
		local damage = projectile_template.damage

		if damage then
			local impact = damage.impact

			if impact then
				local explosion_template = impact.explosion_template

				if explosion_template then
					return explosion_template
				end
			end
		end
	end

	local explosion_template = action.explosion_template

	if explosion_template then
		return explosion_template
	end
end

Action.power_level = function (action)
	local power_level = action.power_level

	if not power_level then
		local fire_configurations = action.fire_configurations

		if not fire_configurations then
			_fire_configs_temp[1] = action.fire_configuration
			fire_configurations = _fire_configs_temp
		end

		for i = 1, #fire_configurations do
			local current_fire_config = fire_configurations[i]
			local current_power_level

			if current_fire_config.flamer_gas_template then
				current_power_level = current_fire_config.flamer_gas_template.power_level
			elseif current_fire_config.hit_scan_template then
				current_power_level = current_fire_config.hit_scan_template.power_level
			elseif current_fire_config.projectile then
				current_power_level = current_fire_config.projectile.power_level
			elseif current_fire_config.shotshell then
				current_power_level = current_fire_config.shotshell.power_level
			end

			power_level = current_power_level
		end
	end

	return power_level or DEFAULT_POWER_LEVEL
end

Action.stat_power_level = function (action)
	local power_level = action.stat_power_level

	if not power_level then
		local fire_configurations = action.fire_configurations

		if not fire_configurations then
			_fire_configs_temp[1] = action.fire_configuration
			fire_configurations = _fire_configs_temp
		end

		for i = 1, #fire_configurations do
			local current_fire_config = fire_configurations[i]
			local current_power_level

			if current_fire_config.flamer_gas_template then
				current_power_level = current_fire_config.flamer_gas_template.stat_power_level
			elseif current_fire_config.hit_scan_template then
				current_power_level = current_fire_config.hit_scan_template.stat_power_level
			elseif current_fire_config.projectile then
				current_power_level = current_fire_config.projectile.stat_power_level
			elseif current_fire_config.shotshell then
				current_power_level = current_fire_config.shotshell.stat_power_level
			end

			power_level = current_power_level
		end
	end

	return power_level or Action.power_level(action)
end

return Action
