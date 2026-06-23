-- chunkname: @scripts/settings/buff/live_event_buff_templates/live_event_leftover_buff_templates.lua

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local RoamerSlotPlacementFunctions = require("scripts/settings/roamer/roamer_slot_placement_functions")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local Suppression = require("scripts/utilities/attack/suppression")
local Sway = require("scripts/utilities/sway")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local BuffTemplates = require("scripts/settings/buff/mutator_buff_templates")
local attack_types = AttackSettings.attack_types
local attack_results = AttackSettings.attack_results
local damage_types = DamageSettings.damage_types
local buff_categories = BuffSettings.buff_categories
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local slot_configuration = PlayerCharacterConstants.slot_configuration
local special_rules = SpecialRulesSettings.special_rules
local stat_buffs = BuffSettings.stat_buffs
local buff_keywords = BuffSettings.keywords
local burning_buff_name = "flamer_assault"
local bleeding_buff_name = "bleed"
local templates = {}

table.make_unique(templates)

templates.live_event_leftover_buff_faction_a = {
	always_show_in_hud = true,
	class_name = "buff",
	description = "Faction A has rewarded your support",
	display_description = "loc_live_event_leftover_buff_faction_a_description",
	display_title = "loc_live_event_leftover_buff_faction_a",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_increase_electric",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	title = "Faction A support",
	buff_category = buff_categories.live_event,
	stat_buffs = {
		[stat_buffs.coherency_radius_multiplier] = 0.25,
		[stat_buffs.attack_speed] = 0.15,
		[stat_buffs.movement_speed] = 0.15,
	},
	keywords = {},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
}
templates.live_event_leftover_buff_faction_b = {
	always_show_in_hud = true,
	class_name = "buff",
	description = "Faction B has rewarded your support",
	display_description = "loc_live_event_leftover_buff_faction_b_description",
	display_title = "loc_live_event_leftover_buff_faction_b",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_burning_on_melee_hit",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	title = "Faction B support",
	buff_category = buff_categories.live_event,
	stat_buffs = {
		[stat_buffs.damage] = 0.07,
		[stat_buffs.burning_damage] = 0.05,
		[stat_buffs.burning_duration] = 0.15,
	},
	keywords = {
		buff_keywords.burning,
	},
	start_func = function (template_data, template_context)
		local buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
}

local fire_targets_hit = {}
local max_burn_stacks = 1

templates.live_event_leftover_buff_faction_b_apply_burn_damage = {
	always_show_in_hud = false,
	class_name = "proc_buff",
	description = "Faction B has rewarded your support",
	display_description = "loc_live_event_leftover_buff_faction_b_apply_burn_damage_description",
	display_title = "loc_live_event_leftover_buff_faction_b_apply_burn_damage",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_increase_electric",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	title = "Faction B Apply Burn Damage",
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
			if not CheckProcFunctions.on_melee_hit(params, template_data, template_context, t) or not CheckProcFunctions.attacked_unit_is_minion(params, template_data, template_context, t) then
				return
			end

			local attacked_unit = params.attacked_unit

			if fire_targets_hit[attacked_unit] then
				return
			end

			fire_targets_hit[attacked_unit] = true

			if ALIVE[attacked_unit] then
				local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

				if buff_extension then
					local damage_profile = params.damage_profile
					local current_stacks = buff_extension:current_stacks(burning_buff_name)

					if current_stacks < max_burn_stacks then
						local num_stacks = 1

						num_stacks = num_stacks > max_burn_stacks - current_stacks and max_burn_stacks - current_stacks or num_stacks

						buff_extension:add_internally_controlled_buff_with_stacks(burning_buff_name, num_stacks, t, "owner_unit", template_context.unit)
					else
						buff_extension:refresh_duration_of_stacking_buff(burning_buff_name, t)
					end
				end
			end
		end,
		on_melee_kill = function (params, template_data, template_context, t)
			table.clear(fire_targets_hit)
		end,
	},
}

local bleed_targets_hit = {}
local max_bleed_stacks = 1

