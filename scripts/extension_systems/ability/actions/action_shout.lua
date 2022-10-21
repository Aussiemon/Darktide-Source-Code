require("scripts/extension_systems/weapon/actions/action_ability_base")

local Attack = require("scripts/utilities/attack/attack")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Health = require("scripts/utilities/health")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerVoiceGrunts = require("scripts/utilities/player_voice_grunts")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Suppression = require("scripts/utilities/attack/suppression")
local Toughness = require("scripts/utilities/toughness/toughness")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Vo = require("scripts/utilities/vo")
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local ActionShout = class("ActionShout", "ActionAbilityBase")
local broadphase_results = {}

ActionShout.init = function (self, action_context, action_params, action_settings)
	ActionShout.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension
	self._unit_data_extension = unit_data_extension
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
end

ActionShout.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionShout.super.start(self, action_settings, t, time_scale, action_start_params)

	local locomotion_component = self._locomotion_component
	local locomotion_position = PlayerMovement.locomotion_position(locomotion_component)
	local player_position = locomotion_position
	local player_unit = self._player_unit
	local rotation = self._first_person_component.rotation
	local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
	self._shout_direction = forward
	local ability_template_tweak_data = self._ability_template_tweak_data
	local self_buff_to_add = ability_template_tweak_data.buff_to_add
	local slot_to_wield = action_settings.auto_wield_slot
	local wwise_state = action_settings.wwise_state

	if wwise_state then
		Wwise.set_state(wwise_state.group, wwise_state.on_state)
	end

	local vo_tag = action_settings.vo_tag

	if type(vo_tag) == "table" then
		local vo_type = action_settings.vo_type

		if vo_type == "warp_charge" then
			local warp_charge_component = self._unit_data_extension:read_component("warp_charge")
			local warp_charge_current_percentage = warp_charge_component.current_percentage
			local tag = warp_charge_current_percentage > 0.9 and vo_tag.high or vo_tag.low

			Vo.play_combat_ability_event(player_unit, tag)
		end
	else
		Vo.play_combat_ability_event(player_unit, vo_tag)
	end

	local sound_event = action_settings.sound_event

	if sound_event and self._is_local_unit then
		if type(sound_event) == "table" then
			for _, event_name in pairs(sound_event) do
				self._fx_extension:trigger_wwise_event(event_name, false, player_position)
			end
		else
			self._fx_extension:trigger_wwise_event(sound_event, false, player_position)
		end
	end

	if slot_to_wield then
		local inventory_comp = ScriptUnit.extension(player_unit, "unit_data_system"):read_component("inventory")
		local wielded_slot = inventory_comp.wielded_slot

		if slot_to_wield ~= wielded_slot then
			PlayerUnitVisualLoadout.wield_slot(slot_to_wield, player_unit, t)
		end
	end

	local anim = action_settings.anim
	local anim_3p = action_settings.anim_3p or anim

	if anim then
		self:trigger_anim_event(anim, anim_3p)
	end

	local vfx = action_settings.vfx

	if vfx then
		local vfx_pos = player_position + Vector3.up()

		self._fx_extension:spawn_particles(vfx, vfx_pos)
	end

	if self_buff_to_add then
		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

		buff_extension:add_internally_controlled_buff(self_buff_to_add, t)
	end

	if not self._is_server then
		return
	end

	table.clear(broadphase_results)

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local target_enemies = action_settings.target_enemies
	local target_allies = action_settings.target_allies

	if target_allies then
		local player_units = side.valid_player_units
		local buff_to_add = action_settings.buff_to_add
		local revive = action_settings.revive_allies
		local radius = action_settings.radius

		for i = 1, #player_units do
			local unit = player_units[i]
			local position = POSITION_LOOKUP[unit]
			local distance_sq = Vector3.distance_squared(player_position, position)

			if ALIVE[unit] and distance_sq < radius * radius then
				if buff_to_add then
					local buff_extension = ScriptUnit.extension(unit, "buff_system")

					buff_extension:add_internally_controlled_buff(buff_to_add, t, "owner_unit", player_unit)
				end

				local specialization_extension = ScriptUnit.has_extension(player_unit, "specialization_system")

				if revive then
					local side_extension = ScriptUnit.has_extension(unit, "side_system")
					local is_player_unit = side_extension.is_player_unit

					if specialization_extension then
						local revive_special_rule = special_rules.shout_revives_allies
						local has_special_rule = specialization_extension:has_special_rule(revive_special_rule)

						if has_special_rule and is_player_unit then
							local character_state_component = self._unit_data_extension:read_component("character_state")

							if character_state_component and PlayerUnitStatus.is_knocked_down(character_state_component) then
								local assisted_state_input_component = self._unit_data_extension:write_component("assisted_state_input")
								assisted_state_input_component.force_assist = true
							end
						end
					end
				end

				local toughness_special_rule = special_rules.shout_restores_toughness
				local has_special_rule = specialization_extension:has_special_rule(toughness_special_rule)

				if has_special_rule then
					local recover_toughness_effect = action_settings.recover_toughness_effect

					if recover_toughness_effect then
						local fx_extension = ScriptUnit.extension(unit, "fx_system")

						fx_extension:spawn_exclusive_particle(recover_toughness_effect, Vector3(0, 0, 1))
					end

					Toughness.recover_max_toughness(unit)
				end
			end
		end
	end

	if target_enemies then
		local enemy_side_names = side:relation_side_names("enemy")
		local ai_target_units = side.ai_target_units
		local player_units = side.valid_enemy_player_units
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local radius = action_settings.radius
		local num_hits = broadphase:query(player_position, radius, broadphase_results, enemy_side_names)
		local damage_profile = action_settings.damage_profile
		local damage_type = action_settings.damage_type
		local power_level = action_settings.power_level
		local buff_to_add = action_settings.buff_to_add
		local shout_direction = self._shout_direction
		local shout_dot = action_settings.shout_dot

		for i = 1, num_hits do
			repeat
				local enemy_unit = broadphase_results[i]

				if not ai_target_units[enemy_unit] or player_units[enemy_unit] then
					break
				end

				local minion_position = POSITION_LOOKUP[enemy_unit]
				local attack_direction = Vector3.normalize(Vector3.flat(minion_position - player_position))

				if Vector3.length_squared(attack_direction) == 0 then
					local player_rotation = locomotion_component.rotation
					attack_direction = Quaternion.forward(player_rotation)
				end

				local dot = Vector3.dot(shout_direction, attack_direction)

				if not shout_dot or shout_dot and shout_dot < dot then
					if buff_to_add then
						local buff_extension = ScriptUnit.extension(enemy_unit, "buff_system")

						buff_extension:add_internally_controlled_buff(buff_to_add, t, "owner_unit", player_unit)
					end

					local hit_zone_name = "torso"

					Attack.execute(enemy_unit, damage_profile, "attack_direction", attack_direction, "power_level", power_level, "hit_zone_name", hit_zone_name, "damage_type", damage_type, "attacking_unit", player_unit)

					local specialization_extension = ScriptUnit.has_extension(player_unit, "specialization_system")

					if specialization_extension then
						local special_rule = special_rules.shout_causes_suppression
						local has_special_rule = specialization_extension:has_special_rule(special_rule)

						if has_special_rule then
							Suppression.apply_suppression(enemy_unit, player_unit, damage_profile, POSITION_LOOKUP[player_unit])
						end
					end
				end
			until true
		end
	end

	local suppress_enemies = action_settings.suppress_enemies

	if suppress_enemies then
		self:_suppress_units(action_settings)
	end

	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local param_table = buff_extension:request_proc_event_param_table()
	param_table.unit = player_unit

	buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
