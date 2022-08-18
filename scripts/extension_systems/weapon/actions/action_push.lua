require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Attack = require("scripts/utilities/attack/attack")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local LagCompensation = require("scripts/utilities/lag_compensation")
local PlayerMovement = require("scripts/utilities/player_movement")
local Stamina = require("scripts/utilities/attack/stamina")
local proc_events = BuffSettings.proc_events
local IMPACT_FX_DATA = {
	will_be_predicted = true
}
local UNIT_LENGTH_THRESHOLD = 0.99
local ActionPush = class("ActionPush", "ActionWeaponBase")

ActionPush.init = function (self, action_context, ...)
	ActionPush.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension
	self._block_component = unit_data_extension:write_component("block")
	self._action_push_component = unit_data_extension:write_component("action_push")
end

ActionPush.start = function (self, ...)
	ActionPush.super.start(self, ...)

	self._action_push_component.has_pushed = false
end

local function _owned_by_death_manager(hit_unit)
	local unit_data_ext = ScriptUnit.has_extension(hit_unit, "unit_data_system")

	if not unit_data_ext then
		return false
	end

	local owned_by_death_manager = unit_data_ext:is_owned_by_death_manager()

	return owned_by_death_manager
end

ActionPush.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings

	if self._block_component.is_blocking and action_settings.block_duration <= time_in_action then
		self._block_component.is_blocking = false
	end

	local damage_time = action_settings.damage_time or 0

	if time_in_action >= damage_time and not self._action_push_component.has_pushed then
		self:_push(t)

		self._action_push_component.has_pushed = true
	end
end

ActionPush.finish = function (self, ...)
	ActionPush.super.finish(self, ...)

	self._block_component.is_blocking = false
	self._action_push_component.has_pushed = false
end

local hit_units = {}

ActionPush._push = function (self, t)
	local action_settings = self._action_settings

	if not self._unit_data_extension.is_resimulating then
		local locomotion_component = self._locomotion_component
		local locomotion_position = PlayerMovement.locomotion_position(locomotion_component)
		local player_position = locomotion_position
		local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)
		local collision_filter = "filter_player_character_push"
		local actors, num_actors = PhysicsWorld.immediate_overlap(self._physics_world, "shape", "sphere", "position", player_position, "size", self._action_settings.push_radius, "collision_filter", collision_filter, "rewind_ms", rewind_ms)
		local power_level = action_settings.power_level
		local fp_rotation = self._first_person_component.rotation
		local right = Quaternion.right(fp_rotation)
		local player_direction = Vector3.cross(right, Vector3.down())
		local player_unit = self._player_unit

		table.clear(hit_units)

		for i = 1, num_actors do
			local actor = actors[i]
			local unit = Actor.unit(actor)
			local owned_by_death_manager = _owned_by_death_manager(unit)

			if not owned_by_death_manager and not hit_units[unit] then
				local minion_position = POSITION_LOOKUP[unit]
				local attack_direction = Vector3.normalize(Vector3.flat(minion_position - player_position))
				local damage_profile, damage_type = nil

				if Vector3.length_squared(attack_direction) < UNIT_LENGTH_THRESHOLD then
					attack_direction = player_direction
					damage_profile = action_settings.inner_damage_profile
				else
					local angle = Vector3.angle(attack_direction, player_direction, true)
					local buff_extension = self._buff_extension
					local stat_buffs = buff_extension:stat_buffs()
					local inner_push_angle_modifier = stat_buffs.inner_push_angle_modifier
					local outer_push_angle_modifier = stat_buffs.outer_push_angle_modifier
					local inner_push_rad = action_settings.inner_push_rad * inner_push_angle_modifier
					local outer_push_rad = action_settings.outer_push_rad * outer_push_angle_modifier

					if angle <= inner_push_rad then
						damage_profile = action_settings.inner_damage_profile
						damage_type = action_settings.inner_damage_type
					elseif angle <= outer_push_rad then
						damage_profile = action_settings.outer_damage_profile
						damage_type = action_settings.outer_damage_type
					end
				end

				local hit_world_position = Actor.position(actor)

				if damage_profile then
					hit_units[unit] = true
					local hit_zone_name = "torso"
					local damage_dealt, attack_result, damage_efficiency = Attack.execute(unit, damage_profile, "attacking_unit", player_unit, "attack_direction", attack_direction, "hit_world_position", hit_world_position, "hit_actor", actor, "power_level", power_level, "hit_zone_name", hit_zone_name, "damage_type", damage_type, "item", self._weapon.item)

					ImpactEffect.play(unit, actor, damage_dealt, damage_type, hit_zone_name, attack_result, hit_world_position, nil, attack_direction, player_unit, IMPACT_FX_DATA, nil, nil, damage_efficiency, damage_profile)

					local buff_extension = self._buff_extension
					local param_table = buff_extension:request_proc_event_param_table()
					param_table.pushing_unit = player_unit
					param_table.pushed_unit = unit

					self._buff_extension:add_proc_event(proc_events.on_push, param_table)
				end
			end
		end
	end

	if not action_settings.block_duration then
		self._block_component.is_blocking = false
	end

	local weapon_stamina_template = self._weapon_extension:stamina_template()
	local push_cost = weapon_stamina_template and weapon_stamina_template.push_cost or math.huge

	Stamina.drain(self._player_unit, push_cost, t)
	self:_pay_warp_charge_cost(t)

	if action_settings.activate_special then
		self:_set_weapon_special(true, t)
	end

	self:_play_push_particles(t)
end

ActionPush._play_push_particles = function (self, t)
	if self._unit_data_extension.is_resimulating then
		return
	end

	local fx = self._action_settings.fx

	if not fx then
		return
	end

	local effect_name = fx.vfx_effect
	local effect_to_play = effect_name

	if not effect_to_play then
		return
	end

	local spawner_name = fx.fx_source
	local fx_extension = self._fx_extension
	local link = true
	local orphaned_policy = "destroy"
	local position_offset = fx.fx_position_offset and fx.fx_position_offset:unbox()
	local rotation_offset = fx.fx_rotation_offset and fx.fx_rotation_offset:unbox()
	local particle_id = fx_extension:spawn_unit_particles(effect_to_play, spawner_name, link, orphaned_policy, position_offset, rotation_offset)
end

return ActionPush
