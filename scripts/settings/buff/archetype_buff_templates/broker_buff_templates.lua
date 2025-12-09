-- chunkname: @scripts/settings/buff/archetype_buff_templates/broker_buff_templates.lua

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local Breeds = require("scripts/settings/breed/breeds")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageProfileSettings = require("scripts/settings/damage/damage_profile_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Pickups = require("scripts/settings/pickup/pickups")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local Suppression = require("scripts/utilities/attack/suppression")
local Sway = require("scripts/utilities/sway")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local Stagger = require("scripts/utilities/attack/stagger")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local attack_types = AttackSettings.attack_types
local attack_results = AttackSettings.attack_results
local damage_types = DamageSettings.damage_types
local buff_categories = BuffSettings.buff_categories
local keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local slot_configuration = PlayerCharacterConstants.slot_configuration
local special_rules = SpecialRulesSettings.special_rules
local stagger_results = AttackSettings.stagger_results
local stat_buffs = BuffSettings.stat_buffs
local talent_settings = TalentSettings.broker
local stimm_talent_settings = TalentSettings.broker_stimm
local grenade_explosion_damage_types = DamageProfileSettings.grenade_explosion_damage_types
local templates = {}

table.make_unique(templates)

local function _penance_start_func(buff_name)
	return function (template_data, template_context)
		local unit = template_context.unit
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		buff_extension:add_internally_controlled_buff(buff_name, t)
	end
end

local _can_show_outline, _update_show_outlines, _start_outlines, _update_enemies_to_tag, _update_outlines, _end_outlines
local OUTLINE_NAME = "broker_proximity_target"
local DISTANCE_LIMIT = DamageSettings.ranged_close
local DISTANCE_LIMIT_SQUARED = DISTANCE_LIMIT * DISTANCE_LIMIT
local HIGHLIGHT_OFFSET = talent_settings.combat_ability.focus.outline_highlight_offset
local HIGHLIGHT_OFFSET_TOTAL_MAX_TIME = talent_settings.combat_ability.focus.outline_highlight_offset_total_max_time
local EXTERNAL_PROPERTIES = {}

function _can_show_outline(breed, template_data)
	local breed_tags = breed and breed.tags

	if not breed_tags then
		return false
	end

	return true
end

function _update_show_outlines(template_data, template_context)
	local is_local_unit = template_context.is_local_unit
	local player = template_context.player
	local is_human_controlled = player:is_human_controlled()
	local local_player = Managers.player:local_player(1)
	local camera_handler = local_player and local_player.camera_handler
	local is_observing = camera_handler and camera_handler:is_observing()
	local show_outlines = is_local_unit and is_human_controlled or is_observing

	if template_data.show_outlines ~= show_outlines then
		if show_outlines then
			_start_outlines(template_data, template_context)
		else
			_end_outlines(template_data, template_context)
		end

		template_data.show_outlines = show_outlines
	end

	return show_outlines
end

function _start_outlines(template_data, template_context)
	template_data.outlined_units = template_data.outlined_units or {}

	local unit = template_context.unit
	local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

	template_data.fx_extension = fx_extension
	template_data.enemies_to_tag = template_data.enemies_to_tag or {}
	template_data.enemies_to_tag_set = template_data.enemies_to_tag_set or {}
	template_data.sort_value = template_data.sort_value or {}
	template_data.time_in_buff = 0
end

function _update_enemies_to_tag(template_data, template_context)
	local unit = template_context.unit
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system and side_system.side_by_unit[unit]
	local enemy_units = side and side.enemy_units_lookup or {}
	local player_position = Unit.world_position(unit, 1)
	local enemies_to_tag = template_data.enemies_to_tag
	local enemies_to_tag_set = template_data.enemies_to_tag_set

	table.clear(enemies_to_tag)
	table.clear(enemies_to_tag_set)

	local sort_value = template_data.sort_value

	for enemy_unit, _ in pairs(enemy_units) do
		local enemy_unit_data_extension = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
		local breed = enemy_unit_data_extension and enemy_unit_data_extension:breed()
		local should_get_outlined = _can_show_outline(breed, template_data)

		if should_get_outlined then
			local enemy_position = Unit.world_position(enemy_unit, 1)
			local from_player = enemy_position - player_position
			local distance_squared = Vector3.length_squared(from_player)
			local distance_limit = DISTANCE_LIMIT_SQUARED or 10
			local distance_score = distance_squared / distance_limit
			local distance_score_low_enough = distance_score < 1

			if distance_score_low_enough then
				enemies_to_tag[#enemies_to_tag + 1] = enemy_unit
				enemies_to_tag_set[enemy_unit] = true
				sort_value[enemy_unit] = distance_score
			end
		end
	end

	table.sort(enemies_to_tag, function (unit_1, unit_2)
		local angle_1 = sort_value[unit_1]
		local angle_2 = sort_value[unit_2]

		return angle_1 < angle_2
	end)
	table.clear(template_data.sort_value)

	template_data.enemies_to_tag = enemies_to_tag
end

function _update_outlines(template_data, template_context, dt, t)
	local time_in_buff = template_data.time_in_buff + dt

	template_data.time_in_buff = time_in_buff

	local enemies_to_tag = template_data.enemies_to_tag
	local has_outline_system = Managers.state.extension:has_system("outline_system")

	if has_outline_system and enemies_to_tag then
		local enemies_to_tag_set = template_data.enemies_to_tag_set
		local outline_system = Managers.state.extension:system("outline_system")
		local outlined_units = template_data.outlined_units
		local number_of_active_enemies = #enemies_to_tag
		local activation_time = math.min(HIGHLIGHT_OFFSET, HIGHLIGHT_OFFSET_TOTAL_MAX_TIME / number_of_active_enemies)

		for ii = 1, number_of_active_enemies do
			local enemy_unit = enemies_to_tag[ii]

			if not outlined_units[enemy_unit] and time_in_buff > ii * activation_time then
				outline_system:add_outline(enemy_unit, OUTLINE_NAME)

				outlined_units[enemy_unit] = true
			end
		end

		for enemy_unit in pairs(outlined_units) do
			if not enemies_to_tag_set[enemy_unit] then
				outline_system:remove_outline(enemy_unit, OUTLINE_NAME)

				outlined_units[enemy_unit] = nil
			end
		end
	end
end

function _end_outlines(template_data, template_context)
	local outlined_units = template_data.outlined_units

	if outlined_units then
		local has_outline_system = Managers.state.extension:has_system("outline_system")

		if has_outline_system then
			local outline_system = Managers.state.extension:system("outline_system")

			for unit, _ in pairs(outlined_units) do
				outline_system:remove_outline(unit, OUTLINE_NAME)
			end
		end
	end

	template_data.outlined_units = nil
	template_data.enemies_to_tag = nil
end

local function _bespoke_needlepistol_close_range_kill_start(template_data, template_context)
	template_data.tagged_enemies = {}
	template_data.untagged_enemies = {}

	local unit_data_extension = ScriptUnit.has_extension(template_context.unit, "unit_data_system")

	template_data.inventory = unit_data_extension:read_component("inventory")
end

local GRACE_FRAMES = 1

local function _bespoke_needlepistol_close_range_kill_update(template_data, template_context, dt, t)
	local frame = FixedFrame.to_fixed_frame(t)

	for unit, tagged_frame in pairs(template_data.tagged_enemies) do
		local buff_ext = ScriptUnit.has_extension(unit, "buff_system")

		if not buff_ext or not buff_ext:has_keyword(keywords.toxin) then
			if tagged_frame < frame - GRACE_FRAMES then
				template_data.untagged_enemies[unit] = true
			end
		else
			template_data.tagged_enemies[unit] = frame
		end
	end

	for unit, _ in pairs(template_data.untagged_enemies) do
		template_data.tagged_enemies[unit] = nil
	end

	table.clear(template_data.untagged_enemies)
end

local allowed_items = table.set({
	"content/items/weapons/player/ranged/needlepistol_p1_m1",
	"content/items/weapons/player/ranged/needlepistol_p1_m2",
})

local function _bespoke_needlepistol_close_range_kill_check_proc_hit(params, template_data, template_context, t)
	local is_needler = params.attacking_item and params.attacking_item.name and allowed_items[params.attacking_item.name]

	if not template_context.is_server then
		return false
	elseif not is_needler then
		return false
	elseif not HEALTH_ALIVE[params.attacked_unit] then
		return false
	elseif params.attack_type ~= attack_types.ranged then
		return false
	elseif not template_data.inventory or template_data.inventory.wielded_slot ~= "slot_secondary" then
		return false
	end

	return true
end

local function _bespoke_needle_pistol_close_range_kill_check_proc_minion_death(params, template_data, template_context, t)
	if not template_context.is_server then
		return false
	elseif not template_data.tagged_enemies[params.dying_unit] then
		return false
	elseif params.damage_type ~= "toxin" then
		return false
	end

	local hit_world_position = params.position and params.position:unbox()

	if not hit_world_position then
		return false
	end

	local attacking_unit = params.attacking_unit
	local close_range_squared = DamageSettings.ranged_close^2
	local attacking_pos = POSITION_LOOKUP[attacking_unit] or Unit.world_position(attacking_unit, 1)
	local distance_squared = Vector3.distance_squared(hit_world_position, attacking_pos)
	local is_within_distance = distance_squared <= close_range_squared

	return is_within_distance
end

local function _bespoke_needle_pistol_close_range_kill_proc_hit(params, template_data, template_context, t)
	local frame = FixedFrame.to_fixed_frame(t)

	template_data.tagged_enemies[params.attacked_unit] = frame
end

local function _bespoke_needle_pistol_close_range_kill_proc_on_minion_death(params, template_data, template_context, t)
	if params.dying_unit then
		template_data.tagged_enemies[params.dying_unit] = nil
	end
end

local function _extend_ability_duration(start_time, template_context, max_duration, added_duration, divisor, t)
	local time_since_start = t - start_time
	local steps = math.floor(time_since_start / max_duration)
	local modified_divisor = divisor^steps

	added_duration = added_duration / modified_divisor

	local new_start_time = math.min(t, template_context.buff:start_time() + added_duration)

	template_context.buff:set_start_time(new_start_time)
end

local function _focus_proc_func(params, template_data, template_context, t)
	if not template_data.focus_improved then
		return
	end

	template_data.fx_extension:trigger_wwise_event("wwise/events/player/play_ability_broker_focus_kill")

	if template_context.is_server then
		local max_duration = talent_settings.combat_ability.focus.duration_max
		local added_duration = talent_settings.combat_ability.focus.duration_extend
		local divisor = talent_settings.combat_ability.focus.duration_divisor

		_extend_ability_duration(template_data.start_time, template_context, max_duration, added_duration, divisor, t)

		local reload_on_kill = talent_settings.combat_ability.focus.reload_on_kill

		if reload_on_kill then
			local ammo_refill_amount = talent_settings.combat_ability.focus.ammo_refill_amount
			local attacking_unit = params.attacking_unit
			local unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")

			if unit_data_extension then
				local inventory_slot_component = unit_data_extension:write_component("slot_secondary")
				local max_ammo_in_clip = Ammo.max_ammo_in_clips(inventory_slot_component)
				local amount_to_refill = math.ceil(max_ammo_in_clip * ammo_refill_amount)

				Ammo.transfer_from_reserve_to_clip(inventory_slot_component, amount_to_refill)
			end
		end

		if template_data.sub_2_rending then
			template_context.buff_extension:add_internally_controlled_buff("broker_focus_sub_2_damage", t)
		end

		if template_data.sub_3_cooldown then
			local breed = Breeds[params.breed_name]

			if breed then
				local cooldown_to_restore = template_context.template.sub_3_cooldown_replenish
				local tags = breed.tags

				if tags and tags.elite then
					cooldown_to_restore = template_context.template.sub_3_cooldown_replenish_elite
				end

				local max_restore = template_context.template.sub_3_cooldown_replenish_max

				cooldown_to_restore = math.min(max_restore - template_data.cooldown_restored, cooldown_to_restore)

				if cooldown_to_restore > 0 then
					template_data.ability_extension:reduce_ability_cooldown_time("combat_ability", cooldown_to_restore)

					template_data.cooldown_restored = template_data.cooldown_restored + cooldown_to_restore
				end
			end
		end
	end
end

local FOCUS_SFX_LOOP_NAME = "wwise/events/player/play_player_ability_broker_focus_start"
local FOCUS_MOOD_NAME = "broker_combat_ability_focus"

templates.broker_focus_stance = {
	class_name = "proc_buff",
	duration_per_stack = 1,
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_gunslinger_focus",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 1,
	predicted = true,
	skip_tactical_overlay = true,
	duration = talent_settings.combat_ability.focus.duration,
	max_stacks = talent_settings.combat_ability.focus.max_stacks,
	max_stacks_cap = talent_settings.combat_ability.focus.max_stacks,
	sub_3_cooldown_replenish = talent_settings.combat_ability.focus.cooldown_base,
	sub_3_cooldown_replenish_elite = talent_settings.combat_ability.focus.cooldown_elite,
	sub_3_cooldown_replenish_max = talent_settings.combat_ability.focus.cooldown_max,
	stat_buffs = {
		[stat_buffs.sprint_movement_speed] = talent_settings.combat_ability.focus.sprint_movement_speed,
		[stat_buffs.sprinting_cost_multiplier] = talent_settings.combat_ability.focus.sprinting_cost_multiplier,
	},
	conditional_stat_buffs = {
		[stat_buffs.ranged_rending_multiplier] = 0.15,
	},
	conditional_stat_buffs_funcs = {
		[stat_buffs.ranged_rending_multiplier] = function (template_data, template_context)
			return template_data.sub_2_rending
		end,
	},
	lerped_stat_buffs = {
		[stat_buffs.fov_multiplier] = {
			max = 1,
			min = talent_settings.combat_ability.focus.fov_multiplier,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return math.clamp01((t - start_time) / duration)
	end,
	keywords = {
		keywords.broker_combat_ability_focus,
		keywords.suppression_immune,
		keywords.count_as_dodge_vs_ranged,
	},
	conditional_keywords = {
		keywords.disable_minions_collision_during_sprint,
		keywords.disable_minions_collision_during_dodge,
	},
	conditional_keywords_func = function (template_data, template_context)
		return template_data.noclip
	end,
	proc_events = {
		[proc_events.on_kill] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_minion_death] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.unit_data_extension = unit_data_extension
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.start_time = template_context.buff:start_time()

		local slot_secondary_component = template_data.unit_data_extension:write_component("slot_secondary")

		slot_secondary_component.free_ammunition_transfer = true

		Ammo.move_clip_to_reserve(slot_secondary_component)
		Ammo.set_current_ammo_in_clips(slot_secondary_component, Ammo.max_ammo_in_clips(slot_secondary_component))

		local player = Managers.player:player_by_unit(unit)
		local talent_extension = ScriptUnit.extension(template_context.unit, "talent_system")
		local camera_handler = player and player.camera_handler
		local mood_handler = camera_handler and camera_handler:mood_handler()

		template_data.mood_handler = mood_handler
		template_data.focus_improved = talent_extension:has_special_rule("broker_focus_improved")
		template_data.noclip = talent_extension:has_special_rule("broker_focus_noclip")
		template_data.sub_2_rending = talent_extension:has_special_rule("broker_focus_rending")
		template_data.sub_3_cooldown = talent_extension:has_special_rule("broker_focus_cooldown_regain")
		template_data.cooldown_restored = 0

		_bespoke_needlepistol_close_range_kill_start(template_data, template_context)
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_data.mood_handler then
			local duration = talent_settings.combat_ability.focus.duration
			local start_t = template_context.buff:start_time()
			local end_t = start_t + duration
			local rtpc_parameter_value = math.ilerp(start_t, end_t, t) * 100
			local source_id = template_data.mood_handler:get_wwise_source_id(FOCUS_MOOD_NAME, FOCUS_SFX_LOOP_NAME)

			if source_id then
				WwiseWorld.set_source_parameter(template_context.wwise_world, source_id, "ability_duration", rtpc_parameter_value)
			end
		end

		local show_outlines

		if template_data.focus_improved then
			show_outlines = _update_show_outlines(template_data, template_context)
		end

		if show_outlines then
			_update_enemies_to_tag(template_data, template_context)
			_update_outlines(template_data, template_context, dt, t)
		end

		_bespoke_needlepistol_close_range_kill_update(template_data, template_context, dt, t)
	end,
	specific_check_proc_funcs = {
		[proc_events.on_kill] = CheckProcFunctions.on_ranged_close_kill,
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			return _bespoke_needlepistol_close_range_kill_check_proc_hit(params, template_data, template_context, t)
		end,
		[proc_events.on_minion_death] = function (params, template_data, template_context, t)
			return _bespoke_needle_pistol_close_range_kill_check_proc_minion_death(params, template_data, template_context, t)
		end,
	},
	specific_proc_func = {
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			_bespoke_needle_pistol_close_range_kill_proc_hit(params, template_data, template_context, t)
		end,
		[proc_events.on_minion_death] = function (params, template_data, template_context, t)
			_focus_proc_func(params, template_data, template_context, t)
			_bespoke_needle_pistol_close_range_kill_proc_on_minion_death(params, template_data, template_context, t)
		end,
		[proc_events.on_kill] = _focus_proc_func,
	},
	stop_func = function (template_data, template_context, extension_destroyed)
		local slot_secondary_component = template_data.unit_data_extension:write_component("slot_secondary")

		slot_secondary_component.free_ammunition_transfer = false

		local current_ammo_clip = Ammo.current_ammo_in_clips(slot_secondary_component)

		Ammo.set_current_ammo_in_clips(slot_secondary_component, 0)
		Ammo.transfer_from_reserve_to_clip(slot_secondary_component, current_ammo_clip)
		_end_outlines(template_data, template_context)
	end,
}
templates.broker_focus_stance_improved = table.clone(templates.broker_focus_stance)
templates.broker_focus_stance_improved.hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_gunslinger_focus_improved"
templates.broker_focus_sub_2_damage = {
	class_name = "buff",
	duration = 3,
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_enhanced_desperado_focused_resolve",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 2,
	max_stacks = 5,
	predicted = false,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	stat_buffs = {
		[stat_buffs.ranged_damage] = 0.03,
	},
	conditional_exit_func = function (template_data, template_context)
		local buff_ext = template_context.buff_extension
		local num_ability_stacks = buff_ext:current_stacks("broker_focus_stance") + buff_ext:current_stacks("broker_focus_stance_improved")

		return num_ability_stacks <= 0
	end,
}
SHOUT_DEBUFF_RESULTS = {}

local function _apply_punk_rage_shout(player_unit, player_unit_data_extension, shout_radius, t)
	if not HEALTH_ALIVE[player_unit] then
		return
	end

	local first_person_component = player_unit_data_extension:read_component("first_person")
	local rotation = first_person_component.rotation
	local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
	local locomotion_component = player_unit_data_extension:read_component("locomotion")
	local power_modifier

	ShoutAbilityImplementation.execute(shout_radius, "broker_rage_shout", player_unit, t, locomotion_component, forward, nil, nil, power_modifier)

	local player_fx_extension = ScriptUnit.extension(player_unit, "fx_system")

	if HEALTH_ALIVE[player_unit] and player_fx_extension then
		local variable_name = "size"
		local variable_value = Vector3(8, 8, 8)
		local vfx_position = POSITION_LOOKUP[player_unit] + Vector3.up()
		local shout_vfx = "content/fx/particles/abilities/squad_leader_ability_shout_activate"

		player_fx_extension:spawn_particles(shout_vfx, vfx_position, nil, nil, variable_name, variable_value, true)
	end

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local player_position = POSITION_LOOKUP[player_unit]

	table.clear(SHOUT_DEBUFF_RESULTS)

	local num_hits = broadphase.query(broadphase, player_position, shout_radius, SHOUT_DEBUFF_RESULTS, enemy_side_names)

	for i = 1, num_hits do
		local enemy_unit = SHOUT_DEBUFF_RESULTS[i]
		local enemy_unit_buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

		if enemy_unit_buff_extension then
			enemy_unit_buff_extension:add_internally_controlled_buff("broker_punk_rage_improved_shout_debuff", t)
		end
	end
end

templates.broker_punk_rage_improved_shout_debuff = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	duration = talent_settings.combat_ability.punk_rage.improved_shout_duration,
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings.combat_ability.punk_rage.improved_shout_enemy_melee_attack_speed,
	},
}
templates.broker_punk_rage_ramping_melee_power = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_rampage_pulverising_strikes",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 2,
	max_stacks = 10,
	max_stacks_cap = 10,
	predicted = false,
	skip_tactical_overlay = true,
	stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = talent_settings.combat_ability.punk_rage.stacking_melee_power,
	},
}