end

ActionShout.finish = function (self, reason, data, t, time_in_action, action_settings)
	local wwise_state = action_settings.wwise_state

	if wwise_state then
		Wwise.set_state(wwise_state.group, wwise_state.off_state)
	end
end

local broadphase_results = {}

ActionShout._suppress_units = function (self, action_settings)
	table.clear(broadphase_results)

	local player_unit = self._player_unit
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local player_position = POSITION_LOOKUP[player_unit]
	local cone_dot = action_settings.cone_dot
	local cone_range = action_settings.cone_range
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local num_hits = broadphase:query(player_position, cone_range, broadphase_results, enemy_side_names)
	local rotation = self._first_person_component.rotation
	local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))

	for i = 1, num_hits do
		local enemy_unit = broadphase_results[i]
		local enemy_unit_position = POSITION_LOOKUP[enemy_unit]
		local flat_direction = Vector3.flat(enemy_unit_position - player_position)
		local direction = Vector3.normalize(flat_direction)
		local dot = Vector3.dot(forward, direction)

		if cone_dot < dot then
			local blackboard = BLACKBOARDS[enemy_unit]
			local perception_component = blackboard.perception
			local is_alerted = perception_component.target_unit

			if is_alerted then
				local damage_profile = action_settings.damage_profile

				Suppression.apply_suppression(enemy_unit, player_unit, damage_profile, player_position)
			end
		end
	end
end

return ActionShout
