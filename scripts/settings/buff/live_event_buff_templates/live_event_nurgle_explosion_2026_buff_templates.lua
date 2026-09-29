-- chunkname: @scripts/settings/buff/live_event_buff_templates/live_event_nurgle_explosion_2026_buff_templates.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local buff_categories = BuffSettings.buff_categories
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local burning_buff_name = "flamer_assault"
local max_burn_stacks = 1
local templates = {}

table.make_unique(templates)

templates.live_event_nurgle_explosion_2026_player_buff = {
	always_show_in_hud = true,
	class_name = "buff",
	description = "Bigger explosions, extra grenades and larger ammo reserves.",
	display_description = "loc_live_event_nurgle_explosion_2026_player_buff_description",
	display_title = "loc_live_event_nurgle_explosion_2026_player_buff_title",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_extra_grenade_throw_chance",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	title = "Nurgle Explosion 2026 Player Buff",
	buff_category = buff_categories.live_event,
	stat_buffs = {
		[stat_buffs.explosion_radius_modifier] = 0.5,
		[stat_buffs.explosion_radius_modifier_frag] = 0.5,
		[stat_buffs.extra_max_amount_of_grenades] = 1,
		[stat_buffs.ammo_reserve_capacity] = 0.25,
	},
	keywords = {
		buff_keywords.improved_ammo_pickups,
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
}

local fire_targets_hit = {}

templates.live_event_nurgle_explosion_2026_burn_on_ranged_hit = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	description = "Ranged hits set enemies on fire.",
	display_description = "loc_live_event_nurgle_explosion_2026_burn_on_ranged_hit_description",
	display_title = "loc_live_event_nurgle_explosion_2026_burn_on_ranged_hit_title",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_burning_on_ranged_hit",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	title = "Nurgle Explosion 2026 Ranged Burn",
	buff_category = buff_categories.live_event,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	specific_proc_func = {
		on_hit = function (params, template_data, template_context, t)
			if not CheckProcFunctions.on_ranged_hit(params, template_data, template_context, t) or not CheckProcFunctions.attacked_unit_is_minion(params, template_data, template_context, t) then
				return
			end

			local attacked_unit = params.attacked_unit

			if fire_targets_hit[attacked_unit] then
				return
			end

			fire_targets_hit[attacked_unit] = true

			if not ALIVE[attacked_unit] then
				return
			end

			local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

			if not buff_extension then
				return
			end

			local current_stacks = buff_extension:current_stacks(burning_buff_name)

			if current_stacks < max_burn_stacks then
				local num_stacks = max_burn_stacks - current_stacks

				buff_extension:add_internally_controlled_buff_with_stacks(burning_buff_name, num_stacks, t, "owner_unit", template_context.unit)
			else
				buff_extension:refresh_duration_of_stacking_buff(burning_buff_name, t)
			end
		end,
		on_ranged_kill = function (params, template_data, template_context, t)
			table.clear(fire_targets_hit)
		end,
	},
}

return templates
