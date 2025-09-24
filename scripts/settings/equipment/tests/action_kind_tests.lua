-- chunkname: @scripts/settings/equipment/tests/action_kind_tests.lua

local action_kind_funcs = {}

local function _action_kind_tests(action_settings, weapon_template, action_name)
	local action_kind_func = action_kind_funcs[action_settings.kind]

	if action_kind_func then
		local success, error_msg = action_kind_func(action_settings, weapon_template, action_name)
	end
end

local function _check_time_scale_buffs(weapon_template, action_settings)
	local time_scale_stat_buffs = action_settings.time_scale_stat_buffs

	if time_scale_stat_buffs == nil then
		Log.warning("ActionKindTests", "Did not find 'time_scale_stat_buffs' table in action settings for %s -> %s, is this intended?", weapon_template.name, action_settings.name)
	end
end

action_kind_funcs.reload_shotgun = function (action_settings, weapon_template)
	if not action_settings.reload_settings then
		return false, "missing reload_settings in action_settings."
	end

	return true
end

action_kind_funcs.reload_state = function (action_settings, weapon_template)
	if not weapon_template.reload_template then
		return false, "missing reload_template in weapon_template."
	end

	return true
end

action_kind_funcs.ranged_wield = function (action_settings, weapon_template)
	if weapon_template.reload_template then
		if action_settings.anim_event then
			return false, "can't have \"anim_event\" specified for this action."
		end

		if not action_settings.wield_anim_event then
			return false, "missing \"wield_anim_event\" in action_settings."
		end

		if not action_settings.wield_reload_anim_event then
			return false, "missing \"wield_reload_anim_event\" in action_settings."
		end
	end

	return true
end

action_kind_funcs.aim = function (action_settings, weapon_template)
	if not weapon_template.alternate_fire_settings then
		return false, "missing \"alternate_fire_settings\" table in weapon_template."
	end

	return true
end

action_kind_funcs.sweep = function (action_settings, weapon_template)
	local num_frames_before_process = action_settings.num_frames_before_process
	local max_num_saved_entries = action_settings.max_num_saved_entries

	if num_frames_before_process and not max_num_saved_entries then
		return false, "\"num_frames_before_process\" needs \"max_num_saved_entries\" to be defined as well."
	end

	if max_num_saved_entries and not num_frames_before_process then
		return false, "\"max_num_saved_entries\" needs \"num_frames_before_process\" to be defined as well."
	end

	local hit_stickyness_settings = action_settings.hit_stickyness_settings

	if hit_stickyness_settings then
		local duration = hit_stickyness_settings.duration

		if not duration then
			return false, "\"hit_stickyness_settings\" requires \"duration\" specified."
		end

		local sensitivity_modifier = hit_stickyness_settings.sensitivity_modifier

		if not sensitivity_modifier then
			return false, "\"hit_stickyness_settings\" requires \"sensitivity_modifier\" specified."
		end
	end

	local sweeps = action_settings.sweeps

	if not sweeps then
		return false, "no \"sweeps\" table specified."
	end

	for ii = 1, #sweeps do
		local sweep = sweeps[ii]
		local matrices_data_location = sweep.matrices_data_location

		if not matrices_data_location then
			return false, string.format("sweep #%d has no \"matrices_data_location\" specified.", ii)
		end
	end

	_check_time_scale_buffs(weapon_template, action_settings)

	return true
end

action_kind_funcs.shoot_hit_scan = function (action_settings, weapon_template)
	_check_time_scale_buffs(weapon_template, action_settings)

	return true
end

action_kind_funcs.shoot_beam = function (action_settings, weapon_template)
	_check_time_scale_buffs(weapon_template, action_settings)

	return true
end

action_kind_funcs.shoot_hit_scan = function (action_settings, weapon_template)
	_check_time_scale_buffs(weapon_template, action_settings)

	return true
end

action_kind_funcs.shoot_pellets = function (action_settings, weapon_template)
	_check_time_scale_buffs(weapon_template, action_settings)

	return true
end

action_kind_funcs.shoot_projectile = function (action_settings, weapon_template)
	_check_time_scale_buffs(weapon_template, action_settings)

	return true
end

action_kind_funcs.spawn_projectile = function (action_settings, weapon_template)
	_check_time_scale_buffs(weapon_template, action_settings)

	local projectile_template = action_settings.projectile_template or weapon_template.projectile_template

	if not projectile_template then
		return false, "missing \"projectile_template\" in action_settings or weapon_template"
	end

	local projectile_locomotion_template = projectile_template.locomotion_template

	if not projectile_locomotion_template then
		return false, string.format("missing \"projectile_locomotion_template\" in projectile_template %q", projectile_template.name)
	end

	if not projectile_locomotion_template.spawn_projectile_parameters then
		return false, string.format("missing \"spawn_projectile_parameters\" in projectile_locomotion_template %q", projectile_locomotion_template.name)
	end

	return true
end

action_kind_funcs.overload_explosion = function (action_settings, weapon_template)
	local explosion_template = action_settings.explosion_template

	if not explosion_template then
		return false, "requires explosion_template."
	end

	if action_settings.death_on_explosion and not action_settings.death_damage_profile then
		return false, "requires death_damage_profile set if death_on_explosion is true."
	end

	local dot_settings = action_settings.dot_settings

	if dot_settings then
		if not dot_settings.damage_frequency then
			return false, "dot_settings requires damage_frequency set."
		end

		if not dot_settings.damage_profile then
			return false, "dot_settings requires damage_profile set."
		end

		if not dot_settings.power_level then
			return false, "dot_settings requires power_level set."
		end
	end

	return true
end

return _action_kind_tests
