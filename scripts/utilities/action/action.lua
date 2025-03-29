-- chunkname: @scripts/utilities/action/action.lua

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

Action.damage_template = function (action)
	local damage_profile = action.damage_profile or action.inner_damage_profile

	if damage_profile then
		local sticky_hit = action.hit_stickyness_settings_special_active or action.hit_stickyness_settings
		local special_damage_profile = sticky_hit and sticky_hit.damage.last_damage_profile or action.damage_profile_special_active

		return damage_profile, special_damage_profile
	end

	local fire_configuration = action.fire_configuration

	if fire_configuration then
		local damage_template

		if fire_configuration.flamer_gas_template then
			damage_template = fire_configuration.flamer_gas_template.damage
		elseif fire_configuration.hit_scan_template then
			damage_template = fire_configuration.hit_scan_template.damage
		elseif fire_configuration.projectile then
			damage_template = fire_configuration.projectile.damage
		elseif fire_configuration.shotshell then
			damage_template = fire_configuration.shotshell.damage

			if fire_configuration.shotshell_special then
				return damage_template.impact.damage_profile, fire_configuration.shotshell_special.damage.impact.damage_profile
			end
		end

		if damage_template then
			local damage_impact = damage_template.impact

			if damage_impact then
				local explosion_template = damage_impact.explosion_template

				return damage_impact.damage_profile, explosion_template and explosion_template.close_damage_profile
			end
		end
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
	local fire_configuration = action.fire_configuration

	if fire_configuration then
		local damage_template

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

			if damage_impact then
				local explosion_template = damage_impact.explosion_template

				if explosion_template then
					return explosion_template
				end
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
		local fire_configuration = action.fire_configuration

		if fire_configuration then
			if fire_configuration.flamer_gas_template then
				power_level = fire_configuration.flamer_gas_template.power_level
			elseif fire_configuration.hit_scan_template then
				power_level = fire_configuration.hit_scan_template.power_level
			elseif fire_configuration.projectile then
				power_level = fire_configuration.projectile.power_level
			elseif fire_configuration.shotshell then
				power_level = fire_configuration.shotshell.power_level
			end
		end
	end

	return power_level or DEFAULT_POWER_LEVEL
end

Action.stat_power_level = function (action)
	local power_level = action.stat_power_level

	if not power_level then
		local fire_configuration = action.fire_configuration

		if fire_configuration then
			if fire_configuration.flamer_gas_template then
				power_level = fire_configuration.flamer_gas_template.stat_power_level
			elseif fire_configuration.hit_scan_template then
				power_level = fire_configuration.hit_scan_template.stat_power_level
			elseif fire_configuration.projectile then
				power_level = fire_configuration.projectile.stat_power_level
			elseif fire_configuration.shotshell then
				power_level = fire_configuration.shotshell.stat_power_level
			end
		end
	end

	return power_level or Action.power_level(action)
end

return Action
