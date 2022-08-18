require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Breed = require("scripts/utilities/breed")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local Health = require("scripts/utilities/health")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local ActionHealTargetOverTime = class("ActionHealTargetOverTime", "ActionWeaponBase")
local TARGET_LOOPING_SOUND_ALIAS = "ability_target_activating"

ActionHealTargetOverTime.init = function (self, action_context, action_params, action_settings)
	ActionHealTargetOverTime.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension
	self._action_component = unit_data_extension:write_component("action_heal_target_over_time")
	local component_name = PlayerUnitData.looping_sound_component_name(TARGET_LOOPING_SOUND_ALIAS)
	self._looping_sound_component = unit_data_extension:read_component(component_name)
	local weapon = action_params.weapon
	self._fx_sound_source_name = weapon.fx_sources._muzzle
end

ActionHealTargetOverTime.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionHealTargetOverTime.super.start(self, action_settings, t, time_scale, action_start_params)

	self._heal_timer = action_settings.heal_tick_time
	self._raycast_timer = 0

	self._fx_extension:trigger_looping_wwise_event("ability_no_target_activating", self._fx_sound_source_name)
end

local INDEX_ACTOR = 4

ActionHealTargetOverTime.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local targeting_params = action_settings.targeting_params
	local range = targeting_params.range
	local target_unit = self._action_component.target_unit

	if not target_unit and self._raycast_timer <= 0 then
		local physics_world = self._physics_world
		local first_person = self._first_person_component
		local position = first_person.position
		local rotation = first_person.rotation
		local direction = Quaternion.forward(rotation)
		local collision_filter = targeting_params.collision_filter
		local hits = PhysicsWorld.raycast(physics_world, position, direction, range, "all", "types", "both", "collision_filter", collision_filter)

		if hits then
			local num_hits = #hits

			for index = 1, num_hits, 1 do
				local hit = hits[index]
				local hit_actor = hit[INDEX_ACTOR]
				local hit_unit = Actor.unit(hit_actor)

				if hit_unit ~= self._player_unit then
					local unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
					local breed_or_nil = unit_data_extension and unit_data_extension:breed()
					local is_character = Breed.is_character(breed_or_nil)

					if is_character then
						self._action_component.target_unit_1 = hit_unit
						target_unit = hit_unit

						self:trigger_anim_event("heavy_charge", "heavy_charge")

						if not self._looping_sound_component.is_playing then
							self._fx_extension:trigger_looping_wwise_event(TARGET_LOOPING_SOUND_ALIAS, self._fx_sound_source_name)
						end
					end

					break
				end
			end
		end

		self._raycast_timer = targeting_params.time_between_raycasts
	end

	if target_unit then
		self._heal_timer = self._heal_timer - dt

		if self._is_server and self._heal_timer <= 0 then
			local heal_type = DamageSettings.heal_types.heal_over_time_tick
			local heal_amount = action_settings.heal_amount
			local health_added = Health.add(target_unit, heal_amount, heal_type)

			if health_added > 0 then
				Health.play_fx(target_unit)
			end

			self._heal_timer = action_settings.heal_tick_time
		end

		local distance_squared = Vector3.distance_squared(POSITION_LOOKUP[target_unit], POSITION_LOOKUP[self._player_unit])

		if distance_squared > range * range then
			self._action_component.target_unit_1 = nil

			if self._looping_sound_component.is_playing then
				self._fx_extension:stop_looping_wwise_event(TARGET_LOOPING_SOUND_ALIAS)
			end

			self:trigger_anim_event("attack_charge", "attack_charge")
		end
	end

	self._raycast_timer = self._raycast_timer - dt
	self._heal_timer = self._heal_timer - dt
end

ActionHealTargetOverTime.finish = function (self, reason, data, t, time_in_action)
	if self._action_component.target_unit then
		self._fx_extension:stop_looping_wwise_event(TARGET_LOOPING_SOUND_ALIAS)

		self._action_component.target_unit_1 = nil
	end

	self._fx_extension:stop_looping_wwise_event("ability_no_target_activating")
end

return ActionHealTargetOverTime