local PUNK_RAGE_SFX_LOOP_NAME = "wwise/events/player/play_player_ability_broker_rage_start"
local PUNK_RAGE_MOOD_NAME = "broker_combat_ability_punk_rage"

templates.broker_punk_rage_stance = {
	class_name = "proc_buff",
	duration_per_stack = 1,
	force_predicted_proc = true,
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_punk_rage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = true,
	skip_tactical_overlay = true,
	duration = talent_settings.combat_ability.punk_rage.rage_duration,
	sub_1_rending_threshold_t = talent_settings.combat_ability.punk_rage.sub_1_rending_threshold_t,
	sub_4_duration_extend_elite = talent_settings.combat_ability.punk_rage.sub_4_duration_extend_elite,
	sub_4_duration_max_improved = talent_settings.combat_ability.punk_rage.sub_4_duration_max_improved,
	player_effects = {
		on_screen_effect = "content/fx/particles/screenspace/screen_rage_persistant",
	},
	lerped_stat_buffs = {
		[stat_buffs.fov_multiplier] = {
			max = 1,
			min = talent_settings.combat_ability.punk_rage.rage_fov_multiplier,
		},
	},
	lerp_t_func = function (t, start_time, duration, template_data, template_context)
		return (t - start_time) / duration or 0
	end,
	stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = talent_settings.combat_ability.punk_rage.rage_melee_power_level_modifier,
		[stat_buffs.melee_attack_speed] = talent_settings.combat_ability.punk_rage.rage_melee_attack_speed,
		[stat_buffs.damage_taken_multiplier] = talent_settings.combat_ability.punk_rage.rage_damage_taken_multiplier,
	},
	conditional_stat_buffs = {
		[stat_buffs.melee_heavy_rending_multiplier] = talent_settings.combat_ability.punk_rage.melee_rending_multiplier,
		[stat_buffs.max_hit_mass_attack_modifier] = talent_settings.combat_ability.punk_rage.max_hit_mass_modifier,
		[stat_buffs.max_hit_mass_impact_modifier] = talent_settings.combat_ability.punk_rage.max_hit_mass_modifier,
	},
	conditional_stat_buffs_funcs = {
		[stat_buffs.melee_heavy_rending_multiplier] = function (template_data, template_context)
			if not template_data.rending_talent then
				return false
			end

			local buff = template_context.buff
			local start_time = buff:start_time()
			local duration = buff:duration()
			local time_into_buff = (FixedFrame.get_latest_fixed_time() - start_time) / duration

			return time_into_buff < template_context.template.sub_1_rending_threshold_t
		end,
		[stat_buffs.max_hit_mass_attack_modifier] = function (template_data)
			return template_data.cleave_talent
		end,
		[stat_buffs.max_hit_mass_impact_modifier] = function (template_data)
			return template_data.cleave_talent
		end,
	},
	keywords = {
		keywords.broker_combat_ability_punk_rage,
		keywords.stun_immune,
		keywords.slowdown_immune,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.extension(unit, "buff_system")
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.buff_extension = buff_extension
		template_data.unit_data_extension = unit_data_extension
		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.fx_extension = ScriptUnit.extension(unit, "fx_system")
		template_data.buff_ids = {}

		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		template_data.rending_talent = talent_extension:has_special_rule("broker_rage_rending")
		template_data.cleave_talent = talent_extension:has_special_rule("broker_rage_cleave")
		template_data.duration_extend_talent = talent_extension:has_special_rule("broker_rage_duration_extend")
		template_data.inventory_component = template_data.unit_data_extension:read_component("inventory")
		template_data.start_t = Managers.time:time("gameplay")

		local player = Managers.player:player_by_unit(unit)
		local camera_handler = player and player.camera_handler
		local mood_handler = camera_handler and camera_handler:mood_handler()

		template_data.mood_handler = mood_handler

		if HEALTH_ALIVE[unit] and template_context.is_server and talent_extension:has_special_rule("broker_rage_improved_shout") then
			local shout_radius = talent_settings.combat_ability.punk_rage.shout_radius

			_apply_punk_rage_shout(unit, unit_data_extension, shout_radius, template_data.start_t)
		end
	end,
	update_func = function (template_data, template_context, dt, t)
		local duration = talent_settings.combat_ability.punk_rage.rage_duration
		local start_t = template_context.buff:start_time()
		local end_t = start_t + duration
		local rtpc_parameter_value = math.ilerp(start_t, end_t, t) * 100

		template_data.fx_extension:set_source_parameter_local("ability_duration", rtpc_parameter_value, "head")

		if template_data.mood_handler then
			local source_id = template_data.mood_handler:get_wwise_source_id(PUNK_RAGE_MOOD_NAME, PUNK_RAGE_SFX_LOOP_NAME)

			if source_id then
				WwiseWorld.set_source_parameter(template_context.wwise_world, source_id, "ability_duration", rtpc_parameter_value)
			end
		end

		if template_context.is_server then
			template_data.t = t

			if template_data.cleave_talent then
				local time_since_start = t - template_data.start_t
				local current_stacks = template_context.buff_extension:current_stacks("broker_punk_rage_ramping_melee_power")

				if current_stacks < time_since_start - 1 then
					local _, buff_id = template_context.buff_extension:add_externally_controlled_buff("broker_punk_rage_ramping_melee_power", t)

					template_data.buff_ids[buff_id] = true
				end
			end
		end
	end,
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			return params.attack_type == "melee"
		end,
	},
	specific_proc_func = {
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			if template_context.is_server then
				local max_duration = talent_settings.combat_ability.punk_rage.rage_duration_max
				local added_duration = talent_settings.combat_ability.punk_rage.rage_duration_extend
				local divisor = talent_settings.combat_ability.punk_rage.rage_duration_divisor

				if template_data.duration_extend_talent then
					local tags = params.tags
					local special = tags.elite or tags.special or tags.monster or tags.captain

					if special then
						max_duration = template_context.template.sub_4_duration_max_improved
						added_duration = template_context.template.sub_4_duration_extend_elite
					end
				end

				_extend_ability_duration(template_data.start_t, template_context, max_duration, added_duration, divisor, t)
			end

			local source_name = "head"
			local sfx_alias = "ability_punk_rage_hit"
			local sync_to_clients = false
			local include_client = false

			table.clear(EXTERNAL_PROPERTIES)

			EXTERNAL_PROPERTIES.ability_template = "broker_punk_rage"

			template_data.fx_extension:trigger_gear_wwise_event_with_source(sfx_alias, EXTERNAL_PROPERTIES, source_name, sync_to_clients, include_client)
		end,
	},
	stop_func = function (template_data, template_context, extension_destroyed)
		template_context.buff_extension:add_internally_controlled_buff("broker_punk_rage_exhaustion", template_data.t)

		if template_context.is_server then
			local current_time = Managers.time:time("gameplay")
			local time_spent_in_punk_rage = math.round(current_time - template_data.start_t)

			if template_context.player and time_spent_in_punk_rage > 0 then
				Managers.stats:record_private("hook_broker_exited_punk_rage", template_context.player, time_spent_in_punk_rage)
			end

			for buff_id in pairs(template_data.buff_ids) do
				template_context.buff_extension:mark_buff_finished(buff_id)
			end

			template_data.buff_ids = nil
		end
	end,
}
templates.broker_punk_rage_exhaustion = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_punk_rage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_ability",
	hud_priority = 1,
	predicted = false,
	skip_tactical_overlay = true,
	duration = talent_settings.combat_ability.punk_rage.exhaust_duration,
	player_effects = {
		looping_wwise_start_event = "wwise/events/player/play_player_experience_heart_beat",
		looping_wwise_stop_event = "wwise/events/player/stop_player_experience_heart_beat",
	},
	keywords = {
		keywords.broker_punk_rage_exhaustion,
	},
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = talent_settings.combat_ability.punk_rage.exhaust_damage_taken_multiplier,
		[stat_buffs.stamina_regeneration_multiplier] = talent_settings.combat_ability.punk_rage.exhaust_stamina_regeneration_multiplier,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data = ScriptUnit.extension(unit, "unit_data_system")
		local stamina_component = unit_data:write_component("stamina")
		local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")

		template_data.stamina_component = stamina_component
		template_data.toughness_extension = toughness_extension
		stamina_component.current_fraction = 0

		local talent_extension = ScriptUnit.extension(unit, "talent_system")

		if HEALTH_ALIVE[unit] and template_context.is_server and talent_extension:has_special_rule("broker_rage_improved_shout") then
			local shout_radius = talent_settings.combat_ability.punk_rage.shout_radius
			local t = FixedFrame.get_latest_fixed_time()

			_apply_punk_rage_shout(unit, unit_data, shout_radius, t)
		end
	end,
}
templates.broker_stimm_field_corruption_buff = {
	class_name = "interval_buff",
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	duration = talent_settings.combat_ability.stimm_field.interval + 0.1,
	interval = talent_settings.combat_ability.stimm_field.interval,
	stat_buffs = {
		[stat_buffs.corruption_taken_multiplier] = 0,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
	end,
	interval_func = function (template_data, template_context, template)
		if not template_context.is_server then
			return
		end

		local corruption_heal_amount = talent_settings.combat_ability.stimm_field.corruption_heal_amount

		template_data.health_extension:reduce_permanent_damage(corruption_heal_amount)
	end,
}

local PICKUP_DATA_TEMP = {}

templates.broker_aura_gunslinger = {
	always_show_in_hud = true,
	ammo_share = 0.05,
	class_name = "proc_buff",
	coherency_id = "broker_gunslinger_coherency_aura",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_gunslinger_improved",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	max_stacks = 1,
	predicted = false,
	talent_name = "broker_aura_gunslinger",
	buff_category = buff_categories.aura,
	proc_events = {
		[proc_events.on_ammo_pickup] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.parent_buff_name = template_context.template.talent_name
		template_data.hook_name = "hook_broker_shared_ammo_through_aura"
	end,
	proc_func = function (params, template_data, template_context, t)
		local pickup_name = params.pickup_name
		local pickup_data = Pickups.by_name[pickup_name]

		table.clear(PICKUP_DATA_TEMP)
		table.merge(PICKUP_DATA_TEMP, pickup_data)

		PICKUP_DATA_TEMP.modifier = template_context.template.ammo_share

		local coherency_extension = ScriptUnit.extension(template_context.unit, "coherency_system")
		local units_in_coherency = coherency_extension:in_coherence_units()
		local total_ammo_restored = 0

		for unit in pairs(units_in_coherency) do
			local ammo_restored = Ammo.add_ammo_using_pickup_data(unit, PICKUP_DATA_TEMP, true)

			total_ammo_restored = total_ammo_restored + ammo_restored
		end

		if total_ammo_restored > 0 then
			template_data.last_num_in_coherency = coherency_extension:evaluate_and_send_achievement_data(template_data.parent_buff_name, template_data.hook_name, total_ammo_restored)
		end
	end,
}
templates.broker_aura_gunslinger_improved = table.clone(templates.broker_aura_gunslinger)
templates.broker_aura_gunslinger_improved.ammo_share = 0.1
templates.broker_aura_gunslinger_improved.talent_name = "broker_aura_gunslinger_improved"
templates.broker_aura_gunslinger_improved.hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_gunslinger_improved"
templates.broker_aura_gunslinger_improved.coherency_priority = 1
templates.broker_coherency_melee_damage = {
	class_name = "buff",
	coherency_id = "broker_ruffian_coherency_aura",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_aura_ruffian",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	max_stacks = talent_settings.coherency.ruffian.max_stacks,
	stat_buffs = {
		[stat_buffs.melee_damage] = talent_settings.coherency.ruffian.melee_damage,
	},
	start_func = _penance_start_func("broker_coherency_melee_damage_tracking_buff"),
}
templates.broker_coherency_melee_damage_tracking_buff = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	skip_tactical_overlay = true,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.hook_name = "hook_broker_enemy_killed_ruffian_aura"
		template_data.parent_buff_name = "broker_coherency_melee_damage"
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.parent_buff_name, template_data.hook_name)
	end,
}
templates.broker_coherency_critical_chance = {
	class_name = "buff",
	coherency_id = "broker_anarchist_coherency_aura",
	coherency_priority = 2,
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_aura_anarchist",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_aura",
	hud_priority = 5,
	predicted = false,
	buff_category = buff_categories.aura,
	max_stacks = talent_settings.coherency.anarchist.max_stacks,
	stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings.coherency.anarchist.critical_strike_chance,
	},
	start_func = _penance_start_func("broker_coherency_critical_chance_tracking_buff"),
}
templates.broker_coherency_critical_chance_tracking_buff = {
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	skip_tactical_overlay = true,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.coherency_extension = ScriptUnit.extension(unit, "coherency_system")
		template_data.hook_name = "hook_broker_critical_hit_with_anarchist_aura"
		template_data.parent_buff_name = "broker_coherency_anarchist"
	end,
	check_proc_func = CheckProcFunctions.on_crit,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.coherency_extension:evaluate_and_send_achievement_data(template_data.parent_buff_name, template_data.hook_name)
	end,
}
templates.broker_passive_repeated_melee_hits_increases_damage = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_passive_repeated_melee_hits_increases_damage",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage] = talent_settings.broker_passive_repeated_melee_hits_increases_damage.damage,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		if HEALTH_ALIVE[params.attacked_unit] then
			if params.attacked_unit ~= template_data.current_unit then
				template_data.current_unit = params.attacked_unit
				template_data.number_of_hits = 0
				template_data.target_number_of_stacks = 0
			else
				local max_stacks = talent_settings.broker_passive_repeated_melee_hits_increases_damage.req_hits - 1
				local number_of_hits = template_data.number_of_hits + 1

				template_data.number_of_hits = number_of_hits

				local template = template_context.template
				local override = template_context.template_override_data
				local number_of_hits_per_stack = override and override.number_of_hits_per_stack or template.number_of_hits_per_stack or 1

				template_data.target_number_of_stacks = math.clamp(math.floor(number_of_hits / number_of_hits_per_stack), 0, max_stacks)
				template_data.last_hit_time = t
			end
		end
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local target_number_of_stacks = template_data.target_number_of_stacks or 0
		local max_stacks = talent_settings.broker_passive_repeated_melee_hits_increases_damage.req_hits - 1

		return max_stacks <= target_number_of_stacks
	end,
}
templates.broker_passive_first_target_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.first_target_melee_damage_modifier] = talent_settings.broker_passive_first_target_damage.damage,
	},
}
templates.broker_passive_reduce_swap_time = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.wield_speed] = talent_settings.broker_passive_reduce_swap_time.wield_speed,
	},
	conditional_stat_buffs = {
		[stat_buffs.recoil_modifier] = talent_settings.broker_passive_reduce_swap_time.recoil_modifier,
		[stat_buffs.spread_modifier] = talent_settings.broker_passive_reduce_swap_time.spread_modifier,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.has_extension(template_context.unit, "unit_data_system")

		if unit_data_extension then
			local alternate_fire_component = unit_data_extension:read_component("alternate_fire")
			local hipfire = not alternate_fire_component.is_active
			local weapon_action_component = unit_data_extension:read_component("weapon_action")
			local braced = PlayerUnitAction.has_current_action_keyword(weapon_action_component, "braced")

			return hipfire or braced
		end
	end,
}
templates.broker_passive_increased_ranged_dodges = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.extra_consecutive_dodges] = talent_settings.broker_passive_increased_ranged_dodges.extra_consecutive_dodges,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")

		template_data.inventory_component = inventory_component
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local wielded_slot = template_data.inventory_component.wielded_slot

		return wielded_slot == "slot_secondary"
	end,
}
templates.broker_passive_close_ranged_damage = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage_near] = talent_settings.broker_passive_close_ranged_damage.damage_near,
		[stat_buffs.damage_far] = talent_settings.broker_passive_close_ranged_damage.damage_far,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")

		template_data.inventory_component = inventory_component
	end,
	conditional_stat_buffs_func = function (template_data, template_context)
		local wielded_slot = template_data.inventory_component.wielded_slot

		if wielded_slot == "slot_secondary" then
			return true
		end

		return false
	end,
}
templates.broker_passive_ninja_grants_crit_chance = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_ninja_grants_crit_chance",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	active_duration = talent_settings.broker_passive_ninja_grants_crit_chance.duration,
	max_stacks = talent_settings.broker_passive_ninja_grants_crit_chance.max_stacks,
	allow_proc_while_active = talent_settings.broker_passive_ninja_grants_crit_chance.allow_proc_while_active,
	proc_events = {
		[proc_events.on_successful_dodge] = talent_settings.broker_passive_ninja_grants_crit_chance.proc_chance,
		[proc_events.on_perfect_block] = talent_settings.broker_passive_ninja_grants_crit_chance.proc_chance,
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings.broker_passive_ninja_grants_crit_chance.critical_strike_chance,
	},
}
templates.broker_passive_parries_grant_crit_chance = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_ninja_grants_crit_chance",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	active_duration = talent_settings.broker_passive_parries_grant_crit_chance.duration,
	max_stacks = talent_settings.broker_passive_parries_grant_crit_chance.max_stacks,
	allow_proc_while_active = talent_settings.broker_passive_parries_grant_crit_chance.allow_proc_while_active,
	proc_events = {
		[proc_events.on_perfect_block] = talent_settings.broker_passive_parries_grant_crit_chance.proc_chance,
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings.broker_passive_parries_grant_crit_chance.critical_strike_chance,
	},
}
templates.broker_passive_backstabs_grant_crit_chance = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_passive_backstabs_grant_crit_chance_2",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	active_duration = talent_settings.broker_passive_backstabs_grant_crit_chance.duration,
	max_stacks = talent_settings.broker_passive_backstabs_grant_crit_chance.max_stacks,
	allow_proc_while_active = talent_settings.broker_passive_backstabs_grant_crit_chance.allow_proc_while_active,
	proc_events = {
		[proc_events.on_hit] = talent_settings.broker_passive_backstabs_grant_crit_chance.proc_chance,
	},
	proc_stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings.broker_passive_backstabs_grant_crit_chance.critical_strike_chance,
	},
	check_proc_func = CheckProcFunctions.is_backstab,
}
templates.broker_passive_improved_dodges = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.dodge_distance_modifier] = talent_settings.broker_passive_improved_dodges.dodge_distance_modifier,
		[stat_buffs.dodge_linger_time_modifier] = talent_settings.broker_passive_improved_dodges.dodge_linger_time_modifier,
	},
}
templates.broker_passive_dodge_melee_on_slide = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_dodge_melee_on_slide",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local movement_state_component = unit_data_extension:read_component("movement_state")

		template_data.movement_state_component = movement_state_component
	end,
	conditional_keywords_func = function (template_data, template_context, t)
		return template_data.movement_state_component.method == "sliding"
	end,
	conditional_keywords = {
		keywords.count_as_dodge_vs_melee,
	},
}
templates.broker_passive_restore_toughness_on_close_ranged_kill = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_passive_restore_toughness_on_close_ranged_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_close_kill,
	proc_func = function (params, template_data, template_context)
		local player_unit = template_context.unit
		local toughness_percentage = talent_settings.broker_passive_restore_toughness_on_close_ranged_kill.toughness_percentage

		if params.tags.elite or params.tags.special then
			toughness_percentage = talent_settings.broker_passive_restore_toughness_on_close_ranged_kill.toughness_elites
		end

		Toughness.replenish_percentage(player_unit, toughness_percentage)
	end,
}
templates.broker_passive_restore_toughness_on_weakspot_kill = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_passive_restore_toughness_on_weakspot_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	start_func = function (template_data, template_context)
		template_data.toughness_granted_this_attack = 0
		template_data.last_target_index = math.huge
	end,
	proc_func = function (params, template_data, template_context)
		if not template_context.is_server then
			return
		end

		if params.is_instakill then
			return
		end

		if params.target_index <= template_data.last_target_index then
			template_data.toughness_granted_this_attack = 0
		end

		local toughness_percentage = talent_settings.broker_passive_restore_toughness_on_weakspot_kill.default

		if params.hit_weakspot and params.is_critical_strike then
			toughness_percentage = talent_settings.broker_passive_restore_toughness_on_weakspot_kill.critical
		elseif params.hit_weakspot or params.is_critical_strike then
			toughness_percentage = talent_settings.broker_passive_restore_toughness_on_weakspot_kill.weakspot
		end

		local toughness_to_grant = toughness_percentage - template_data.toughness_granted_this_attack

		if toughness_to_grant > 0 then
			template_data.toughness_granted_this_attack = template_data.toughness_granted_this_attack + toughness_to_grant

			local player_unit = template_context.unit

			Toughness.replenish_percentage(player_unit, toughness_percentage)
		end

		template_data.last_target_index = params.target_index
	end,
}
templates.broker_passive_reduced_toughness_damage_during_reload = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_passive_reduced_toughness_damage_during_reload",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.toughness_damage_taken_modifier] = talent_settings.broker_passive_reduced_toughness_damage_during_reload.toughness_damage_taken_modifier,
	},
	proc_events = {
		[proc_events.on_reload_start] = 1,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		return template_data.is_reloading or t < template_data.conditional_func_timestamp
	end,
	start_func = function (template_data, template_context)
		template_data.conditional_func_timestamp = -math.huge
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_data.is_reloading and not ConditionalFunctions.is_reloading(template_data, template_context) then
			template_data.is_reloading = false
			template_data.conditional_func_timestamp = t + talent_settings.broker_passive_reduced_toughness_damage_during_reload.duration
		end
	end,
	check_active_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		return template_data.is_reloading or t < template_data.conditional_func_timestamp
	end,
	duration_func = function (template_data, template_context)
		if template_data.is_reloading then
			return 1
		end

		local t = FixedFrame.get_latest_fixed_time()

		return (template_data.conditional_func_timestamp - t) / talent_settings.broker_passive_reduced_toughness_damage_during_reload.duration
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.is_reloading = true
	end,
}
templates.broker_passive_sprinting_reduces_threat = {
	class_name = "buff",
	max_stacks = 1,
	predicted = false,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

		template_data.sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")

		local movement_state_component = unit_data_extension:read_component("movement_state")

		template_data.movement_state_component = movement_state_component
		template_data.sprinting = false
		template_data.next_buff_t = 0
		template_data.value = 0
		template_data.threshold = talent_settings.broker_passive_sprinting_reduces_threat.threshold
	end,
	update_func = function (template_data, template_context, dt, t)
		local sprint_character_state_component = template_data.sprint_character_state_component
		local is_sprinting = Sprint.is_sprinting(sprint_character_state_component)
		local is_sliding = template_data.movement_state_component.method == "sliding"
		local add_buff = is_sprinting or is_sliding

		if add_buff then
			template_data.value = template_data.value + dt
		else
			template_data.value = 0.5
		end

		local threshold = template_data.threshold

		if threshold <= template_data.value then
			template_data.value = template_data.value - threshold

			template_data.buff_extension:add_internally_controlled_buff("broker_passive_sprinting_reduces_threat_buff", t)
		end
	end,
}
templates.broker_passive_sprinting_reduces_threat_buff = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_passive_sprinting_reduces_threat",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	max_stacks = talent_settings.broker_passive_sprinting_reduces_threat.max_stacks,
	duration = talent_settings.broker_passive_sprinting_reduces_threat.duration,
	stat_buffs = {
		[stat_buffs.threat_weight_multiplier] = talent_settings.broker_passive_sprinting_reduces_threat.threat_weight_multiplier,
	},
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:refresh_duration_of_stacking_buff("broker_passive_sprinting_reduces_threat_buff", t)
	end,
	related_talents = {
		"broker_passive_sprinting_reduces_threat",
	},
}
templates.broker_passive_improved_sprint_dodge = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.sprint_dodge_reduce_angle_threshold_rad] = talent_settings.broker_passive_improved_sprint_dodge.sprint_dodge_reduce_angle_threshold_rad,
	},
	keywords = {
		keywords.sprint_dodge_in_overtime,
	},
}
templates.broker_passive_extra_consecutive_dodges = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.extra_consecutive_dodges] = talent_settings.broker_passive_extra_consecutive_dodges.extra_consecutive_dodges,
	},
}
templates.broker_passive_extended_mag = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.clip_size_modifier] = talent_settings.broker_passive_extended_mag.clip_size_modifier,
	},
}
templates.broker_passive_reload_on_crit = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_crit_hit,
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		template_data.inventory_slot_secondary_component = unit_data_extension:write_component("slot_secondary")
		template_data.visual_loadout_extension = visual_loadout_extension
	end,
	proc_func = function (params, template_data, template_context, t)
		local ammo_replenish_percent = talent_settings.broker_passive_reload_on_crit.ammo_replenish_percent
		local inventory_slot_secondary_component = template_data.inventory_slot_secondary_component
		local max_ammo_in_clip = Ammo.max_ammo_in_clips(inventory_slot_secondary_component)
		local missing_ammo_in_clip = Ammo.missing_ammo_in_clips(inventory_slot_secondary_component)
		local amount = math.clamp(math.floor(max_ammo_in_clip * ammo_replenish_percent), 0, missing_ammo_in_clip)

		Ammo.transfer_from_reserve_to_clip(inventory_slot_secondary_component, amount)

		local weapon_template = template_data.visual_loadout_extension:weapon_template_from_slot("slot_secondary")
		local reload_template = weapon_template.reload_template

		if reload_template then
			ReloadStates.reset(reload_template, inventory_slot_secondary_component)
		end
	end,
}
templates.broker_passive_reload_speed_on_close_kill = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_passive_reload_speed_on_close_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	active_duration = talent_settings.broker_passive_reload_speed_on_close_kill.duration,
	check_proc_func = CheckProcFunctions.on_ranged_close_kill,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.reload_speed] = talent_settings.broker_passive_reload_speed_on_close_kill.reload_speed,
	},
}
templates.broker_passive_crit_kill_at_close_range_reload = {
	class_name = "proc_buff",
	predicted = false,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_ranged_close_kill, CheckProcFunctions.on_crit),
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		template_data.inventory_slot_secondary_component = unit_data_extension:write_component("slot_secondary")
		template_data.visual_loadout_extension = visual_loadout_extension
	end,
	proc_func = function (params, template_data, template_context, t)
		local inventory_slot_secondary_component = template_data.inventory_slot_secondary_component
		local missing_ammo_in_clip = Ammo.missing_ammo_in_clips(inventory_slot_secondary_component)

		Ammo.transfer_from_reserve_to_clip(inventory_slot_secondary_component, missing_ammo_in_clip)

		local weapon_template = template_data.visual_loadout_extension:weapon_template_from_slot("slot_secondary")
		local reload_template = weapon_template.reload_template

		if reload_template then
			ReloadStates.reset(reload_template, inventory_slot_secondary_component)
		end
	end,
}
templates.broker_passive_hollowtip_bullets = {
	class_name = "proc_buff",
	predicted = false,
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_ranged_stagger_hit),
	stat_buffs = {
		[stat_buffs.ranged_impact_modifier] = 1,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		template_data.locomotion_component = unit_data_extension:read_component("locomotion")
		template_data.inventory_slot_secondary_component = unit_data_extension:write_component("slot_secondary")
		template_data.visual_loadout_extension = visual_loadout_extension
	end,
	proc_func = function (params, template_data, template_context, t)
		local roll = math.random_range(0, 1)

		if roll < 0.15 then
			local force_stagger_type = StaggerSettings.stagger_types.explosion
			local player_rotation = template_data.locomotion_component.rotation
			local attack_direction = Quaternion.forward(player_rotation)
			local force_stagger_duration = 2.5

			Stagger.force_stagger(params.attacked_unit, force_stagger_type, attack_direction, force_stagger_duration, 1, force_stagger_duration, template_context.unit)
		end
	end,
}
templates.broker_passive_heavy_attack_dash = {
	class_name = "proc_buff",
	proc_events = {
		[proc_events.on_hit] = 1,
		[proc_events.on_sweep_start] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		template_data.buff_extension = buff_extension
	end,
	specific_check_proc_funcs = {
		[proc_events.on_sweep_start] = CheckProcFunctions.all(CheckProcFunctions.on_heavy_attack_started, CheckProcFunctions.on_sprinting),
	},
	specific_proc_func = {
		[proc_events.on_sweep_start] = function (params, template_data, template_context, t)
			if not template_data.dash_ready then
				return
			end

			local buff_extension = template_data.buff_extension

			if buff_extension then
				buff_extension:add_internally_controlled_buff("broker_heavy_attack_dash", t)
				buff_extension:add_internally_controlled_buff("broker_heavy_attack_stat_buff", t)
			end

			template_data.dash_ready = false
		end,
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			template_data.dash_ready = true
		end,
	},
}

local function smoothstep_lerp_t_func(t, start_time, duration, template_data, template_context)
	return math.smoothstep(t, start_time, start_time + duration)
end

templates.broker_heavy_attack_dash = {
	class_name = "buff",
	duration = 0.15,
	predicted = false,
	lerped_stat_buffs = {
		[stat_buffs.movement_speed] = {
			max = 2,
			min = 0.8,
		},
	},
	lerp_t_func = smoothstep_lerp_t_func,
	update_func = function (template_data, template_context, dt, t, template)
		return
	end,
}
templates.broker_heavy_attack_stat_buff = {
	class_name = "buff",
	duration = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.impact_modifier] = 1,
		[stat_buffs.melee_damage] = 0.8,
	},
	lerp_t_func = smoothstep_lerp_t_func,
}
templates.broker_passive_close_ranged_finesse_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.finesse_close_range_modifier] = talent_settings.broker_passive_close_ranged_finesse_damage.finesse_close_range_modifier,
	},
}
templates.broker_passive_close_range_damage_on_dodge = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_close_range_damage_on_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	active_duration = talent_settings.broker_passive_close_range_damage_on_dodge.active_duration,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_stat_buffs = {
		[stat_buffs.damage_near] = talent_settings.broker_passive_close_range_damage_on_dodge.damage_near,
	},
}
templates.broker_passive_close_range_damage_on_slide = {
	active_duration = 2,
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_slide_start] = 1,
		[proc_events.on_slide_end] = 1,
	},
	conditional_stat_buffs = {
		[stat_buffs.damage_near] = talent_settings.broker_passive_close_range_damage_on_slide.damage_near,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.is_sliding
	end,
	check_active_func = function (template_data, template_context)
		return template_data.is_sliding
	end,
	specific_proc_func = {
		[proc_events.on_slide_start] = function (params, template_data, template_context)
			template_data.is_sliding = true
		end,
		[proc_events.on_slide_end] = function (params, template_data, template_context)
			template_data.is_sliding = false
		end,
	},
}
templates.broker_passive_finesse_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.finesse_modifier_bonus] = talent_settings.broker_passive_finesse_damage.finesse_modifier_bonus,
	},
}
templates.broker_passive_ramping_backstabs = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	start_func = function (template_data, template_context)
		template_data.buff_ids = {}
	end,
	proc_func = function (params, template_data, template_context, t)
		if params.is_backstab then
			local _, buff_id = template_context.buff_extension:add_externally_controlled_buff("broker_ramping_backstabs_stat_buff", t)

			template_data.buff_ids[buff_id] = true
		else
			for buff_id in pairs(template_data.buff_ids) do
				template_context.buff_extension:mark_buff_finished(buff_id)

				template_data.buff_ids[buff_id] = nil
			end
		end
	end,
}
templates.broker_ramping_backstabs_stat_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_ramping_backstabs",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	skip_tactical_overlay = true,
	max_stacks = talent_settings.broker_passive_ramping_backstabs.max_stacks,
	stat_buffs = {
		[stat_buffs.melee_power_level_modifier] = talent_settings.broker_passive_ramping_backstabs.melee_power_level_modifier,
	},
}

