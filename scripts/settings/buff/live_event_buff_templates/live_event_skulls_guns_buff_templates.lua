-- chunkname: @scripts/settings/buff/live_event_buff_templates/live_event_skulls_guns_buff_templates.lua

local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local stat_buffs = BuffSettings.stat_buffs

local function _coherency_value(template_data)
	return template_data.units_in_coherency or 1
end

local SMOOTHING_RATE = 2.5
local ACTIVE_THRESHOLD = 1.05
local INACTIVE_THRESHOLD = 1.01

templates.live_event_skull_guns_coherency_buff = {
	always_show_in_hud = true,
	class_name = "buff",
	description = "The Skull provides a coherency buff for all players",
	display_description = "loc_live_event_skull_guns_coherency_buff_description",
	display_title = "loc_live_event_skull_guns_coherency_buff_title",
	hud_icon = "content/ui/textures/icons/buffs/hud/live_event_buffs/big_buffs_skulls_guns_icon",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	max_stacks = 5,
	max_stacks_cap = 5,
	predicted = false,
	title = "Skulls Guns Skull Coherency Buff",
	conditional_stat_buffs = {
		[stat_buffs.damage] = 0.125,
		[stat_buffs.toughness_damage_taken_multiplier] = 1,
		[stat_buffs.attack_speed] = 0.05,
		[stat_buffs.movement_speed] = 0.075,
	},
	stat_buff_multipliers = {
		[stat_buffs.damage] = function (template_data, template_context)
			local num_units_in_coherency = template_data.coherency_extension:num_units_in_coherency()
			local damage_per_player_multiplier = math.max(0, num_units_in_coherency - 1)

			return damage_per_player_multiplier
		end,
		[stat_buffs.toughness_damage_taken_multiplier] = function (template_data, template_context)
			local num_units_in_coherency = template_data.coherency_extension:num_units_in_coherency()
			local multiplier = 1 - math.max(0, num_units_in_coherency - 1) * 0.05

			return multiplier
		end,
		[stat_buffs.attack_speed] = function (template_data, template_context)
			local num_units_in_coherency = template_data.coherency_extension:num_units_in_coherency()
			local multiplier = 1 + math.max(0, num_units_in_coherency - 1) * 0.05

			return multiplier
		end,
		[stat_buffs.movement_speed] = function (template_data, template_context)
			return 1 + math.max(0, _coherency_value(template_data) - 1) * 0.1
		end,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.units_in_coherency = 1
	end,
	update_func = function (template_data, template_context, dt, t, template)
		local target = template_data.coherency_extension:num_units_in_coherency() or 1
		local prev = template_data.units_in_coherency or 1
		local alpha = 1 - math.exp(-SMOOTHING_RATE * dt)
		local smoothed = math.lerp(prev, target, alpha)

		template_data.units_in_coherency = smoothed

		if template_data.is_active then
			template_data.is_active = smoothed > INACTIVE_THRESHOLD
		else
			template_data.is_active = smoothed > ACTIVE_THRESHOLD
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_active
	end,
}

return templates
