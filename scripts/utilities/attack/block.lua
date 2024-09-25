-- chunkname: @scripts/utilities/attack/block.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Action = require("scripts/utilities/weapon/action")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local Stamina = require("scripts/utilities/attack/stamina")
local Stun = require("scripts/utilities/attack/stun")
local attack_types = AttackSettings.attack_types
local proc_events = BuffSettings.proc_events
local stat_buff_types = BuffSettings.stat_buffs
local buff_keywords = BuffSettings.keywords
local DEFAULT_BLOCK_BREAK_DISORIENTATION_TYPE = "block_broken"
local BLOCK_ANGLE_DISTANCE_SQUARED_EPSILON = 0.010000000000000002
local _block_buff_modifier, _calculate_block_angle, _get_block_angles, _get_block_cost
local Block = {}
local auto_block_interactions = {
	pull_up = true,
	remove_net = true,
	rescue = true,
	revive = true,
}
local default_block_types = {
	[attack_types.melee] = true,
}
local default_block_angles = {
	inner = 0.33 * math.pi,
	outer = math.pi,
}

Block.is_blocking = function (target_unit, attacking_unit, attack_type, weapon_template, is_server)
	local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")

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
				local archetype = unit_data_extension:archetype()
				local base_stamina_template = archetype.stamina
				local stamina_write_component = unit_data_extension:write_component("stamina")
				local current_stamina = Stamina.current_and_max_value(target_unit, stamina_write_component, base_stamina_template)

				if current_stamina > 0 then
					is_blocking = true
				end
			end
		end
	end

	if not is_blocking then
		return false
	end

	local weapon_action_component = unit_data_extension:read_component("weapon_action")
	local _, action_setting = Action.current_action(weapon_action_component, weapon_template)
	local block_types = action_setting and action_setting.block_attack_types or default_block_types
	local can_block = block_types[attack_type]

	if attack_type == attack_types.ranged then
		local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
		local can_block_ranged_keyword = buff_extension and buff_extension:has_keyword(buff_keywords.can_block_ranged)

		if can_block_ranged_keyword then
			can_block = true
		end
	end

	if can_block then
		local weapon_extension = ScriptUnit.has_extension(target_unit, "weapon_system")
		local stamina_template = weapon_extension and weapon_extension:stamina_template()
		local block_angles = _get_block_angles(weapon_template, attack_type)
		local block_angle = _calculate_block_angle(target_unit, attacking_unit, unit_data_extension)
		local is_within_inner_angle = block_angles.inner and block_angle <= block_angles.inner
		local is_within_outer_angle = block_angles.outer and block_angle <= block_angles.outer
		local has_block_cost = not not _get_block_cost(attack_type, stamina_template, is_within_inner_angle)

		can_block = (is_within_inner_angle or is_within_outer_angle) and has_block_cost
	end

	return can_block
end

Block.attack_is_blockable = function (damage_profile, optional_target_unit, optional_weapon_template)
	if not damage_profile.unblockable then
		return true
	end

	if optional_weapon_template then
		local unit_data_extension = ScriptUnit.extension(optional_target_unit, "unit_data_system")
		local weapon_action_component = unit_data_extension:read_component("weapon_action")
		local _, action_setting = Action.current_action(weapon_action_component, optional_weapon_template)
		local block_unblockable = action_setting and action_setting.block_unblockable
		local block_goes_brrr = action_setting and action_setting.block_goes_brrr or action_setting and action_setting.parry_block

		return block_unblockable or block_goes_brrr
	else
		return false
	end
end

