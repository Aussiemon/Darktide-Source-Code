local AttackSettings = require("scripts/settings/damage/attack_settings")
local Action = require("scripts/utilities/weapon/action")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local Stamina = require("scripts/utilities/attack/stamina")
local Stun = require("scripts/utilities/attack/stun")
local attack_types = AttackSettings.attack_types
local stat_buff_types = BuffSettings.stat_buffs
local buff_keywords = BuffSettings.keywords
local DEFAULT_BLOCK_BREAK_DISORIENTATION_TYPE = "block_broken"
local _block_buff_modifier = nil
local Block = {}
local auto_block_interactions = {
	revive = true,
	rescue = true
}
local default_block_types = {
	[attack_types.melee] = true
}

Block.is_blocking = function (unit, attack_type, weapon_template, is_server)
	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

	if not unit_data_extension then
		return false
	end

	local breed = unit_data_extension:breed()

	if not Breed.is_player(breed) then
		return false
	end

	local block_component = unit_data_extension:read_component("block")
	local is_blocking = block_component.is_blocking

	if is_server and not is_blocking then
		local interaction_component = unit_data_extension:read_component("interaction")
		local is_interacting = interaction_component.state == InteractionSettings.states.is_interacting

		if is_interacting then
			local interaction_type = interaction_component.type
			local should_block = interaction_type and auto_block_interactions[interaction_type]

			if should_block then
				is_blocking = true
			end
		end
	end

	if not is_blocking then
		return false
	end

	local weapon_action_component = unit_data_extension:read_component("weapon_action")
	local _, action_setting = Action.current_action(weapon_action_component, weapon_template)
	local block_types = action_setting and action_setting.block_attack_types or default_block_types
	local can_block_type = block_types[attack_type]

	if attack_type == attack_types.ranged then
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
		local can_block_ranged_keyword = buff_extension and buff_extension:has_keyword(buff_keywords.can_block_ranged)

		if can_block_ranged_keyword then
			can_block_type = true
		end
	end

	return can_block_type
end

Block.attack_is_blockable = function (damage_profile)
	return not damage_profile.unblockable
end

Block.attempt_block_break = function (unit, attacking_unit, hit_world_position, attack_type, attack_direction, weapon_template, damage_profile)
	local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
	local weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	local stamina_template = weapon_extension:stamina_template()
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	local block_cost = math.huge

	if stamina_template then
		local block_buff_modifier = _block_buff_modifier(buff_extension, attack_type)
		local block_damage_modifier = damage_profile.block_cost_multiplier or 1
		local block_modifier = block_buff_modifier * block_damage_modifier

		if attack_type == attack_types.melee and stamina_template.block_cost_melee then
			block_cost = stamina_template.block_cost_melee * block_modifier
		elseif attack_type == attack_types.ranged and stamina_template.block_cost_ranged then
			block_cost = stamina_template.block_cost_ranged * block_modifier
		else
			block_cost = stamina_template.block_cost_default * block_modifier
		end
	end

	local weapon_action_component = unit_data_extension:read_component("weapon_action")
	local _, action_setting = Action.current_action(weapon_action_component, weapon_template)

	if action_setting and action_setting.parry_block then
		block_cost = math.clamp(block_cost, 0, 2)
	end

	if buff_extension then
		local use_warp_charge = buff_extension:has_keyword(buff_keywords.block_gives_warp_charge)

		if use_warp_charge and block_cost > 0 then
			local stamina_write_component = unit_data_extension:write_component("stamina")
			local warp_charge_component = unit_data_extension:write_component("warp_charge")
			local specialization = unit_data_extension:specialization()
			local specialization_stamina_template = specialization.stamina
			local _, max_stamina = Stamina.current_and_max_value(unit, stamina_write_component, specialization_stamina_template)
			local current_warp_charge = warp_charge_component.current_percentage

			if current_warp_charge < 0.9 then
				local stat_buffs = buff_extension:stat_buffs()
				local warp_charge_efficiency_multiplier = stat_buffs.warp_charge_block_cost
				local percentage_of_stamina = block_cost / max_stamina
				local sum = current_warp_charge + percentage_of_stamina * warp_charge_efficiency_multiplier
				local new_warp_charge_percentage = math.min(sum, 0.9)
				local excess = sum - 0.9

				if excess > 0 then
					block_cost = excess * 1 / warp_charge_efficiency_multiplier * max_stamina
				else
					block_cost = 0
				end

				warp_charge_component.current_percentage = new_warp_charge_percentage
			end
		end
	end

	local t = Managers.state.extension:latest_fixed_t()
	local _, stamina_depleted = Stamina.drain(unit, block_cost, t)
	local block_broken = stamina_depleted

	if block_broken then
		local weapon_disorientation_type = stamina_template and stamina_template.block_break_disorientation_type or DEFAULT_BLOCK_BREAK_DISORIENTATION_TYPE
		local damage_disorientation_type = damage_profile.block_broken_disorientation_type
		local disorientation_type = damage_disorientation_type or weapon_disorientation_type

		Stun.apply(unit, disorientation_type, attack_direction, weapon_template, true, false)
	end

	local unit_id = Managers.state.unit_spawner:game_object_id(unit)
	local attacking_unit_id = Managers.state.unit_spawner:game_object_id(attacking_unit)
	local weapon_template_id = NetworkLookup.weapon_templates[weapon_template.name]

	Block.player_blocked_attack(unit, attacking_unit, hit_world_position, block_broken, weapon_template)
	Managers.state.game_session:send_rpc_clients("rpc_player_blocked_attack", unit_id, attacking_unit_id, hit_world_position, block_broken, weapon_template_id)

	return block_broken
end

Block.player_blocked_attack = function (blocking_unit, attacking_unit, hit_world_position, block_broken, weapon_template)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(blocking_unit)

	if not player then
		return
	end

	local weapon_extension = ScriptUnit.has_extension(blocking_unit, "weapon_system")

	if weapon_extension then
		weapon_extension:blocked_attack(attacking_unit, hit_world_position, block_broken, weapon_template)
	end
end

function _block_buff_modifier(buff_extension, attack_type)
	if not buff_extension then
		return 1
	end

	local stat_buffs = buff_extension:stat_buffs()
	local block_cost_multiplier = stat_buffs[stat_buff_types.block_cost_multiplier] or 1
	local block_cost_modifier = stat_buffs[stat_buff_types.block_cost_modifier] or 1
	local block_cost_buff_modifier = block_cost_multiplier * block_cost_modifier
	local is_ranged = attack_type == attack_types.ranged
	local ranged_block_cost_multipier = is_ranged and stat_buffs[stat_buff_types.block_cost_ranged_multiplier] or 1
	local ranged_block_cost_modifier = is_ranged and stat_buffs[stat_buff_types.block_cost_ranged_modifier] or 1
	local ranged_block_cost_buff_modifier = ranged_block_cost_multipier * ranged_block_cost_modifier

	return block_cost_buff_modifier * ranged_block_cost_buff_modifier
end

return Block
