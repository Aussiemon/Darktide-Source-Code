local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local _check_power_distribution, _check_power_distribution_ranged, _check_cleave_distribution, _check_armor_damage_modifier, _check_armor_damage_modifier_ranged, _check_critical_strike, _check_crit_mod, _check_target, _check_power_level = nil

local function damage_profile_tests(damage_profiles)
	local success = true
	local error_msg = ""

	for name, damage_profile in pairs(damage_profiles) do
		local damage_profile_success = true
		local damage_profile_error_msg = string.format("DamageProfile %q\n", name)

		if not damage_profile.stagger_category then
			damage_profile_success = false
			damage_profile_error_msg = damage_profile_error_msg .. "\tmissing stagger_category.\n"
		end

		local power_distribution_success, power_distribution_error_msg = _check_power_distribution(damage_profile.power_distribution)

		if not power_distribution_success then
			damage_profile_success = false
			damage_profile_error_msg = damage_profile_error_msg .. power_distribution_error_msg
		end

		local power_distribution_ranged_success, power_distribution_ranged_error_msg = _check_power_distribution_ranged(damage_profile.power_distribution_ranged)

		if not power_distribution_ranged_success then
			damage_profile_success = false
			damage_profile_error_msg = damage_profile_error_msg .. power_distribution_ranged_error_msg
		end

		local cleave_distribution_success, cleave_distribution_error_msg = _check_cleave_distribution(damage_profile.power_distribution)

		if not cleave_distribution_success then
			damage_profile_success = false
			damage_profile_error_msg = damage_profile_error_msg .. cleave_distribution_error_msg
		end

		local armor_damage_modifier_success, armor_damage_modifier_error_msg = _check_armor_damage_modifier(damage_profile.armor_damage_modifier)

		if not armor_damage_modifier_success then
			damage_profile_success = false
			damage_profile_error_msg = damage_profile_error_msg .. armor_damage_modifier_error_msg
		end

		local armor_damage_modifier_ranged_success, armor_damage_modifier_ranged_error_msg = _check_armor_damage_modifier_ranged(damage_profile.armor_damage_modifier_ranged)

		if not armor_damage_modifier_ranged_success then
			damage_profile_success = false
			damage_profile_error_msg = damage_profile_error_msg .. armor_damage_modifier_ranged_error_msg
		end

		local check_power_level_success, check_power_level_error_msg = _check_power_level(damage_profile.power_level)

		if not check_power_level_success then
			damage_profile_success = false
			damage_profile_error_msg = damage_profile_error_msg .. check_power_level_error_msg
		end

		local critical_strike_success, critical_strike_error_msg = _check_critical_strike(damage_profile.critical_strike)

		if not critical_strike_success then
			damage_profile_success = false
			damage_profile_error_msg = damage_profile_error_msg .. critical_strike_error_msg
		end

		local crit_mod_success, crit_mod_error_msg = _check_crit_mod(damage_profile.crit_mod)

		if not crit_mod_success then
			damage_profile_success = false
			damage_profile_error_msg = damage_profile_error_msg .. crit_mod_error_msg
		end

		local targets = damage_profile.targets

		if targets then
			if not targets.default_target then
				damage_profile_success = false
				damage_profile_error_msg = damage_profile_error_msg .. "\tno default_target in targets table.\n"
			end

			local default_target_success, default_target_error_msg = _check_target(targets.default_target, "default_target")

			if not default_target_success then
				damage_profile_success = false
				damage_profile_error_msg = damage_profile_error_msg .. default_target_error_msg
			end

			for i = 1, #targets, 1 do
				local target_success, target_error_msg = _check_target(targets[i], i)

				if not target_success then
					damage_profile_success = false
					damage_profile_error_msg = damage_profile_error_msg .. target_error_msg
				end
			end
		else
			damage_profile_success = false
			damage_profile_error_msg = damage_profile_error_msg .. "\tno targets table.\n"
		end

		if not damage_profile_success then
			success = false
			error_msg = error_msg .. damage_profile_error_msg .. "\n"
		end
	end

	return success, error_msg
end