Block.attempt_block_break = function (target_unit, attacking_unit, hit_world_position, attack_type, attack_direction, weapon_template, damage_profile)
	local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local weapon_extension = ScriptUnit.extension(target_unit, "weapon_system")
	local stamina_template = weapon_extension:stamina_template()
	local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
	local block_cost = math.huge

	if stamina_template then
		local block_buff_modifier = _block_buff_modifier(buff_extension, attack_type)
		local block_damage_modifier = damage_profile.block_cost_multiplier or 1
		local block_modifier = block_buff_modifier * block_damage_modifier
		local block_angles = _get_block_angles(weapon_template, attack_type)
		local block_angle = _calculate_block_angle(target_unit, attacking_unit, unit_data_extension)
		local is_within_inner_angle = block_angles.inner and block_angle <= block_angles.inner

		block_cost = _get_block_cost(attack_type, stamina_template, is_within_inner_angle) * block_modifier
	end

	local weapon_action_component = unit_data_extension:read_component("weapon_action")
	local _, action_setting = Action.current_action(weapon_action_component, weapon_template)
	local block_component = unit_data_extension:read_component("block")
	local is_perfect_block = block_component.is_perfect_blocking

	if action_setting and action_setting.parry_block and is_perfect_block then
		local no_block_cost = is_perfect_block and buff_extension:has_keyword(buff_keywords.no_parry_block_cost)

		block_cost = no_block_cost and 0 or math.clamp(block_cost, 0, 2)
	end

	if action_setting and action_setting.block_goes_brrr then
		block_cost = 0
	end

	if buff_extension then
		local use_warp_charge = buff_extension:has_keyword(buff_keywords.block_gives_warp_charge)

		if use_warp_charge and block_cost > 0 then
			local stamina_write_component = unit_data_extension:write_component("stamina")
			local warp_charge_component = unit_data_extension:write_component("warp_charge")
			local archetype = unit_data_extension:archetype()
			local base_stamina_template = archetype.stamina
			local _, max_stamina = Stamina.current_and_max_value(target_unit, stamina_write_component, base_stamina_template)
			local current_warp_charge = warp_charge_component.current_percentage

			if current_warp_charge < 0.97 then
				local stat_buffs = buff_extension:stat_buffs()
				local warp_charge_efficiency_multiplier = stat_buffs.warp_charge_block_cost
				local warp_charge_amount_multiplier = stat_buffs.warp_charge_amount or 1
				local percentage_of_stamina = block_cost / max_stamina
				local sum = current_warp_charge + percentage_of_stamina * warp_charge_efficiency_multiplier * warp_charge_amount_multiplier
				local new_warp_charge_percentage = math.min(sum, 0.97)
				local excess = sum - 0.97

				if excess > 0 then
					block_cost = excess * (1 / warp_charge_efficiency_multiplier) * max_stamina
				else
					block_cost = 0
				end

				local t = Managers.state.extension:latest_fixed_t()

				warp_charge_component.last_charge_at_t = t
				warp_charge_component.current_percentage = new_warp_charge_percentage

				local percentage_change = current_warp_charge - new_warp_charge_percentage
				local param_table = buff_extension:request_proc_event_param_table()

				if param_table then
					param_table.percentage_change = percentage_change

					buff_extension:add_proc_event(proc_events.on_warp_charge_changed, param_table)
				end
			end
		end
	end

	local t = Managers.state.extension:latest_fixed_t()
	local _, stamina_depleted = Stamina.drain(target_unit, block_cost, t)
	local block_broken = stamina_depleted and block_cost > 0

	if block_broken then
		local weapon_disorientation_type = stamina_template and stamina_template.block_break_disorientation_type or DEFAULT_BLOCK_BREAK_DISORIENTATION_TYPE
		local damage_disorientation_type = damage_profile.block_broken_disorientation_type
		local disorientation_type = damage_disorientation_type or weapon_disorientation_type

		Stun.apply(target_unit, disorientation_type, attack_direction, weapon_template, true, false)
	end

	local unit_id = Managers.state.unit_spawner:game_object_id(target_unit)
	local attacking_unit_id = Managers.state.unit_spawner:game_object_id(attacking_unit)
	local weapon_template_id = NetworkLookup.weapon_templates[weapon_template.name]
	local attack_type_id = NetworkLookup.attack_types[attack_type]

	Block.player_blocked_attack(target_unit, attacking_unit, hit_world_position, block_broken, weapon_template, attack_type, block_cost, is_perfect_block)
	Managers.state.game_session:send_rpc_clients("rpc_player_blocked_attack", unit_id, attacking_unit_id, hit_world_position, block_broken, weapon_template_id, attack_type_id)

	return block_broken
end

Block.player_blocked_attack = function (target_unit, attacking_unit, hit_world_position, block_broken, weapon_template, attack_type, block_cost, is_perfect_block)
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local player = player_unit_spawn_manager:owner(target_unit)

	if not player then
		return
	end

	local weapon_extension = ScriptUnit.has_extension(target_unit, "weapon_system")

	if weapon_extension then
		weapon_extension:blocked_attack(attacking_unit, hit_world_position, block_broken, weapon_template, attack_type, block_cost, is_perfect_block)
	end
end

local PERFECT_BLOCK_WINDOW = 0.3

Block.start_block_action = function (t, block_component)
	block_component.is_blocking = true
	block_component.has_blocked = false
	block_component.is_perfect_blocking = true

	return t + PERFECT_BLOCK_WINDOW
end

Block.update_perfect_blocking = function (t, perfect_block_ends_at_t, block_component)
	if t > (perfect_block_ends_at_t or 0) and block_component.is_perfect_blocking then
		block_component.is_perfect_blocking = false
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

function _get_block_cost(attack_type, stamina_template, is_inner)
	if not stamina_template then
		return nil
	end

	local block_cost_group

	if attack_type == attack_types.melee and stamina_template.block_cost_melee then
		block_cost_group = stamina_template.block_cost_melee
	elseif attack_type == attack_types.ranged and stamina_template.block_cost_ranged then
		block_cost_group = stamina_template.block_cost_ranged
	else
		block_cost_group = stamina_template.block_cost_default
	end

	if not block_cost_group then
		return nil
	end

	return is_inner and block_cost_group.inner or block_cost_group.outer
end

function _get_block_angles(weapon_template, attack_type)
	local weapon_block_angles = weapon_template.block_angles
	local weapon_default_block_angles = weapon_block_angles and weapon_block_angles.default
	local weapon_actack_type_block_angles = weapon_block_angles and weapon_block_angles[attack_type]

	return weapon_actack_type_block_angles or weapon_default_block_angles or default_block_angles
end

function _calculate_block_angle(target_unit, attacking_unit, target_unit_data_extension)
	if not attacking_unit then
		return 0
	end

	local target_position = POSITION_LOOKUP[target_unit]
	local attacking_position = POSITION_LOOKUP[attacking_unit]
	local x = attacking_position.x - target_position.x
	local y = attacking_position.y - target_position.y
	local distance_squared = x * x + y * y

	if distance_squared < BLOCK_ANGLE_DISTANCE_SQUARED_EPSILON then
		return 0
	end

	local target_forward_flat_normalized

	if target_unit_data_extension then
		local first_person_component = target_unit_data_extension:read_component("first_person")
		local first_person_rotation = first_person_component.rotation
		local right = Quaternion.right(first_person_rotation)

		target_forward_flat_normalized = Vector3.normalize(Vector3.cross(right, Vector3.down()))
	else
		local target_rotation = Unit.world_rotation(target_unit, 1)
		local right = Quaternion.right(target_rotation)

		target_forward_flat_normalized = Vector3.normalize(Vector3.cross(right, Vector3.down()))
	end

	local to_target = attacking_position - target_position
	local to_target_flat_normalized = Vector3.normalize(Vector3.flat(to_target))
	local angle = Vector3.angle(to_target_flat_normalized, target_forward_flat_normalized)

	return angle
end

return Block
