-- chunkname: @scripts/settings/buff/buff_utils.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Attack = require("scripts/utilities/attack/attack")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local armor_types = ArmorSettings.types
local BuffUtils = {}

BuffUtils.instakill_with_buff = function (attacked_unit, attacking_unit, damage_type)
	if not HEALTH_ALIVE[attacked_unit] then
		return true
	end

	local unit_data = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
	local target_breed = unit_data and unit_data:breed()

	if target_breed then
		local is_boss = target_breed.is_boss
		local is_super_armored = target_breed.armor_type == armor_types.super_armor
		local is_resistant = target_breed.armor_type == armor_types.resistant
		local ignore_instakill = target_breed.ignore_instakill

		if is_boss or is_super_armored or is_resistant or ignore_instakill then
			return false
		end
	end

	Attack.execute(attacked_unit, DamageProfileTemplates.buff_instakill, "attacking_unit", attacking_unit, "damage_type", damage_type, "instakill", true)

	return true
end

local DEFAULT_NUMBER_OF_HITS_PER_STACK = 1

BuffUtils.add_debuff_on_hit_start = function (template_data, template_context)
	local template = template_context.template
	local target_buff_data = template.target_buff_data
	local template_override_data = template_context.template_override_data
	local override_target_buff_data = template_override_data.target_buff_data

	template_data.internal_buff_name = override_target_buff_data and override_target_buff_data.internal_buff_name or target_buff_data.internal_buff_name
	template_data.num_stacks_on_proc = override_target_buff_data and override_target_buff_data.num_stacks_on_proc or target_buff_data.num_stacks_on_proc
	template_data.max_stacks = override_target_buff_data and override_target_buff_data.max_stacks or target_buff_data.max_stacks
end

BuffUtils.add_proc_debuff = function (t, params, template_data, template_context)
	local attacked_unit = params.attacked_unit

	if not HEALTH_ALIVE[attacked_unit] then
		return
	end

	local attacked_unit_buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")

	if attacked_unit_buff_extension then
		local internal_buff_name = template_data.internal_buff_name
		local num_stacks_on_proc_func = template_context.template.num_stacks_on_proc_func
		local num_stacks_on_proc = num_stacks_on_proc_func and num_stacks_on_proc_func(t, params, template_data, template_context) or template_data.num_stacks_on_proc
		local max_stacks = template_data.max_stacks
		local current_stacks = attacked_unit_buff_extension:current_stacks(internal_buff_name)
		local stacks_to_add = math.min(num_stacks_on_proc, math.max(max_stacks - current_stacks, 0))

		if stacks_to_add == 0 and current_stacks <= max_stacks then
			attacked_unit_buff_extension:refresh_duration_of_stacking_buff(internal_buff_name, t)
		else
			local owner_unit = template_context.owner_unit
			local source_item = template_context.source_item

			attacked_unit_buff_extension:add_internally_controlled_buff_with_stacks(internal_buff_name, stacks_to_add, t, "owner_unit", owner_unit, "source_item", source_item)
		end
	end
end

BuffUtils.add_debuff_on_hit_proc = function (params, template_data, template_context, t)
	local allow_weapon_special = template_context.template.target_buff_data.allow_weapon_special
	local is_weapon_special = params.weapon_special

	if is_weapon_special and allow_weapon_special ~= nil and not allow_weapon_special then
		return
	end

	BuffUtils.add_proc_debuff(t, params, template_data, template_context)
end

BuffUtils.consecutive_hits_proc_func = function (params, template_data, template_context, t)
	if params.target_number > 1 then
		return
	end

	if not template_data.number_of_hits then
		template_data.number_of_hits = 0
	else
		local template = template_context.template
		local max_stacks = template.child_max_stacks or 5
		local number_of_hits = template_data.number_of_hits + 1

		template_data.number_of_hits = number_of_hits

		if template_data.number_of_hits > 1 then
			local override = template_context.template_override_data
			local number_of_hits_per_stack = override and override.number_of_hits_per_stack or template.number_of_hits_per_stack or DEFAULT_NUMBER_OF_HITS_PER_STACK

			template_data.target_number_of_stacks = math.clamp(math.floor((number_of_hits - 1) / number_of_hits_per_stack), 0, max_stacks)
			template_data.last_hit_time = t
		end
	end
end