local function _blitz_charge_on_kill_proc_func(params, template_data, template_context, t)
	local max_ability_charges = template_data.ability_extension:max_ability_charges("grenade_ability")
	local remaining_ability_charges = template_data.ability_extension:remaining_ability_charges("grenade_ability")

	if remaining_ability_charges < max_ability_charges then
		local num_kills = template_data.tracked_kills + 1

		if num_kills >= talent_settings.blitz.flash_grenade.num_kills then
			num_kills = 0

			template_data.ability_extension:restore_ability_charge("grenade_ability", talent_settings.blitz.flash_grenade.num_charges)
		end

		template_data.tracked_kills = num_kills
	end
end

templates.broker_passive_blitz_charge_on_kill = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_broker_flash_grenade",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_blitz",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	skip_tactical_overlay = true,
	check_proc_func = CheckProcFunctions.on_close_kill,
	proc_events = {
		[proc_events.on_kill] = 1,
		[proc_events.on_hit] = 1,
		[proc_events.on_minion_death] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.ability_extension = ScriptUnit.extension(unit, "ability_system")
		template_data.tracked_kills = 0

		_bespoke_needlepistol_close_range_kill_start(template_data, template_context)
	end,
	update_func = function (template_data, template_context, dt, t)
		_bespoke_needlepistol_close_range_kill_update(template_data, template_context, dt, t)
	end,
	specific_check_proc_funcs = {
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			return _bespoke_needlepistol_close_range_kill_check_proc_hit(params, template_data, template_context, t)
		end,
		[proc_events.on_minion_death] = function (params, template_data, template_context, t)
			return _bespoke_needle_pistol_close_range_kill_check_proc_minion_death(params, template_data, template_context, t)
		end,
	},
	specific_proc_func = {
		[proc_events.on_hit] = function (params, template_data, template_context, t)
			_bespoke_needle_pistol_close_range_kill_proc_hit(params, template_data, template_context, t)
		end,
		[proc_events.on_minion_death] = function (params, template_data, template_context, t)
			_blitz_charge_on_kill_proc_func(params, template_data, template_context, t)
			_bespoke_needle_pistol_close_range_kill_proc_on_minion_death(params, template_data, template_context, t)
		end,
		[proc_events.on_kill] = _blitz_charge_on_kill_proc_func,
	},
	visual_stack_count = function (template_data, template_context)
		return template_data.tracked_kills
	end,
}
templates.broker_passive_weakspot_on_x_hit = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit

		template_data.buff_extension = ScriptUnit.extension(unit, "buff_system")
		template_data.num_hits = 0
	end,
	proc_func = function (params, template_data, template_context, t)
		local num_hits = template_data.num_hits + 1

		if num_hits >= talent_settings.broker_passive_weakspot_on_x_hit.num_hits - 1 then
			num_hits = -1

			template_data.buff_extension:add_internally_controlled_buff("broker_passive_weakspot_on_x_hit_guaranteed_weakspot", t)
		end

		template_data.num_hits = num_hits
	end,
}
templates.broker_passive_weakspot_on_x_hit_guaranteed_weakspot = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	max_stacks = 1,
	predicted = false,
	remove_on_proc = true,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	keywords = {
		keywords.guaranteed_weakspot_on_hit,
	},
}
templates.broker_passive_close_range_rending = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.close_range_rending_multiplier] = talent_settings.broker_passive_close_range_rending.multiplier,
	},
}
templates.broker_passive_crit_to_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.critical_strike_chance_to_damage_convert] = 1,
	},
}
templates.broker_passive_strength_vs_aggroed = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.power_level_modifier_vs_aggroed_elites] = talent_settings.broker_passive_strength_vs_aggroed.power_level_modifier,
		[stat_buffs.power_level_modifier_vs_aggroed_monsters] = talent_settings.broker_passive_strength_vs_aggroed.power_level_modifier,
	},
}
templates.broker_passive_punk_grit = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings.broker_passive_punk_grit.ranged_damage,
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.broker_passive_punk_grit.toughness_damage_taken_multiplier,
	},
}
templates.broker_passive_stamina_on_successful_dodge = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_stamina_on_successful_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_successful_dodge] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		local stamina_percent = talent_settings.broker_passive_stamina_on_successful_dodge.stamina

		Stamina.add_stamina_percent(template_context.unit, stamina_percent)
	end,
}
templates.broker_passive_improved_dodges_at_full_stamina = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_improved_dodges_at_full_stamina",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	conditional_threshold = talent_settings.broker_passive_improved_dodges_at_full_stamina.conditional_threshold,
	conditional_stat_buffs = {
		[stat_buffs.dodge_cooldown_reset_modifier] = talent_settings.broker_passive_improved_dodges_at_full_stamina.dodge_cooldown_reset_modifier,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		local unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")

		template_data.stamina_read_component = unit_data_extension:read_component("stamina")

		local current_stamina_fraction = template_data.stamina_read_component.current_fraction
		local buff_template = template_context.template
		local override_data = template_context.template_override_data
		local conditional_threshold = override_data.conditional_threshold or buff_template.conditional_threshold or 0

		return conditional_threshold <= current_stamina_fraction
	end,
}
templates.broker_passive_stamina_grants_atk_speed = {
	always_show_in_hud = true,
	class_name = "stepped_stat_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_stamina_grants_atk_speed",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	skip_tactical_overlay = true,
	stack_offset = -1,
	conditional_stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings.broker_passive_stamina_grants_atk_speed.attack_speed_increase,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
		local stamina_read_component = unit_data_ext:read_component("stamina")

		template_data.unit_data_ext = unit_data_ext
		template_data.stamina_read_component = stamina_read_component
	end,
	min_max_step_func = function (template_data, template_context)
		local max_steps = 2 * talent_settings.broker_passive_stamina_grants_atk_speed.max_stacks

		return 0, max_steps
	end,
	bonus_step_func = function (template_data, template_context)
		local unit = template_context.unit
		local stamina_read_component = template_data.stamina_read_component
		local base_stamina_template = template_data.unit_data_ext:archetype().stamina
		local current_value = Stamina.current_and_max_value(unit, stamina_read_component, base_stamina_template)
		local steps = math.floor(current_value)

		return steps
	end,
}
templates.broker_passive_increased_weakspot_damage = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.weakspot_damage] = talent_settings.broker_passive_increased_weakspot_damage.weakspot_damage,
	},
}
templates.broker_passive_big_sidesteps_during_reload = {
	class_name = "buff",
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.dodge_distance_modifier] = 2,
		[stat_buffs.dodge_speed_multiplier] = 0.4,
		[stat_buffs.dodge_cooldown_reset_modifier] = -1,
	},
	conditional_stat_buffs_func = ConditionalFunctions.is_reloading,
}
templates.broker_passive_stun_immunity_on_toughness_broken = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_stun_immunity_on_toughness_broken",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_player_toughness_broken] = 1,
	},
	check_proc_func = CheckProcFunctions.is_self,
	proc_keywords = {
		keywords.stun_immune,
	},
	active_duration = talent_settings.broker_passive_stun_immunity_on_toughness_broken.duration,
	cooldown_duration = talent_settings.broker_passive_stun_immunity_on_toughness_broken.cooldown,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local toughness_percentage = talent_settings.broker_passive_stun_immunity_on_toughness_broken.toughness

		Toughness.replenish_percentage(template_context.unit, toughness_percentage)
	end,
}
templates.broker_passive_push_on_damage_taken = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("broker_passive_push_on_damage_taken_stack", t)
	end,
}
templates.broker_passive_push_on_damage_taken_stack = {
	always_show_in_hud = true,
	class_name = "proc_buff",
	predicted = false,
	remove_stack_on_proc = true,
	max_stacks = talent_settings.broker_passive_push_on_damage_taken.max_stacks,
	max_stacks_cap = talent_settings.broker_passive_push_on_damage_taken.max_stacks,
	proc_events = {
		[proc_events.on_push_hit] = 1,
	},
	stat_buffs = {
		[stat_buffs.inner_push_angle_modifier] = talent_settings.broker_passive_push_on_damage_taken.angle,
		[stat_buffs.outer_push_angle_modifier] = talent_settings.broker_passive_push_on_damage_taken.angle,
		[stat_buffs.push_impact_modifier] = talent_settings.broker_passive_push_on_damage_taken.impact,
		[stat_buffs.push_cost_multiplier] = talent_settings.broker_passive_push_on_damage_taken.push_cost_multiplier,
	},
	stat_buff_multiplier = function (template_data, template_context)
		return 1 / template_context.stack_count
	end,
}
templates.broker_passive_replenish_toughness_on_ranged_toughness_damage = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_damage_taken] = 1,
	},
	check_proc_func = CheckProcFunctions.combine(CheckProcFunctions.has_toughness, CheckProcFunctions.on_ranged_hit),
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("broker_passive_replenish_toughness_on_ranged_toughness_damage_regen", t)
	end,
}
templates.broker_passive_replenish_toughness_on_ranged_toughness_damage_regen = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_replenish_toughness_on_ranged_toughness_damage-copy-2",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	duration = talent_settings.broker_passive_replenish_toughness_on_ranged_toughness_damage.duration,
	keywords = {
		keywords.prevent_toughness_regen_when_depleted,
	},
	stat_buffs = {
		[stat_buffs.toughness_regen_percent] = talent_settings.broker_passive_replenish_toughness_on_ranged_toughness_damage.toughness / talent_settings.broker_passive_replenish_toughness_on_ranged_toughness_damage.duration,
	},
	proc_events = {
		[proc_events.on_player_toughness_broken] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		template_context.buff:force_finish()
	end,
}
templates.broker_passive_ammo_on_backstab = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.any(CheckProcFunctions.on_melee_backstab_kill, CheckProcFunctions.on_crit_ranged),
	conditional_proc_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()

		return t >= template_data.next_proc_allowed_t
	end,
	start_func = function (template_data, template_context)
		template_data.next_proc_allowed_t = 0
		template_data.unit = template_context.unit
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.next_proc_allowed_t = t + talent_settings.broker_passive_ammo_on_backstab.cooldown

		Ammo.add_to_all_slots(template_data.unit, talent_settings.broker_passive_ammo_on_backstab.ammo_regain)
	end,
}
templates.broker_passive_stimm_increased_duration = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.syringe_duration] = talent_settings.broker_passive_stimm_increased_duration.duration_increase,
	},
}
templates.broker_passive_stimm_cleanse_on_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_syringe_used] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("broker_passive_stimm_cleanse_on_kill_buff", t)
	end,
}
templates.broker_passive_stimm_cleanse_on_kill_buff = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_stimm_cleanse_on_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	skip_tactical_overlay = true,
	cleanse_amount = talent_settings.broker_passive_stimm_cleanse_on_kill.cleanse_amount,
	cleanse_threshold = talent_settings.broker_passive_stimm_cleanse_on_kill.cleanse_threshold,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context, t)
		template_data.corruption_cleansed = 0
		template_data.health_extension = ScriptUnit.extension(template_context.unit, "health_system")
	end,
	refresh_func = function (template_data, template_context, t)
		template_data.corruption_cleansed = 0
	end,
	proc_func = function (params, template_data, template_context, t)
		local max_health = template_data.health_extension:max_health()

		if template_data.corruption_cleansed < template_context.template.cleanse_threshold * max_health then
			local health_extension = template_data.health_extension
			local permanent_damage_before = health_extension:permanent_damage_taken()

			health_extension:reduce_permanent_damage(template_context.template.cleanse_amount * max_health)

			local permanent_damage_after = health_extension:permanent_damage_taken()

			template_data.corruption_cleansed = template_data.corruption_cleansed + math.max(permanent_damage_before - permanent_damage_after, 0)
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		return not template_context.buff_extension:has_keyword(keywords.syringe)
	end,
}
templates.broker_passive_damage_on_reload = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_reload] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("broker_passive_damage_on_reload_buff", t)
	end,
}
templates.broker_passive_damage_on_reload_buff = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_damage_on_reload",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	skip_tactical_overlay = true,
	duration = talent_settings.broker_passive_damage_on_reload.duration,
	base_damage = talent_settings.broker_passive_damage_on_reload.base_damage,
	damage_per_ammo_stage = talent_settings.broker_passive_damage_on_reload.damage_per_ammo_stage,
	ammo_percentage_per_stage = talent_settings.broker_passive_damage_on_reload.ammo_percentage_per_stage,
	stat_buffs = {
		[stat_buffs.ranged_damage] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		template_data.visual_loadout_extension = ScriptUnit.extension(template_context.unit, "visual_loadout_system")
		template_data.reload_slot = "slot_secondary"
		template_data.inventory_slot_secondary_component = template_data.unit_data_extension:read_component("slot_secondary")
		template_data.ammo_spent = 0
	end,
	refresh_func = function (template_data, template_context)
		template_data.ammo_spent = 0
	end,
	proc_events = {
		[proc_events.on_ammo_consumed] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		if template_data.visual_loadout_extension:currently_wielded_slot() ~= template_data.reload_slot then
			return
		end

		template_data.ammo_spent = template_data.ammo_spent + params.ammo_usage
	end,
	stat_buff_multiplier = function (template_data, template_context)
		if not template_data.visual_loadout_extension:is_equipped(template_data.reload_slot) then
			return 0
		end

		local template = template_context.template
		local base_damage = template.base_damage
		local damage_per_ammo_stage = template.damage_per_ammo_stage
		local ammo_percentage_per_stage = template.ammo_percentage_per_stage
		local max_ammo_in_clip = Ammo.max_ammo_in_clips(template_data.inventory_slot_secondary_component)
		local ammo_stage = math.floor(template_data.ammo_spent / (max_ammo_in_clip * ammo_percentage_per_stage))

		return base_damage + damage_per_ammo_stage * ammo_stage
	end,
}

local instakill_params_scratch = {}
local instakill_passalong_params = {
	"attack_type",
}

instakill_passalong_params[0] = #instakill_passalong_params
templates.broker_passive_melee_crit_instakill = {
	class_name = "proc_buff",
	health_by_damage_threshold = 2,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit_melee,
	proc_func = function (params, template_data, template_context, t)
		local health_extension = ScriptUnit.has_extension(params.attacked_unit, "health_system")

		if not health_extension or not health_extension:is_alive() then
			return
		end

		local is_human_sized = Breed.human_sized(Breeds[params.breed_name])

		if not is_human_sized then
			return
		end

		if Breed.enemy_type(Breeds[params.breed_name]) == "captain" then
			return
		end

		local threshold = (params.actual_damage_dealt or params.damage_dealt or 0) * template_context.template.health_by_damage_threshold

		if health_extension:current_health() < threshold * 0.5 then
			table.clear(instakill_params_scratch)

			instakill_params_scratch[1] = "instakill"
			instakill_params_scratch[2] = true
			instakill_params_scratch[3] = "attacking_unit"
			instakill_params_scratch[4] = template_context.unit

			local next_idx = 5

			for i = 1, instakill_passalong_params[0] do
				local param = instakill_passalong_params[i]

				if params[param] ~= nil then
					instakill_params_scratch[next_idx] = param
					instakill_params_scratch[next_idx + 1] = params[param]
					next_idx = next_idx + 2
				end
			end

			local damage_profile = DamageProfileTemplates.default

			Attack.execute(params.attacked_unit, damage_profile, unpack(instakill_params_scratch))
		end
	end,
}
templates.broker_passive_dr_damage_tradeoff_on_stamina = {
	class_name = "buff",
	predicted = false,
	damage_multiplier = talent_settings.broker_passive_dr_damage_tradeoff_on_stamina.damage_multiplier,
	damage_reduction_multiplier = talent_settings.broker_passive_dr_damage_tradeoff_on_stamina.damage_reduction_multiplier,
	stat_buffs = {
		[stat_buffs.damage_taken_multiplier] = 1,
		[stat_buffs.melee_damage] = 1,
	},
	stat_buff_multipliers = {
		[stat_buffs.damage_taken_multiplier] = function (template_data, template_context)
			local unit = template_context.unit
			local stamina_read_component = template_data.stamina_read_component
			local base_stamina_template = template_data.unit_data_ext:archetype().stamina
			local current_value, max_value = Stamina.current_and_max_value(unit, stamina_read_component, base_stamina_template)
			local reduction = template_context.template.damage_reduction_multiplier

			return math.lerp(1, 1 - reduction, math.clamp01(current_value / max_value))
		end,
		[stat_buffs.melee_damage] = function (template_data, template_context)
			local unit = template_context.unit
			local stamina_read_component = template_data.stamina_read_component
			local base_stamina_template = template_data.unit_data_ext:archetype().stamina
			local current_value, max_value = Stamina.current_and_max_value(unit, stamina_read_component, base_stamina_template)
			local increase = template_context.template.damage_multiplier

			return math.lerp(0, increase, 1 - math.clamp01(current_value / max_value))
		end,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
		local stamina_read_component = unit_data_ext:read_component("stamina")

		template_data.unit_data_ext = unit_data_ext
		template_data.stamina_read_component = stamina_read_component
	end,
}
templates.broker_passive_damage_vs_elites_monsters = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_vs_elites] = 0.15,
		[stat_buffs.damage_vs_monsters] = 0.15,
	},
}
templates.broker_passive_melee_cleave_on_melee_kill = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("broker_passive_melee_cleave_on_melee_kill_buff", t)
	end,
}
templates.broker_passive_melee_cleave_on_melee_kill_buff = {
	class_name = "buff",
	duration = 5,
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_melee_cleave_on_melee_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 5,
	max_stacks_cap = 5,
	predicted = false,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	stat_buffs = {
		[stat_buffs.max_melee_hit_mass_attack_modifier] = 0.1,
	},
}
templates.broker_passive_damage_vs_heavy_staggered = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_vs_heavy_staggered] = talent_settings.broker_passive_damage_vs_heavy_staggered.multiplier,
	},
}
templates.broker_passive_cleave_on_cleave = {
	class_name = "proc_buff",
	predicted = false,
	min_targets = talent_settings.broker_passive_cleave_on_cleave.min_targets,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_hit,
	proc_func = function (params, template_data, template_context, t)
		if params.target_number >= template_context.template.min_targets then
			if not template_data.procced then
				template_data.procced = true

				template_context.buff_extension:add_internally_controlled_buff("broker_passive_cleave_on_cleave_buff", t)
			end
		else
			template_data.procced = false
		end
	end,
}
templates.broker_passive_cleave_on_cleave_buff = {
	class_name = "proc_buff",
	predicted = false,
	remove_on_proc = true,
	stat_buffs = {
		[stat_buffs.max_hit_mass_attack_modifier] = talent_settings.broker_passive_cleave_on_cleave.max_hit_mass_attack_modifier,
		[stat_buffs.max_hit_mass_impact_modifier] = talent_settings.broker_passive_cleave_on_cleave.max_hit_mass_attack_modifier,
	},
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = function (params)
		return params.target_number < templates.broker_passive_cleave_on_cleave.min_targets
	end,
}
templates.broker_passive_increased_blitz_ammo = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.extra_max_amount_of_grenades] = 1,
	},
	start_func = function (template_data, template_context)
		local unit = template_context.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local template = template_context.template
		local extra_grenades = template.stat_buffs.extra_max_amount_of_grenades
		local grenade_ability_component = unit_data_extension:write_component("grenade_ability")

		template_context.initial_num_charges = grenade_ability_component.num_charges
		grenade_ability_component.num_charges = grenade_ability_component.num_charges + extra_grenades
	end,
}
templates.broker_passive_increased_aura_size = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {
		[stat_buffs.coherency_radius_modifier] = talent_settings.broker_passive_increased_aura_size.coherency_radius_modifier,
	},
}
templates.broker_passive_stimm_cd_on_kill = {
	class_name = "proc_buff",
	predicted = false,
	restore = 0.01,
	restore_toxined = 0.02,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		if template_data.ability_extension:is_cooldown_paused("pocketable_ability") then
			return
		end

		local restore
		local buff_extension = ScriptUnit.has_extension(params.attacked_unit, "buff_system")

		if buff_extension and buff_extension:has_keyword(keywords.toxin) then
			restore = template_context.template.restore_toxined
		else
			restore = template_context.template.restore
		end

		template_data.ability_extension:reduce_ability_cooldown_percentage("pocketable_ability", restore)
	end,
}