function _check_power_distribution(power_distribution)
	local success = true
	local error_msg = ""

	if power_distribution then
		if not power_distribution.attack then
			success = false
			error_msg = error_msg .. "\tpower_distribution is missing attack value. won't be able to calculate damage.\n"
		end

		if not power_distribution.impact then
			success = false
			error_msg = error_msg .. "\tpower_distribution is missing impact value. won't be able to calculate stagger\n"
		end
	end

	return success, error_msg
end

function _check_power_distribution_ranged(power_distribution_ranged)
	local success = true
	local error_msg = ""

	if power_distribution_ranged then
		if not power_distribution_ranged.attack then
			success = false
			error_msg = error_msg .. "\tpower_distribution_ranged is missing attack value. won't be able to calculate damage.\n"
		end

		if not power_distribution_ranged.impact then
			success = false
			error_msg = error_msg .. "\tpower_distribution_ranged is missing impact value. won't be able to calculate stagger\n"
		end
	end

	return success, error_msg
end

function _check_cleave_distribution(cleave_distribution)
	local success = true
	local error_msg = ""

	if cleave_distribution then
		if not cleave_distribution.attack then
			success = false
			error_msg = error_msg .. "\tcleave_distribution is missing attack value. won't be able to calculate max_targets.\n"
		end

		if not cleave_distribution.impact then
			success = false
			error_msg = error_msg .. "\tcleave_distribution is missing impact value. won't be able to calculate max_targets.\n"
		end
	end

	return success, error_msg
end

function _check_power_level(power_level)
	local success = true
	local error_msg = ""

	if power_level then
		success = false
		error_msg = error_msg .. "\tpower_level is missing\n"
	end

	return success, error_msg
end

function _check_armor_damage_modifier(armor_damage_modifier)
	local success = true
	local error_msg = ""

	if armor_damage_modifier then
		if armor_damage_modifier.attack then
			for _, armor_type in pairs(armor_types) do
				if not armor_damage_modifier.attack[armor_type] then
					success = false
					error_msg = error_msg .. string.format("\tarmor_damage_modifier.attack is missing value for armor_type %q\n", armor_type)
				end
			end
		else
			success = false
			error_msg = error_msg .. "\tarmor_damage_modifier is missing attack table, won't be able to calculate damage.\n"
		end

		if armor_damage_modifier.impact then
			for _, armor_type in pairs(armor_types) do
				if not armor_damage_modifier.impact[armor_type] then
					success = false
					error_msg = error_msg .. string.format("\tarmor_damage_modifier.impact is missing value for armor_type %q\n", armor_type)
				end
			end
		else
			success = false
			error_msg = error_msg .. "\tarmor_damage_modifier is missing impact table, won't be able to calculate stagger.\n"
		end
	end

	return success, error_msg
end

function _check_armor_damage_modifier_ranged(armor_damage_modifier_ranged)
	local success = true
	local error_msg = ""

	if armor_damage_modifier_ranged then
		if armor_damage_modifier_ranged.near then
			if armor_damage_modifier_ranged.near.attack then
				for _, armor_type in pairs(armor_types) do
					if not armor_damage_modifier_ranged.near.attack[armor_type] then
						success = false
						error_msg = error_msg .. string.format("\tarmor_damage_modifier_ranged.near.attack is missing table for armor_type %q", armor_type)
					end
				end
			else
				success = false
				error_msg = error_msg .. string.format("\tarmor_damage_modifier_ranged.near does not have attack table defined. won't be able to calculate damager\n")
			end

			if armor_damage_modifier_ranged.near.impact then
				for _, armor_type in pairs(armor_types) do
					if not armor_damage_modifier_ranged.near.impact[armor_type] then
						success = false
						error_msg = error_msg .. string.format("\tarmor_damage_modifier_ranged.near.impact is missing table for armor_type %q", armor_type)
					end
				end
			else
				success = false
				error_msg = error_msg .. string.format("\tarmor_damage_modifier_ranged.near does not have impact table defined. won't be able to calculate stagger\n")
			end
		else
			success = false
			error_msg = error_msg .. "\tarmor_damage_modifier_ranged is missing near table.\n"
		end

		if armor_damage_modifier_ranged.far then
			if armor_damage_modifier_ranged.far.attack then
				for _, armor_type in pairs(armor_types) do
					if not armor_damage_modifier_ranged.far.attack[armor_type] then
						success = false
						error_msg = error_msg .. string.format("\tarmor_damage_modifier_ranged.far.attack is missing table for armor_type %q", armor_type)
					end
				end
			else
				success = false
				error_msg = error_msg .. string.format("\tarmor_damage_modifier_ranged.far does not have attack table defined. won't be able to calculate damage.\n")
			end

			if armor_damage_modifier_ranged.far.impact then
				for _, armor_type in pairs(armor_types) do
					if not armor_damage_modifier_ranged.far.impact[armor_type] then
						success = false
						error_msg = error_msg .. string.format("\tarmor_damage_modifier_ranged.far.impact is missing table for armor_type %q", armor_type)
					end
				end
			else
				success = false
				error_msg = error_msg .. string.format("\tarmor_damage_modifier_ranged.far does not have impact table defined. won't be able to calculate stagger\n")
			end
		else
			success = false
			error_msg = error_msg .. "\tarmor_damage_modifier_ranged is missing far table.\n"
		end
	end

	return success, error_msg
