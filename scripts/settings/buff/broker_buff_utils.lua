-- chunkname: @scripts/settings/buff/broker_buff_utils.lua

local TalentSettings = require("scripts/settings/talent/talent_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local talent_settings = TalentSettings.broker
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local BrokerBuffUtils = {}

BrokerBuffUtils.populate_stimm_field_syringe_buff_variants = function (buff_templates)
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

BrokerBuffUtils.bespoke_needlepistol_close_range_kill_start = function (template_data, template_context)
	template_data.tagged_enemies = {}
	template_data.untagged_enemies = {}

	local unit_data_extension = ScriptUnit.has_extension(template_context.unit, "unit_data_system")

	template_data.inventory = unit_data_extension:read_component("inventory")
end

local GRACE_FRAMES = 1

BrokerBuffUtils.bespoke_needlepistol_close_range_kill_update = function (template_data, template_context, dt, t)
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

BrokerBuffUtils.bespoke_needlepistol_close_range_kill_check_proc_hit = function (params, template_data, template_context, t)
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

BrokerBuffUtils.bespoke_needle_pistol_close_range_kill_check_proc_minion_death = function (params, template_data, template_context, t)
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

BrokerBuffUtils.bespoke_needle_pistol_close_range_kill_proc_hit = function (params, template_data, template_context, t)
	local frame = FixedFrame.to_fixed_frame(t)

	template_data.tagged_enemies[params.attacked_unit] = frame
end

BrokerBuffUtils.bespoke_needle_pistol_close_range_kill_proc_on_minion_death = function (params, template_data, template_context, t)
	if params.dying_unit then
		template_data.tagged_enemies[params.dying_unit] = nil
	end
end

return BrokerBuffUtils