local PI = math.pi
local PI_2 = PI * 2

templates.broker_passive_stun_on_max_toxin_stacks = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_buff_stack_added] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.side_system = Managers.state.extension:system("side_system")
		template_data.relevant_keywords = table.set({
			keywords.toxin,
		})
		template_data.buff_templates = require("scripts/settings/buff/buff_templates")
		template_data.cooldown_list = {}
	end,
	update_func = function (template_data, template_context, dt, t)
		for unit, cd_timestamp in pairs(template_data.cooldown_list) do
			if cd_timestamp < t then
				template_data.cooldown_list[unit] = nil
			end
		end
	end,
	proc_func = function (params, template_data, template_context, t)
		local is_enemy = template_data.side_system:is_enemy(params.unit, template_context.unit)

		if not is_enemy then
			return
		end

		if template_data.cooldown_list[params.unit] then
			return
		end

		local buff_template = template_data.buff_templates[params.template_name]
		local buff_keywords = buff_template.keywords

		if not buff_keywords then
			return
		end

		local valid = false
		local relevant_keywords = template_data.relevant_keywords

		for i = 1, #buff_keywords do
			if relevant_keywords[buff_keywords[i]] then
				valid = true

				break
			end
		end

		if not valid then
			return
		end

		local settings = talent_settings.broker_passive_stun_on_max_toxin_stacks
		local threshold = settings.threshold or buff_template.max_stacks
		local enemy_unit_buff_extension = ScriptUnit.has_extension(params.unit, "buff_system")
		local current_stacks = enemy_unit_buff_extension:current_stacks(buff_template.name)

		if threshold <= current_stacks then
			enemy_unit_buff_extension:add_internally_controlled_buff("broker_toxin_stacks_stun", t)

			template_data.cooldown_list[params.unit] = t + settings.duration + settings.cooldown
		end
	end,
}
templates.broker_toxin_stacks_stun = {
	buff_id = "broker_toxin_stacks_stun",
	class_name = "interval_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	start_interval_on_apply = true,
	start_with_frame_offset = true,
	keywords = {
		keywords.electrocuted,
	},
	interval = {
		0.3,
		0.8,
	},
	duration = talent_settings.broker_passive_stun_on_max_toxin_stacks.duration,
	start_func = function (template_data, template_context)
		template_data.side_system = Managers.state.extension:system("side_system")
		template_data.relevant_keywords = table.set({
			keywords.toxin,
		})
		template_data.buff_templates = require("scripts/settings/buff/buff_templates")
	end,
	interval_func = function (template_data, template_context, template, dt, t)
		local is_server = template_context.is_server

		if not is_server then
			return
		end

		local unit = template_context.unit

		if ALIVE[unit] and HEALTH_ALIVE[unit] then
			local damage_template = DamageProfileTemplates.broker_toxin_stacks_stun_interval
			local owner_unit = template_context.owner_unit
			local power_level = PowerLevelSettings.default_power_level
			local random_radians = math.random_range(0, PI_2)
			local attack_direction = Vector3(math.sin(random_radians), math.cos(random_radians), 0)

			attack_direction = Vector3.normalize(attack_direction)

			Attack.execute(unit, damage_template, "power_level", power_level, "damage_type", damage_types.electrocution, "attack_type", attack_types.buff, "attacking_unit", HEALTH_ALIVE[owner_unit] and owner_unit, "attack_direction", attack_direction)

			local buff_extension = template_context.buff_extension

			if buff_extension then
				buff_extension:add_internally_controlled_buff("shock_effect", t)
			end
		end
	end,
}
templates.broker_passive_reduced_damage_by_toxined = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_buff_added] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.side_system = Managers.state.extension:system("side_system")
		template_data.relevant_keywords = table.set({
			keywords.toxin,
		})
		template_data.buff_templates = require("scripts/settings/buff/buff_templates")
	end,
	proc_func = function (params, template_data, template_context, t)
		local is_enemy = template_data.side_system:is_enemy(params.unit, template_context.unit)

		if not is_enemy then
			return
		end

		local buff_template = template_data.buff_templates[params.template_name]
		local buff_keywords = buff_template.keywords

		if not buff_keywords then
			return
		end

		local valid = false
		local relevant_keywords = template_data.relevant_keywords

		for i = 1, #buff_keywords do
			if relevant_keywords[buff_keywords[i]] then
				valid = true

				break
			end
		end

		if not valid then
			return
		end

		local enemy_unit_data_extension = ScriptUnit.has_extension(params.unit, "unit_data_system")
		local enemy_unit_buff_extension = ScriptUnit.has_extension(params.unit, "buff_system")
		local breed = enemy_unit_data_extension and enemy_unit_data_extension:breed()
		local tags = breed and breed.tags
		local buff_to_add = "toxin_damage_debuff"

		if tags and (tags.monster or tags.captain or tags.cultist_captain) then
			buff_to_add = "toxin_damage_debuff_monster"
		end

		enemy_unit_buff_extension:add_internally_controlled_buff(buff_to_add, t)
	end,
}
templates.toxin_damage_debuff = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.broker_passive_reduced_damage_by_toxined.default_damage_debuff,
	},
	start_func = function (template_data, template_context)
		template_data.earliest_exit = template_context.buff:start_time() + 0.1
	end,
	conditional_exit_func = function (template_data, template_context, dt, t)
		if t < template_data.earliest_exit then
			return false
		end

		return not template_context.buff_extension:has_keyword(keywords.toxin)
	end,
}
templates.toxin_damage_debuff_monster = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage] = talent_settings.broker_passive_reduced_damage_by_toxined.monster_damage_debuff,
	},
	start_func = function (template_data, template_context)
		template_data.earliest_exit = template_context.buff:start_time() + 0.1
	end,
	conditional_exit_func = function (template_data, template_context, dt, t)
		if t < template_data.earliest_exit then
			return false
		end

		return not template_context.buff_extension:has_keyword(keywords.toxin)
	end,
}
templates.broker_passive_damage_after_toxined_enemies = {
	always_show_in_hud = true,
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_damage_after_toxined_enemies",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	conditional_stat_buffs = {
		[stat_buffs.damage] = talent_settings.broker_passive_damage_after_toxined_enemies.damage_per_stack,
	},
	conditional_stat_buffs_func = function (template_data, template_context)
		return template_data.num_toxined_in_range > 0
	end,
	stat_buff_multiplier = function (template_data, template_context)
		local max_increase_percentage = talent_settings.broker_passive_damage_after_toxined_enemies.max_increase * 100
		local damage_per_stack_percentage = talent_settings.broker_passive_damage_after_toxined_enemies.damage_per_stack * 100
		local max_stacks = max_increase_percentage / damage_per_stack_percentage

		return math.clamp(template_data.num_toxined_in_range, 0, max_stacks)
	end,
	visual_stack_count = function (template_data, template_context)
		return template_data.num_toxined_in_range
	end,
	start_func = function (template_data, template_context)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local unit = template_context.unit
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")

		template_data.broadphase = broadphase
		template_data.broadphase_results = {}
		template_data.num_toxined_in_range = 0
		template_data.check_enemy_proximity_t = 0
		template_data.enemy_side_names = enemy_side_names
		template_data.check_interval = talent_settings.broker_passive_damage_after_toxined_enemies.check_interval
		template_data.range = talent_settings.broker_passive_damage_after_toxined_enemies.range
	end,
	update_func = function (template_data, template_context, dt, t)
		if t < template_data.check_enemy_proximity_t then
			return
		end

		local broadphase = template_data.broadphase
		local enemy_side_names = template_data.enemy_side_names
		local broadphase_results = template_data.broadphase_results

		table.clear(broadphase_results)

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local range = template_data.range
		local num_hits = broadphase.query(broadphase, player_position, range, broadphase_results, enemy_side_names)

		if num_hits == 0 then
			template_data.num_toxined_in_range = 0
		else
			local count = 0

			for ii = 1, num_hits do
				local enemy_unit = broadphase_results[ii]
				local enemy_unit_buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

				if enemy_unit_buff_extension and enemy_unit_buff_extension:has_keyword(keywords.toxin) then
					count = count + 1
				end
			end

			template_data.num_toxined_in_range = count
		end

		template_data.check_enemy_proximity_t = t + template_data.check_interval
	end,
}
templates.broker_passive_toughness_on_toxined_kill = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_buff_added] = 1,
		[proc_events.on_buff_stack_added] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.side_system = Managers.state.extension:system("side_system")
		template_data.buff_templates = require("scripts/settings/buff/buff_templates")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return false
		end

		local is_enemy = template_data.side_system:is_enemy(params.unit, template_context.unit)

		if not is_enemy then
			return false
		end

		local buff_template = template_data.buff_templates[params.template_name]

		if buff_template.keywords and table.contains(buff_template.keywords, keywords.toxin) then
			return true
		end
	end,
	proc_func = function (params, template_data, template_context, t)
		local enemy_unit_buff_extension = ScriptUnit.has_extension(params.unit, "buff_system")

		enemy_unit_buff_extension:add_internally_controlled_buff("broker_toughness_on_toxined_kill", t)
	end,
}
templates.broker_toughness_on_toxined_kill = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_toughness_on_toxined_kill",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_default",
	hud_priority = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	skip_tactical_overlay = true,
	proc_events = {
		[proc_events.on_minion_damage_taken] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.side_system = Managers.state.extension:system("side_system")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return false
		elseif template_context.unit ~= params.attacked_unit then
			return false
		elseif params.attack_type ~= "melee" then
			return false
		elseif params.attack_results ~= "died" then
			return false
		elseif template_data.done then
			return false
		end

		local attacking_unit = params.attacking_unit
		local attacking_unit_data_extension = ScriptUnit.has_extension(attacking_unit, "unit_data_system")
		local breed = attacking_unit_data_extension and attacking_unit_data_extension:breed()

		if not breed then
			return false
		elseif not Breed.is_player(breed) then
			return false
		elseif not HEALTH_ALIVE[attacking_unit] then
			return false
		end

		return true
	end,
	proc_func = function (params, template_data, template_context, t)
		local attacker = params.attacking_unit
		local amount = talent_settings.broker_passive_toughness_on_toxined_kill.toughness_replenish

		Toughness.replenish_percentage(attacker, amount)

		template_data.done = true
	end,
}
templates.broker_passive_increased_toxin_damage = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_buff_added] = 1,
		[proc_events.on_buff_stack_added] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.side_system = Managers.state.extension:system("side_system")
		template_data.buff_templates = require("scripts/settings/buff/buff_templates")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return false
		end

		local is_enemy = template_data.side_system:is_enemy(params.unit, template_context.unit)

		if not is_enemy then
			return false
		end

		local buff_template = template_data.buff_templates[params.template_name]

		if buff_template.keywords and table.contains(buff_template.keywords, keywords.toxin) then
			return true
		end
	end,
	proc_func = function (params, template_data, template_context, t)
		local enemy_unit_buff_extension = ScriptUnit.has_extension(params.unit, "buff_system")

		enemy_unit_buff_extension:add_internally_controlled_buff("broker_increased_toxin_damage", t)
	end,
}
templates.broker_increased_toxin_damage = {
	class_name = "buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	stat_buffs = {
		[stat_buffs.damage_taken_from_toxin] = talent_settings.broker_passive_increased_toxin_damage.increase,
	},
	start_func = function (template_data, template_context)
		template_data.earliest_exit = template_context.buff:start_time() + 0.1
	end,
	conditional_exit_func = function (template_data, template_context, dt, t)
		if t < template_data.earliest_exit then
			return false
		end

		return not template_context.buff_extension:has_keyword(keywords.toxin)
	end,
}

