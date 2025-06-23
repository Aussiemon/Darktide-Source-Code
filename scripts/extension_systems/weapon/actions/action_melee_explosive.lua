-- chunkname: @scripts/extension_systems/weapon/actions/action_melee_explosive.lua

require("scripts/extension_systems/weapon/actions/action_sweep")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local Explosion = require("scripts/utilities/attack/explosion")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local ActionMeleeExplosive = class("ActionMeleeExplosive", "ActionSweep")

ActionMeleeExplosive.init = function (self, action_context, action_params, action_settings)
	ActionMeleeExplosive.super.init(self, action_context, action_params, action_settings)

	self._exploding_time = nil
	self._have_exploded = nil
	self._have_added_buff = nil
end

ActionMeleeExplosive.start = function (self, action_settings, t, ...)
	ActionMeleeExplosive.super.start(self, action_settings, t, ...)

	self._exploding_time = nil
	self._have_exploded = nil
	self._have_added_buff = nil
end

ActionMeleeExplosive.fixed_update = function (self, dt, t, time_in_action, frame)
	ActionMeleeExplosive.super.fixed_update(self, dt, t, time_in_action, frame)

	local exploding_time = self._exploding_time
	local will_explode = not not exploding_time

	if will_explode and exploding_time < t then
		self:_explode(t)
	end

	local have_exploded = self._have_exploded
	local have_added_buff = self._have_added_buff

	if have_exploded and not have_added_buff then
		local action_settings = self._action_settings
		local movement_speed_buff = action_settings.exploding_movement_speed_buff
		local buff_extension = self._buff_extension

		buff_extension:add_internally_controlled_buff(movement_speed_buff, t)

		self._have_added_buff = true
	end
end

ActionMeleeExplosive.finish = function (self, reason, data, t, time_in_action)
	ActionMeleeExplosive.super.finish(self, reason, data, t, time_in_action)

	self._exploding_time = nil
	self._have_exploded = nil
	self._have_added_buff = nil
end

ActionMeleeExplosive._explode = function (self, t)
	local action_settings = self._action_settings
	local explosion_template = action_settings.explosion_template
	local explode_position, explode_direction = self:_find_explosion_position_and_direction()

	if self._is_server then
		local is_critical_strike = false
		local ignore_cover = false
		local weapon = self._weapon
		local item = weapon and weapon.item
		local origin_slot = self._inventory_component.wielded_slot

		Explosion.create_explosion(self._world, self._physics_world, explode_position, explode_direction, self._player.player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, AttackSettings.attack_types.explosion, is_critical_strike, ignore_cover, item, origin_slot)
	end

	local ammunition_usage = action_settings.ammunition_usage

	if ammunition_usage then
		local inventory_slot_component = self._inventory_slot_component
		local new_ammunition = math.max(inventory_slot_component.current_ammunition_clip - ammunition_usage, 0)

		inventory_slot_component.current_ammunition_clip = new_ammunition
		inventory_slot_component.last_ammunition_usage = t
	end

	self._exploding_time = nil
	self._have_exploded = true
end

ActionMeleeExplosive._process_hit = function (self, t, unit, hit_actor, hit_units, action_settings, hit_position, attack_direction, hit_zone_name_or_nil, hit_normal, action_sweep_component)
	local abort_attack, armor_aborts_attack = ActionMeleeExplosive.super._process_hit(self, t, unit, hit_actor, hit_units, action_settings, hit_position, attack_direction, hit_zone_name_or_nil, hit_normal, action_sweep_component)
	local ammunition_usage = action_settings.ammunition_usage
	local has_ammo = ActionUtility.has_ammunition(self._inventory_slot_component, self._action_settings)

	if abort_attack and (not ammunition_usage or ammunition_usage and has_ammo) then
		local explosion_delay = action_settings.explosion_delay

		self._exploding_time = t + explosion_delay
	end

	return abort_attack, armor_aborts_attack
end

ActionMeleeExplosive._find_explosion_position_and_direction = function (self)
	local action_settings = self._action_settings
	local first_person_component = self._first_person_component
	local look_rotation = first_person_component.rotation
	local look_forward = Quaternion.forward(look_rotation)
	local look_position = first_person_component.position
	local local_offset = action_settings.explosion_offset:unbox()
	local offset = Quaternion.rotate(look_rotation, local_offset)
	local explosion_position = look_position + offset

	return explosion_position, look_forward
end

ActionMeleeExplosive._play_hit_animations = function (self, action_settings, abort_attack, armor_aborts_attack, special_active)
	local exploding_time = self._exploding_time
	local will_explode = not not exploding_time

	if not will_explode then
		ActionMeleeExplosive.super._play_hit_animations(self, action_settings, abort_attack, armor_aborts_attack, special_active)

		return
	end

	local first_person_hit_anim = action_settings.hit_explosion_anim
	local third_person_hit_anim = action_settings.hit_explosion_anim
	local anim_ext = self._animation_extension

	if first_person_hit_anim then
		anim_ext:anim_event_1p(first_person_hit_anim)
	end

	if third_person_hit_anim then
		anim_ext:anim_event(third_person_hit_anim)
	end
end

return ActionMeleeExplosive
