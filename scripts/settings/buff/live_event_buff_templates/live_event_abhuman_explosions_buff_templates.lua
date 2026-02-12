-- chunkname: @scripts/settings/buff/live_event_buff_templates/live_event_abhuman_explosions_buff_templates.lua

local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local templates = {}

table.make_unique(templates)

local buff_categories = BuffSettings.buff_categories
local proc_events = BuffSettings.proc_events
local SFX_NAMES = {
	grenade_refil = "wwise/events/player/play_horde_mode_buff_grenade_refill",
}

templates.drop_ogryn_grenade_on_death = {
	class_name = "buff",
	predicted = false,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local position = Unit.world_position(unit, 1)
		local projectile_template = ProjectileTemplates.renegade_frag_grenade

		SharedBuffFunctions.spawn_grenade_at_position(nil, "villains", projectile_template.item_name, projectile_template, position, Vector3.down(), 0)
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
}
templates.live_event_abhuman_explosions_grenade_regen_on_elite_kill = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	description = "Killing an elite or special enemy while in coherency with your team will replenish one grenade.",
	display_description = "loc_live_event_abhuman_explosions_grenade_regen_on_elite_kill_description",
	display_title = "loc_live_event_abhuman_explosions_grenade_regen_on_elite_kill_title",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/big_buffs/hordes_buff_grenade_explosion_kill_replenish_grenades",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	title = "Abhuman Explosions Grenade Regen on Elite Kill",
	buff_category = buff_categories.live_event,
	proc_events = {
		[proc_events.on_minion_death] = 0.1,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_minion_death,
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		local attacking_unit = params.attacking_unit
		local units_in_coherence = template_data.coherency_extension:in_coherence_units()
		local attacking_unit_is_in_coherency = false

		for coherency_unit, _ in pairs(units_in_coherence) do
			if coherency_unit == attacking_unit then
				attacking_unit_is_in_coherency = true

				break
			end
		end

		if not attacking_unit_is_in_coherency then
			return
		end

		local unit = template_context.unit
		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if fx_extension then
			local position = POSITION_LOOKUP[unit]

			fx_extension:trigger_exclusive_wwise_event("wwise/events/player/play_pick_up_ammo_01", position)
		end

		local ability_extension = ScriptUnit.has_extension(unit, "ability_system")

		if ability_extension and ability_extension:has_ability_type("grenade_ability") then
			ability_extension:restore_ability_charge("grenade_ability", 1)

			local player_fx_extension = ScriptUnit.has_extension(unit, "fx_system")

			if player_fx_extension then
				player_fx_extension:trigger_wwise_events_local_only(SFX_NAMES.grenade_refil, nil, unit)
			end
		end
	end,
}

return templates