local function _calculate_meleed_damage_carry_over(params, template_data, template_context)
	local carry_over = template_context.template.carry_over_percentage
	local successive = template_context.buff:is_proc_active()

	return carry_over * (params.overkill_damage - (successive and template_data.bonus_damage or 0))
end

templates.broker_passive_melee_damage_carry_over = {
	allow_proc_while_active = true,
	class_name = "proc_buff",
	predicted = false,
	active_duration = talent_settings.broker_passive_melee_damage_carry_over.active_duration,
	carry_over_percentage = talent_settings.broker_passive_melee_damage_carry_over.percentage,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = function (params, template_data, template_context, t)
		if params.is_instakill then
			return false
		end

		if not template_context.buff:is_proc_active() then
			return true
		end

		local carry_over = _calculate_meleed_damage_carry_over(params, template_data, template_context)

		if carry_over > template_data.bonus_damage then
			return true
		end

		return false
	end,
	proc_stat_buffs = {
		[stat_buffs.melee_damage_bonus] = 1,
	},
	stat_buff_multiplier = function (template_data)
		return template_data.bonus_damage
	end,
	proc_func = function (params, template_data, template_context, t)
		template_data.bonus_damage = _calculate_meleed_damage_carry_over(params, template_data, template_context)
	end,
	start_func = function (template_data, template_context)
		template_data.bonus_damage = 0
	end,
}
templates.broker_passive_low_ammo_regen = {
	ammo_threshold = 0.2,
	class_name = "proc_buff",
	force_predicted_proc = true,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_elite_or_special_kill,
	proc_func = function (params, template_data, template_context)
		local slot_secondary_component = template_data.unit_data_extension:write_component("slot_secondary")
		local max_reserve = Ammo.max_ammo_in_reserve(slot_secondary_component)

		if max_reserve > 0 then
			local current_ammo_reserve = Ammo.current_ammo_in_reserve(slot_secondary_component)
			local threshold = template_data.ammo_threshold
			local clip_percentage = current_ammo_reserve / max_reserve

			if clip_percentage < threshold then
				Ammo.add_to_reserve(slot_secondary_component, math.max(math.floor(max_reserve * threshold) - current_ammo_reserve, 1))
			end
		end
	end,
	start_func = function (template_data, template_context)
		template_data.unit_data_extension = ScriptUnit.extension(template_context.unit, "unit_data_system")
		template_data.ammo_threshold = template_context.template.ammo_threshold
	end,
}
templates.broker_passive_melee_attacks_apply_toxin = {
	class_name = "proc_buff",
	predicted = false,
	stacks_to_add = talent_settings.broker_passive_melee_attacks_apply_toxin.stacks,
	buff_to_add = talent_settings.broker_passive_melee_attacks_apply_toxin.toxin_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit_melee,
	proc_func = function (params, template_data, template_context, t)
		local buff_ext = ScriptUnit.has_extension(params.attacked_unit, "buff_system")

		if buff_ext then
			local buff_to_add = template_context.template.buff_to_add
			local stacks_to_add = template_context.template.stacks_to_add

			for j = 1, stacks_to_add do
				buff_ext:add_internally_controlled_buff(buff_to_add, t, "owner_unit", template_context.unit)
			end
		end
	end,
}
templates.broker_passive_blitz_inflicts_toxin = {
	class_name = "proc_buff",
	predicted = false,
	stacks_to_add = talent_settings.broker_passive_blitz_inflicts_toxin.stacks,
	buff_to_add = talent_settings.broker_passive_blitz_inflicts_toxin.toxin_buff,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.visual_loadout_extension = ScriptUnit.extension(template_context.unit, "visual_loadout_system")
	end,
	check_proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return false
		end

		local attacking_item = params.attacking_item

		if not attacking_item then
			return false
		end

		local equipped_item = template_data.visual_loadout_extension:item_in_slot("slot_grenade_ability")

		return equipped_item and attacking_item.name == equipped_item.name and params.attack_type == "explosion"
	end,
	proc_func = function (params, template_data, template_context, t)
		local buff_ext = ScriptUnit.has_extension(params.attacked_unit, "buff_system")

		if buff_ext then
			local stacks_to_add = template_context.template.stacks_to_add
			local buff_to_add = template_context.template.buff_to_add

			for j = 1, stacks_to_add do
				buff_ext:add_internally_controlled_buff(buff_to_add, t, "owner_unit", template_context.unit)
			end
		end
	end,
}
templates.broker_keystone_vultures_mark_on_kill = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_vultures_mark",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.combine(CheckProcFunctions.on_elite_or_special_kill, CheckProcFunctions.on_ranged_kill),
	start_func = function (template_data, template_context)
		template_data.buff_extension = ScriptUnit.extension(template_context.unit, "buff_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		template_data.buff_extension:add_internally_controlled_buff("vultures_mark", t)

		if template_context.player then
			Managers.stats:record_private("hook_broker_stack_of_vulture_keystone", template_context.player)
		end
	end,
}
templates.vultures_mark = {
	class_name = "proc_buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_vultures_mark",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	duration = talent_settings.broker_keystone_vultures_mark_on_kill.duration,
	max_stacks = talent_settings.broker_keystone_vultures_mark_on_kill.max_stacks,
	stat_buffs = {
		[stat_buffs.ranged_damage] = talent_settings.broker_keystone_vultures_mark_on_kill.ranged_damage,
		[stat_buffs.ranged_critical_strike_chance] = talent_settings.broker_keystone_vultures_mark_on_kill.crit_chance,
		[stat_buffs.movement_speed] = talent_settings.broker_keystone_vultures_mark_on_kill.movement_speed,
	},
	start_func = function (template_data, template_context)
		template_data.toughness_extension = ScriptUnit.extension(template_context.unit, "toughness_system")
		template_data.coherency_extension = ScriptUnit.extension(template_context.unit, "coherency_system")

		local talent_extension = ScriptUnit.extension(template_context.unit, "talent_system")

		if talent_extension:has_special_rule(special_rules.broker_keystone_vultures_mark_increased_duration) then
			local extra_duration = talent_settings.broker_keystone_vultures_mark_increased_duration.duration - talent_settings.broker_keystone_vultures_mark_on_kill.duration

			template_context.buff:add_duration(extra_duration)
		end
	end,
	check_proc_func = CheckProcFunctions.combine(CheckProcFunctions.at_max_stacks, CheckProcFunctions.on_elite_or_special_kill, CheckProcFunctions.on_ranged_kill),
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local coherency_extension = template_data.coherency_extension
		local units_in_coherence = coherency_extension:in_coherence_units()
		local toughness = talent_settings.broker_keystone_vultures_mark_on_kill.toughness_percent

		for coherency_unit, _ in pairs(units_in_coherence) do
			Toughness.replenish_percentage(coherency_unit, toughness)
		end
	end,
}
templates.broker_keystone_vultures_mark_aoe_stagger = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.all(CheckProcFunctions.on_ranged_hit, CheckProcFunctions.on_elite_or_special_kill),
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		local player_unit = template_context.unit
		local player_position = POSITION_LOOKUP[player_unit]
		local explosion_position = player_position + Vector3(0, 0, 0.65)
		local explosion_template = ExplosionTemplates.broker_vultures_mark_aoe_stagger

		Explosion.create_explosion(template_context.world, template_context.physics_world, explosion_position, nil, template_context.unit, explosion_template, PowerLevelSettings.default_power_level, 1, attack_types.explosion)
	end,
}
templates.broker_keystone_vultures_mark_dodge_on_ranged_crit = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	check_proc_func = CheckProcFunctions.on_crit_ranged,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("broker_vultures_mark_dodge_on_ranged_crit_dodge_buff", t)
	end,
}
templates.broker_vultures_mark_dodge_on_ranged_crit_dodge_buff = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_vultures_dodge",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	max_stacks = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	duration = talent_settings.broker_keystone_vultures_mark_dodge_on_ranged_crit.duration,
	keywords = {
		keywords.count_as_dodge_vs_melee,
		keywords.count_as_dodge_vs_ranged,
	},
}
templates.broker_keystone_chemical_dependency = {
	class_name = "proc_buff",
	predicted = true,
	sub_2_toughness_grant = talent_settings.broker_keystone_chemical_dependency.sub_2_toughness_grant,
	proc_events = {
		[proc_events.on_syringe_used] = 1,
	},
	start_func = function (template_data, template_context)
		local talent_extension = ScriptUnit.extension(template_context.unit, "talent_system")

		template_data.grant_toughness = template_context.is_server and talent_extension:has_special_rule(special_rules.broker_keystone_chemical_dependency_sub_2_toughness) and template_context.template.sub_2_toughness_grant
	end,
	proc_func = function (params, template_data, template_context, t)
		if template_data.grant_toughness then
			Toughness.replenish_percentage(template_context.unit, template_data.grant_toughness)
		end

		template_context.buff_extension:add_internally_controlled_buff("broker_keystone_chemical_dependency_stack", t)
	end,
}