end

function _check_critical_strike(critical_strike)
	local success = true
	local error_msg = ""

	if critical_strike then
		local critical_armor_damage_modifier = critical_strike.armor_damage_modifier

		if critical_armor_damage_modifier then
			success = false
			error_msg = error_msg .. string.format("\tcritical_strike.armor_damage_modifier is specified but no longer is use. use crit_mod instead.\n")
		end
	end

	return success, error_msg
end

local function _check_lerp_values(value)
	local current_type = type(value)

	if current_type == "number" then
		return true
	elseif current_type == "table" then
		local value1 = value[1]
		local value2 = value[2]
		local check1 = value1 and type(value1) == "number"
		local check2 = value2 and type(value2) == "number"

		return check1 and check2
	end

	return false
end

function _check_crit_mod(crit_mod)
	local success = true
	local error_msg = ""

	if crit_mod then
		local attack = crit_mod.attack

		if attack then
			for _, armor_type in pairs(armor_types) do
				local crit_mod = attack[armor_type]

				if not crit_mod then
					success = false
					error_msg = error_msg .. string.format("\tcrit_mod.attack is missing value for armor_type %q.\n", armor_type)
				elseif not _check_lerp_values(crit_mod) then
					success = false
					error_msg = error_msg .. string.format("\tcrit_mod.attack for armor type %q has incorrect format.\n", armor_type)
				end
			end
		else
			success = false
			error_msg = error_msg .. string.format("\tcrit_mod has no attack table. won't be able to calculate damage.\n")
		end

		local impact = crit_mod.impact

		if impact then
			for _, armor_type in pairs(armor_types) do
				local crit_mod = impact[armor_type]

				if not crit_mod then
					success = false
					error_msg = error_msg .. string.format("\tcrit_mod.impact is missing value for armor_type %q.\n", armor_type)
				elseif not _check_lerp_values(crit_mod) then
					success = false
					error_msg = error_msg .. string.format("\tcrit_mod.attack for armor type %q has incorrect format.\n", armor_type)
				end
			end
		else
			success = false
			error_msg = error_msg .. string.format("\tcrit_mod has no impact table. won't be able to calculate stagger.\n")
		end
	end

	return success, error_msg
end

function _check_target(target, target_identifier)
	local success = true
	local error_msg = string.format("\ttarget[%q]\n", target_identifier)
	local power_distribution_success, power_distribution_error_msg = _check_power_distribution(target.power_distribution)

	if not power_distribution_success then
		success = false
		error_msg = error_msg .. power_distribution_error_msg
	end

	local power_distribution_ranged_success, power_distribution_ranged_error_msg = _check_power_distribution_ranged(target.power_distribution_ranged)

	if not power_distribution_ranged_success then
		success = false
		error_msg = error_msg .. power_distribution_ranged_error_msg
	end

	return success, error_msg
end

return damage_profile_tests