BuffUtils.consecutive_hits_same_target_proc_func = function (params, template_data, template_context, t)
	if template_data.attacked_unit ~= params.attacked_unit then
		template_data.attacked_unit = params.attacked_unit
		template_data.number_of_hits = 0
		template_data.target_number_of_stacks = 0
	else
		local max_stacks = 5
		local number_of_hits = template_data.number_of_hits + 1

		template_data.number_of_hits = number_of_hits

		local template = template_context.template
		local override = template_context.template_override_data
		local number_of_hits_per_stack = override and override.number_of_hits_per_stack or template.number_of_hits_per_stack or DEFAULT_NUMBER_OF_HITS_PER_STACK

		template_data.target_number_of_stacks = math.clamp(math.floor(number_of_hits / number_of_hits_per_stack), 0, max_stacks)
		template_data.last_hit_time = t
	end
end

BuffUtils.populate_stimm_field_syringe_buff_variants = function (buff_templates)
	local talent_settings = TalentSettings.broker
	local buffs_to_add = {}

	for name, template in pairs(buff_templates) do
		if template.keywords and table.contains(template.keywords, "syringe") then
			local buff = table.clone(template)
			local variant_name = name .. "_stimm_field"

			buff.name = variant_name
			buff.duration = nil
			buff.unique_buff_id = nil
			buff.predicted = false
			buff.keywords = {
				"syringe",
				"syringe_broker",
			}
			buffs_to_add[variant_name] = buff
		end
	end

	table.merge(buff_templates, buffs_to_add)

	buff_templates.syringe_heal_corruption_buff_stimm_field.single_application = true
	buff_templates.syringe_broker_buff_stimm_field.single_application_buff_overrides = table.set({
		"broker_stimm_durability_5b",
		"broker_stimm_durability_4",
	})

	local start_func_super = buff_templates.syringe_broker_buff_stimm_field.start_func

	buff_templates.syringe_broker_buff_stimm_field.start_func = function (template_data, template_context)
		start_func_super(template_data, template_context)

		local owner_player = Managers.state.player_unit_spawn:owner(template_data.stimm_provider)

		if owner_player then
			template_data.stat_peer_id = owner_player:peer_id()
			template_data.stat_local_player_id = owner_player:local_player_id()
		end

		template_data.enter_time = FixedFrame.get_latest_fixed_time()
	end

	local stop_func_super = buff_templates.syringe_broker_buff_stimm_field.stop_func

	buff_templates.syringe_broker_buff_stimm_field.stop_func = function (template_data, template_context, extension_destroyed)
		stop_func_super(template_data, template_context, extension_destroyed)

		local peer_id, local_player_id = template_data.stat_peer_id, template_data.stat_local_player_id

		if peer_id and local_player_id then
			local owner_player = Managers.player:player(peer_id, local_player_id)

			if owner_player then
				template_data.start_t = FixedFrame.get_latest_fixed_time()

				local buffing_start_time = template_data.enter_time

				if not buffing_start_time then
					return
				end

				local current_time = FixedFrame.get_latest_fixed_time()
				local time_buffed = math.round(current_time - buffing_start_time)

				Managers.stats:record_private("hook_broker_time_ally_buffed_by_stimm_field", owner_player, time_buffed)
			end
		end
	end

	buff_templates.syringe_broker_buff_stimm_field.class_name = "interval_buff"
	buff_templates.syringe_broker_buff_stimm_field.hud_icon = talent_settings.combat_ability.stimm_field.hud_icon
	buff_templates.syringe_broker_buff_stimm_field.hud_icon_gradient_map = talent_settings.combat_ability.stimm_field.hud_icon_gradient_map
	buff_templates.syringe_broker_buff_stimm_field.hud_priority = talent_settings.combat_ability.stimm_field.hud_priority
	buff_templates.syringe_broker_buff_stimm_field.skip_tactical_overlay = talent_settings.combat_ability.stimm_field.skip_tactical_overlay
	buff_templates.syringe_broker_buff_stimm_field.stat_buffs.corruption_taken_multiplier = 0
	buff_templates.syringe_broker_buff_stimm_field.interval = talent_settings.combat_ability.stimm_field.interval

	buff_templates.syringe_broker_buff_stimm_field.interval_func = function (template_data, template_context, template)
		if not template_context.is_server then
			return
		end

		local corruption_heal_amount = talent_settings.combat_ability.stimm_field.corruption_heal_amount

		template_data.health_extension:reduce_permanent_damage(corruption_heal_amount)
	end
end

return BuffUtils