local STATISTICS_UPDATE_INTERVAL = 10

local function record_broker_max_stacks_of_chemical_dependency(template_data, template_context, exited_max_stacks)
	if not template_context.is_server then
		return
	end

	if template_data.max_stacks_timestamp then
		local current_time = FixedFrame.get_latest_fixed_time()
		local time_spent_at_max_stacks = math.round(current_time - template_data.max_stacks_timestamp)

		if template_context.player and time_spent_at_max_stacks > 0 then
			Managers.stats:record_private("hook_broker_exited_max_stacks_of_chemical_dependency", template_context.player, time_spent_at_max_stacks)
		end

		template_data.max_stacks_timestamp = current_time

		if exited_max_stacks then
			template_data.max_stacks_timestamp = nil
		end
	end

	template_data.record_stats_t = FixedFrame.get_latest_fixed_time() + STATISTICS_UPDATE_INTERVAL
end

templates.broker_keystone_chemical_dependency_stack = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_chemical_dependency",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = true,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	duration = talent_settings.broker_keystone_chemical_dependency.duration,
	sub_3_duration = talent_settings.broker_keystone_chemical_dependency.sub_3_duration,
	max_stacks = talent_settings.broker_keystone_chemical_dependency.max_stacks,
	max_stacks_cap = talent_settings.broker_keystone_chemical_dependency.max_stacks,
	sub_3_max_stacks = talent_settings.broker_keystone_chemical_dependency.sub_3_max_stacks,
	sub_3_max_stacks_cap = talent_settings.broker_keystone_chemical_dependency.sub_3_max_stacks,
	stat_buffs = {
		[stat_buffs.combat_ability_cooldown_regen_modifier] = talent_settings.broker_keystone_chemical_dependency.combat_ability_cooldown_regen_modifier,
	},
	conditional_stat_buffs = {
		[stat_buffs.critical_strike_chance] = talent_settings.broker_keystone_chemical_dependency.critical_strike_chance,
		[stat_buffs.toughness_damage_taken_multiplier] = talent_settings.broker_keystone_chemical_dependency.toughness_damage_taken_multiplier,
	},
	stat_buff_multipliers = {
		[stat_buffs.critical_strike_chance] = function (template_data)
			return template_data.count_crit_chance and 1 or 0
		end,
		[stat_buffs.toughness_damage_taken_multiplier] = function (template_data, _, value)
			return template_data.count_toughness_reduction and 1 or 1 / value
		end,
	},
	conditional_stat_buffs_funcs = {
		[stat_buffs.critical_strike_chance] = function (template_data)
			return template_data.count_crit_chance
		end,
		[stat_buffs.toughness_damage_taken_multiplier] = function (template_data)
			return template_data.count_toughness_reduction
		end,
	},
	start_func = function (template_data, template_context)
		local talent_extension = ScriptUnit.extension(template_context.unit, "talent_system")

		template_data.count_crit_chance = talent_extension:has_special_rule(special_rules.broker_keystone_chemical_dependency_sub_1_crit_chance)
		template_data.count_toughness_reduction = talent_extension:has_special_rule(special_rules.broker_keystone_chemical_dependency_sub_2_toughness)

		local decrease_duration = talent_extension:has_special_rule(special_rules.broker_keystone_chemical_dependency_sub_3_duration)

		if decrease_duration then
			local template = template_context.template

			template_context.buff:add_max_stacks(template.sub_3_max_stacks - template.max_stacks)
			template_context.buff:add_max_stacks_cap(template.sub_3_max_stacks_cap - template.max_stacks_cap)
			template_context.buff:add_duration(template.sub_3_duration - template.duration)
		end

		template_data.record_stats_t = 0
	end,
	update_func = function (template_data, template_context, dt, t)
		if t > template_data.record_stats_t then
			record_broker_max_stacks_of_chemical_dependency(template_data, template_context, false)
		end
	end,
	on_remove_stack_func = function (template_data, template_context, change, new_stack_count)
		record_broker_max_stacks_of_chemical_dependency(template_data, template_context, true)
	end,
	on_reached_max_stack_func = function (template_data, template_context)
		if template_context.is_server then
			local t = FixedFrame.get_latest_fixed_time()

			template_data.max_stacks_timestamp = t
		end
	end,
	stop_func = function (template_data, template_context, extension_destroyed)
		record_broker_max_stacks_of_chemical_dependency(template_data, template_context, true)
	end,
}
templates.broker_keystone_adrenaline_junkie = {
	class_name = "proc_buff",
	predicted = false,
	regular_grant = talent_settings.broker_keystone_adrenaline_junkie.regular_grant,
	crit_grant = talent_settings.broker_keystone_adrenaline_junkie.crit_grant,
	sub_1_regular_grant = talent_settings.broker_keystone_adrenaline_junkie.sub_1_regular_grant,
	sub_1_weakspot_additional_grant = talent_settings.broker_keystone_adrenaline_junkie.sub_1_weakspot_additional_grant,
	sub_2_kill_additional_grant = talent_settings.broker_keystone_adrenaline_junkie.sub_2_kill_additional_grant,
	sub_2_kill_additional_elite_grant = talent_settings.broker_keystone_adrenaline_junkie.sub_2_kill_additional_elite_grant,
	check_proc_func = function (params, template_data, template_context, t, ...)
		if not CheckProcFunctions.on_melee_hit(params, template_data, template_context, t) then
			return false
		end

		if template_data.talent_extension:has_special_rule(special_rules.broker_keystone_adrenaline_junkie_extra_killing_blow_stacks) and not CheckProcFunctions.on_melee_kill(params, template_data, template_context, t) then
			return false
		end

		return true
	end,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.talent_extension = ScriptUnit.extension(template_context.unit, "talent_system")
	end,
	proc_func = function (params, template_data, template_context, t)
		local template = template_context.template
		local on_regular = template.regular_grant
		local stacks_to_grant = on_regular

		if template_data.talent_extension:has_special_rule(special_rules.broker_keystone_adrenaline_junkie_no_regular_stacks) then
			local sub_1_regular_grant = template.sub_1_regular_grant

			stacks_to_grant = sub_1_regular_grant

			if CheckProcFunctions.on_weakspot_hit(params, template_data, template_context, t) then
				local sub_1_weakspot_grant = template.regular_grant + template.sub_1_weakspot_additional_grant

				stacks_to_grant = sub_1_weakspot_grant
			end
		end

		if template_data.talent_extension:has_special_rule(special_rules.broker_keystone_adrenaline_junkie_extra_killing_blow_stacks) then
			stacks_to_grant = stacks_to_grant + template.sub_2_kill_additional_grant

			if CheckProcFunctions.on_elite_kill(params, template_data, template_context, t) then
				stacks_to_grant = stacks_to_grant + template.sub_2_kill_additional_elite_grant
			end
		end

		local is_crit = CheckProcFunctions.on_crit(params, template_data, template_context, t)

		if is_crit then
			stacks_to_grant = stacks_to_grant + template.crit_grant
		end

		for _ = 1, stacks_to_grant do
			local buff_extension = template_context.buff_extension

			buff_extension:add_internally_controlled_buff("broker_keystone_adrenaline_junkie_stack", t)
		end
	end,
}
templates.broker_keystone_adrenaline_junkie_stack = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_adrenaline_frenzy",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_remove_stack = true,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	duration = talent_settings.broker_keystone_adrenaline_junkie.adrenaline_duration,
	sub_4_duration = talent_settings.broker_keystone_adrenaline_junkie.sub_4_duration,
	max_stacks = talent_settings.broker_keystone_adrenaline_junkie.adrenaline_max_stacks,
	max_stacks_cap = talent_settings.broker_keystone_adrenaline_junkie.adrenaline_max_stacks,
	start_func = function (template_data, template_context)
		local talent_extension = ScriptUnit.extension(template_context.unit, "talent_system")

		if talent_extension:has_special_rule(special_rules.broker_keystone_adrenaline_junkie_stack_extra_duration) then
			local new_duration = template_context.template.sub_4_duration

			template_context.buff:add_duration(new_duration - template_context.template.duration)
		end
	end,
	on_reached_max_stack_func = function (template_data, template_context)
		local t = FixedFrame.get_latest_fixed_time()
		local buff_extension = template_context.buff_extension

		buff_extension:add_internally_controlled_buff("broker_keystone_adrenaline_junkie_proc", t)
		template_context.buff:set_refresh_duration_on_remove_stack(false)

		if template_context.player then
			Managers.stats:record_private("hook_broker_proc_max_stacks_adrenaline_keystone", template_context.player)
		end
	end,
	conditional_exit_func = function (template_data, template_context)
		return template_context.stack_count >= template_context.template.max_stacks
	end,
}
templates.broker_keystone_adrenaline_junkie_proc = {
	class_name = "buff",
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_adrenaline_frenzy",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_keystone",
	hud_priority = 1,
	predicted = false,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	duration = talent_settings.broker_keystone_adrenaline_junkie.frenzy_duration,
	sub_3_frenzy_duration = talent_settings.broker_keystone_adrenaline_junkie.sub_3_frenzy_duration,
	max_stacks = talent_settings.broker_keystone_adrenaline_junkie.frenzy_max_stacks,
	max_stacks_cap = talent_settings.broker_keystone_adrenaline_junkie.frenzy_max_stacks,
	sub_5_toughness_per_tick = talent_settings.broker_keystone_adrenaline_junkie.sub_5_toughness_per_tick,
	stat_buffs = {
		[stat_buffs.melee_attack_speed] = talent_settings.broker_keystone_adrenaline_junkie.melee_attack_speed,
		[stat_buffs.melee_damage] = talent_settings.broker_keystone_adrenaline_junkie.melee_damage,
	},
	start_func = function (template_data, template_context)
		local talent_extension = ScriptUnit.extension(template_context.unit, "talent_system")

		if talent_extension:has_special_rule(special_rules.broker_keystone_adrenaline_junkie_extra_duration) then
			local new_duration = template_context.template.sub_3_frenzy_duration

			template_context.buff:add_duration(new_duration - template_context.template.duration)
		end

		template_data.restore_toughness = template_context.is_server and talent_extension:has_special_rule(special_rules.broker_keystone_adrenaline_junkie_restore_toughness) and template_context.template.sub_5_toughness_per_tick
	end,
	update_func = function (template_data, template_context, dt, t)
		if template_data.restore_toughness then
			local next_tick = template_data.next_tick or t

			if next_tick <= t then
				template_data.next_tick = next_tick + 1

				Toughness.replenish_percentage(template_context.unit, template_data.restore_toughness)
			end
		end
	end,
}
templates.broker_ability_stimm_field_sub_3 = {
	class_name = "interval_buff",
	interval = 0.5,
	predicted = false,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local visual_loadout_extension = ScriptUnit.extension(template_context.unit, "visual_loadout_system")

		template_data.visual_loadout_extension = visual_loadout_extension
		template_data.has_syringe = PlayerUnitVisualLoadout.has_weapon_keyword_from_slot(visual_loadout_extension, "slot_pocketable_small", "syringe") or false

		local ability_extension = ScriptUnit.extension(template_context.unit, "ability_system")

		template_data.ability_extension = ability_extension
		template_data.num_ability_charges = ability_extension:remaining_ability_charges("pocketable_ability")
	end,
	interval_func = function (template_data, template_context, template)
		if not template_context.is_server then
			return
		end

		local has_syringe_before = template_data.has_syringe
		local has_syringe_now = PlayerUnitVisualLoadout.has_weapon_keyword_from_slot(template_data.visual_loadout_extension, "slot_pocketable_small", "syringe") or false

		if has_syringe_now and has_syringe_now ~= has_syringe_before then
			template_data.ability_extension:reduce_ability_cooldown_percentage("combat_ability", 1)
		end

		template_data.has_syringe = has_syringe_now

		local charges_before = template_data.num_ability_charges
		local charges_now = template_data.ability_extension:remaining_ability_charges("pocketable_ability")

		if charges_before < charges_now then
			template_data.ability_extension:reduce_ability_cooldown_percentage("combat_ability", 1)
		end

		template_data.num_ability_charges = charges_now
	end,
}
templates.broker_syringe_toughness_restore = {
	class_name = "buff",
	predicted = false,
	skip_tactical_overlay = true,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local ArchetypeTalents = require("scripts/settings/ability/archetype_talents/archetype_talents")
		local talent = ArchetypeTalents.broker[template_context.from_talent]
		local toughness_amount

		for _, format_values in pairs(talent.format_values_per_index) do
			toughness_amount = format_values.toughness_amount.value
		end

		template_data.toughness_amount = toughness_amount
		template_data.stimm_provider = template_context.buff:owner_unit()
		template_data.toughness_extension = ScriptUnit.extension(template_context.unit, "toughness_system")
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local character_state_component = template_data.character_state_component

		if character_state_component and PlayerUnitStatus.is_knocked_down(character_state_component) then
			return
		end

		if not template_data.procced then
			template_data.procced = true

			local recovered_tougness = Toughness.replenish_percentage(template_context.unit, template_data.toughness_amount, false, "broker_syringe")

			if recovered_tougness > 0 then
				Managers.stats:record_private("hook_broker_stimm_restored_tougness", template_context.player, recovered_tougness, template_context.player)
			end
		end
	end,
}
templates.broker_syringe_cooldown_on_melee_kills = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_melee_kill,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("broker_syringe_melee_cooldown_buff", t, "from_talent", template_context.from_talent)
	end,
}
templates.broker_syringe_melee_cooldown_buff = {
	class_name = "buff",
	duration = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = true,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	stat_buffs = {
		[stat_buffs.combat_ability_cooldown_regen_modifier] = 0.75,
	},
	stat_buff_multiplier = function (template_data)
		return template_data.melee_cd_regen
	end,
	start_func = function (template_data, template_context)
		local buff_params = TalentSettings.broker_stimm[template_context.from_talent].buff_data.buff_params

		template_data.melee_cd_regen = buff_params.melee_cd_regen

		template_context.buff:add_duration(buff_params.melee_cd_duration - template_context.template.duration)
	end,
}
templates.broker_syringe_cooldown_on_ranged_kills = {
	class_name = "proc_buff",
	predicted = false,
	proc_events = {
		[proc_events.on_kill] = 1,
	},
	check_proc_func = CheckProcFunctions.on_ranged_kill,
	proc_func = function (params, template_data, template_context, t)
		template_context.buff_extension:add_internally_controlled_buff("broker_syringe_ranged_cooldown_buff", t, "from_talent", template_context.from_talent)
	end,
}
templates.broker_syringe_ranged_cooldown_buff = {
	class_name = "buff",
	duration = 1,
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = true,
	refresh_duration_on_stack = true,
	skip_tactical_overlay = true,
	stat_buffs = {
		[stat_buffs.combat_ability_cooldown_regen_modifier] = 0.75,
	},
	stat_buff_multiplier = function (template_data)
		return template_data.ranged_cd_regen
	end,
	start_func = function (template_data, template_context)
		local buff_params = TalentSettings.broker_stimm[template_context.from_talent].buff_data.buff_params

		template_data.ranged_cd_regen = buff_params.ranged_cd_regen

		template_context.buff:add_duration(buff_params.ranged_cd_duration - template_context.template.duration)
	end,
}
templates.broker_syringe_health_restore = {
	class_name = "buff",
	predicted = false,
	skip_tactical_overlay = true,
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		template_data.stimm_provider = template_context.buff:owner_unit()
		template_data.health_extension = ScriptUnit.extension(template_context.unit, "health_system")
	end,
	update_func = function (template_data, template_context, dt, t)
		if not template_context.is_server then
			return
		end

		local character_state_component = template_data.character_state_component

		if character_state_component and PlayerUnitStatus.is_knocked_down(character_state_component) then
			return
		end

		if not template_data.procced then
			template_data.procced = true

			local amount = stimm_talent_settings.broker_stimm_med_vitality.buff_data.buff_params.heal_amount

			template_data.health_extension:add_heal(amount * template_data.health_extension:max_health(), DamageSettings.heal_types.syringe)
		end
	end,
}