templates.live_event_leftover_buff_faction_a_apply_bleed_damage = {
	always_show_in_hud = false,
	class_name = "proc_buff",
	description = "Faction A has rewarded your support",
	display_description = "loc_live_event_leftover_buff_faction_a_apply_bleed_damage_description",
	display_title = "loc_live_event_leftover_buff_faction_a_apply_bleed_damage",
	frame = "content/ui/textures/frames/horde/hex_frame_horde",
	hud_icon = "content/ui/textures/icons/buffs/hud/horde_buffs/small_buffs/hordes_buff_damage_increase_electric",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	icon_mask = "content/ui/textures/frames/horde/hex_frame_horde_mask",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	title = "Faction A Apply Bleed Damage",
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

			if bleed_targets_hit[attacked_unit] then
				return
			end

			bleed_targets_hit[attacked_unit] = true

			if ALIVE[attacked_unit] then
				local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

				if buff_extension then
					local damage_profile = params.damage_profile
					local current_stacks = buff_extension:current_stacks(bleeding_buff_name)

					if current_stacks < max_bleed_stacks then
						local num_stacks = 1

						num_stacks = num_stacks > max_bleed_stacks - current_stacks and max_bleed_stacks - current_stacks or num_stacks

						buff_extension:add_internally_controlled_buff_with_stacks(bleeding_buff_name, num_stacks, t, "owner_unit", template_context.unit)
					else
						buff_extension:refresh_duration_of_stacking_buff(bleeding_buff_name, t)
					end
				end
			end
		end,
		on_ranged_kill = function (params, template_data, template_context, t)
			table.clear(bleed_targets_hit)
		end,
	},
}
templates.drop_leftover_01_pickup_small_on_death = {
	class_name = "buff",
	predicted = false,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local position = Unit.world_position(unit, 1)
		local rotation = Unit.local_rotation(unit, 1)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:spawn_pickup("live_event_leftover_01_pickup_small", position, rotation, nil, nil, nil, nil, "leftover")
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
}
templates.drop_leftover_01_pickup_medium_on_death = {
	class_name = "buff",
	predicted = false,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local position = Unit.world_position(unit, 1)
		local rotation = Unit.local_rotation(unit, 1)
		local pickup_system = Managers.state.extension:system("pickup_system")

		pickup_system:spawn_pickup("live_event_leftover_01_pickup_medium", position, rotation, nil, nil, nil, nil, "leftover")
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
}

local drop_leftover_01_pickup_medium_many_on_death_placement_settings = {
	circle_radius = 0.75,
	num_slots = 2,
	position_offset = 0.2,
	randomize_rotation = true,
}

templates.drop_leftover_01_pickup_medium_many_on_death = {
	class_name = "buff",
	predicted = false,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit
		local base_position_boxed = Vector3Box(Unit.world_position(unit, 1))

		Managers.state.game_mode:register_physics_safe_callback(function ()
			local pickup_system = Managers.state.extension:system("pickup_system")

			if not pickup_system then
				return
			end

			local nav_world = Managers.state.nav_mesh:nav_world()

			if not nav_world then
				return
			end

			local spawn_locations = RoamerSlotPlacementFunctions.circle_placement_guaranteed(nav_world, base_position_boxed, drop_leftover_01_pickup_medium_many_on_death_placement_settings, nil)

			for i = 1, #spawn_locations do
				local spawn_location = spawn_locations[i].position:unbox()
				local spawn_rotation = spawn_locations[i].rotation:unbox()

				pickup_system:spawn_pickup("live_event_leftover_01_pickup_medium", spawn_location, spawn_rotation, nil, nil, nil, nil, "leftover")
			end
		end)
	end,
	conditional_exit_func = function (template_data, template_context)
		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return true
		end
	end,
}
templates.live_event_leftover_drop_many_large_pickups_on_death = table.add_missing({
	pickup_name = "live_event_leftover_01_pickup_large",
	placement_settings = {
		circle_radius = 1.25,
		num_slots = 7,
		position_offset = 0.5,
		randomize_rotation = true,
	},
}, table.clone(BuffTemplates.drop_many_pickups_on_death))

return templates