local TEMP_BUFF_APPLY_ARR = {}
local TEMP_STIMM_STAT_INCREASES = {}

templates.syringe_broker_buff = {
	class_name = "buff",
	duration = 15,
	hud_icon = "content/ui/textures/icons/buffs/hud/broker/broker_stimm_buff",
	hud_icon_gradient_map = "content/ui/textures/color_ramps/talent_no_color",
	hud_priority = 1,
	predicted = true,
	skip_tactical_overlay = true,
	unique_buff_id = "syringe_stimm",
	unique_buff_priority = 1,
	stat_buffs = {
		[stat_buffs.fov_multiplier] = 0.985,
	},
	stat_buff_multipliers = {},
	keywords = {
		keywords.syringe,
		keywords.syringe_broker,
	},
	single_application_buff_overrides = {},
	start_func = function (template_data, template_context)
		template_data.health_extension = ScriptUnit.extension(template_context.unit, "health_system")

		local fx_extension = ScriptUnit.extension(template_context.unit, "fx_system")
		local particle_name = "content/fx/particles/pocketables/syringe_power_3p"

		fx_extension:spawn_unit_particles(particle_name, "hips", true, "destroy", nil, nil, nil, true)

		local additional_args = template_context.buff:additional_arguments()

		template_data.skip_talent = additional_args.skip_talent
		template_data.stimm_provider = template_context.buff:owner_unit()
		template_data.talent_tiers = {}

		local single_application_buff_overrides = template_context.template.single_application_buff_overrides

		table.clear(TEMP_BUFF_APPLY_ARR)

		local talent_extension = ScriptUnit.has_extension(template_data.stimm_provider, "talent_system")

		for talent_name, data in pairs(stimm_talent_settings) do
			local talent_tier = not template_data.skip_talent and talent_extension and talent_extension:buff_template_tier(talent_name) or 0

			template_data.talent_tiers[talent_name] = talent_tier

			local buff_data = data.buff_data

			if not template_data.skip_talent and buff_data.buff_target and not single_application_buff_overrides[talent_name] then
				local template = templates[buff_data.buff_target]

				if not template.predicted or not template_context.added_during_server_correction then
					TEMP_BUFF_APPLY_ARR[#TEMP_BUFF_APPLY_ARR + 1] = talent_name
				end
			end
		end

		table.sort(TEMP_BUFF_APPLY_ARR)

		local local_indices, component_indices = {}, {}

		for buff_i = 1, #TEMP_BUFF_APPLY_ARR do
			local talent_name = TEMP_BUFF_APPLY_ARR[buff_i]
			local data = stimm_talent_settings[talent_name]
			local buff_data = data.buff_data
			local talent_tier = template_data.talent_tiers[talent_name]
			local t = FixedFrame.get_latest_fixed_time()

			for _ = 1, talent_tier do
				local _, local_index, component_index = template_context.buff_extension:add_externally_controlled_buff(buff_data.buff_target, t, "owner_unit", template_data.stimm_provider, "from_talent", talent_name)

				local_indices[#local_indices + 1] = local_index
				component_indices[#component_indices + 1] = component_index
			end
		end

		template_data.local_indices, template_data.component_indices = local_indices, component_indices

		local duration = template_context.template.duration

		if duration then
			local duration_increase = template_context.buff_extension:stat_buffs().syringe_duration

			if duration_increase ~= 0 then
				template_context.buff:add_duration(duration_increase)
			end
		end

		if template_context.is_server then
			table.clear(TEMP_STIMM_STAT_INCREASES)

			local stat_buff_multipliers = template_context.template.stat_buff_multipliers

			for stat_name, stat_value in pairs(stat_buff_multipliers) do
				TEMP_STIMM_STAT_INCREASES[stat_name] = stat_buff_multipliers[stat_name](template_data, template_context)
			end

			Managers.stats:record_private("hook_broker_stimm_used", template_context.player, TEMP_STIMM_STAT_INCREASES, template_context.player)
		end
	end,
	stop_func = function (template_data, template_context, extension_destroyed)
		if extension_destroyed then
			return
		end

		local local_indices, component_indices = template_data.local_indices, template_data.component_indices

		for i = 1, #local_indices do
			template_context.buff_extension:remove_externally_controlled_buff(local_indices[i], component_indices[i])
		end
	end,
}

local stat_buff_types = BuffSettings.stat_buff_types

for talent_name, data in pairs(stimm_talent_settings) do
	local syringe_stat_buffs = templates.syringe_broker_buff.stat_buffs
	local multiplier_funcs = templates.syringe_broker_buff.stat_buff_multipliers
	local buff_data = data.buff_data

	if buff_data.stat_buffs then
		for stat_name, stat_value in pairs(buff_data.stat_buffs) do
			syringe_stat_buffs[stat_name] = 1

			local existing_func = multiplier_funcs[stat_name]

			multiplier_funcs[stat_name] = function (template_data, template_context, ...)
				local value
				local stat_buff_type = stat_buff_types[stat_name]

				if stat_buff_type == "multiplicative_multiplier" then
					value = stat_value^template_data.talent_tiers[talent_name]

					if existing_func then
						value = value * existing_func(template_data, template_context, ...)
					end
				else
					value = stat_value * template_data.talent_tiers[talent_name]

					if existing_func then
						value = value + existing_func(template_data, template_context, ...)
					end
				end

				return value
			end
		end
	end

	templates[talent_name] = {
		class_name = "buff",
		predicted = false,
		skip_tactical_overlay = true,
	}
end

local target_num_enemies_killed_from_grenade = 3

templates.broker_flash_grenade_cluster_stagger_tracking_buff = {
	class_name = "proc_buff",
	max_stacks = 1,
	max_stacks_cap = 1,
	predicted = false,
	proc_events = {
		[proc_events.on_hit] = 1,
	},
	start_func = function (template_data, template_context)
		template_data.last_grenade_kill_t = 0
		template_data.num_enemies_killed_in_cluster = 0
		template_data.recorded_cluster = false
	end,
	check_proc_func = function (params, template_data, template_context, t)
		local damage_profile = params.damage_profile
		local damage_profile_name = damage_profile and damage_profile.name
		local stagger_result = params.stagger_result
		local is_flash_grenade_stagger = stagger_result == stagger_results.stagger and damage_profile_name and (damage_profile_name == "broker_flash_grenade_impact" or damage_profile_name == "broker_flash_grenade_close" or damage_profile_name == "broker_flash_grenade")

		return is_flash_grenade_stagger
	end,
	proc_func = function (params, template_data, template_context, t)
		if not template_context.is_server then
			return
		end

		if t - template_data.last_grenade_kill_t > 0.25 then
			template_data.num_enemies_killed_in_cluster = 0
			template_data.recorded_cluster = false
		end

		template_data.last_grenade_kill_t = t
		template_data.num_enemies_killed_in_cluster = template_data.num_enemies_killed_in_cluster + 1

		if not template_data.recorded_cluster and template_data.num_enemies_killed_in_cluster >= target_num_enemies_killed_from_grenade then
			Managers.stats:record_private("hook_broker_cluster_staggered_by_flash_grenade", template_context.player)

			template_data.recorded_cluster = true
		end
	end,
}

return templates
