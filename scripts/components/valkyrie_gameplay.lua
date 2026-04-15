-- chunkname: @scripts/components/valkyrie_gameplay.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Attack = require("scripts/utilities/attack/attack")
local Health = require("scripts/utilities/health")
local PlayerDeath = require("scripts/utilities/player_death")
local Push = require("scripts/extension_systems/character_state_machine/character_states/utilities/push")
local ValkyrieGameplay = component("ValkyrieGameplay")

ValkyrieGameplay.init = function (self, unit, is_server)
	self._overlap_result = {}
	self._unit = unit

	if self:get_data(unit, "kill_overlap") then
		self:kill_overlap_enable(unit)
	end

	local level = Unit.level(unit)
	local level_landing_position = self:get_data(unit, "landing_position")
	local level_pose = Level.pose(level)
	local level_position = Matrix4x4.translation(level_pose)
	local level_rotation = Matrix4x4.rotation(level_pose)

	self._landing_position = Vector3Box(level_position + Quaternion.rotate(level_rotation, level_landing_position:unbox()))
	self._landing_timer = 0
	self._particle_id = nil
	self._particle_var_index = nil
	self._world = Unit.world(unit)

	return true
end

ValkyrieGameplay.editor_init = function (self, unit)
	return
end

ValkyrieGameplay.enable = function (self, unit)
	return
end

ValkyrieGameplay.disable = function (self, unit)
	return
end

ValkyrieGameplay.destroy = function (self, unit)
	if self._kill_overlap then
		self:kill_overlap_disable(unit)
	end

	local particle_id = self._particle_id

	if particle_id then
		local world = self._world

		if World.are_particles_playing(world, particle_id) then
			World.destroy_particles(world, particle_id)
		end

		self._particle_id = nil
	end
end

ValkyrieGameplay.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

local DELAY_TIMER = {}
local PUSH_TEMPLATE = {
	speed = 0,
}
local PUSH_DISTANCE = 10

ValkyrieGameplay.update = function (self, unit, dt, t)
	if self._kill_overlap then
		self._landing_timer = self._landing_timer + dt

		local landing_time = self._landing_timer

		World.set_particles_emit_rate_multiplier(self._world, self._particle_id, math.min(landing_time / 5, 1))

		local particle_intensity = math.min(0.2 + landing_time / 10, 1)

		World.set_particles_variable(self._world, self._particle_id, self._particle_var_index, Vector3(particle_intensity, particle_intensity, 0.1))

		if landing_time > 5 then
			local push_power = math.min(landing_time - 5, 2) / 5
			local players = Managers.player:players()
			local landing_position = self._landing_position:unbox()

			for _, player in pairs(players) do
				local player_unit = player.player_unit

				if player_unit and ALIVE[player_unit] and not Managers.state.unit_spawner:is_husk(player_unit) then
					local player_position = POSITION_LOOKUP[player_unit]
					local distance = Vector3.distance(landing_position, player_position)
					local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

					if distance < PUSH_DISTANCE and (not DELAY_TIMER[player_unit] or t - DELAY_TIMER[player_unit] >= 0.1) then
						DELAY_TIMER[player_unit] = t

						local push_speed = (PUSH_DISTANCE - distance) * push_power

						if push_speed > 0.2 then
							PUSH_TEMPLATE.speed = push_speed

							local push_direction = Vector3.normalize(player_position - landing_position)
							local locomotion_push_component = unit_data_extension:write_component("locomotion_push")

							Push.add(player_unit, locomotion_push_component, push_direction, PUSH_TEMPLATE, "attack")
						end
					end

					local first_person_component = unit_data_extension:read_component("first_person")

					if self.is_server and Health.current_health_percent(player_unit) > 0 and Unit.is_point_inside_volume(unit, "c_kill_zone", player_position + Vector3.up() * first_person_component.height) then
						local reason = "valkyrie_landing"

						PlayerDeath.die(player_unit, nil, nil, reason)

						local attack_direction = Vector3.down()
						local damage_profile = DamageProfileTemplates.kill_volume_and_off_navmesh

						Attack.execute(player_unit, damage_profile, "instakill", true, "attack_direction", attack_direction)
					end
				end
			end
		end
	end

	return true
end

local PARTICLE = "content/fx/particles/environment/valkyrie_takeoff_kickup_dust"

ValkyrieGameplay.kill_overlap_enable = function (self)
	local unit = self._unit

	self._kill_overlap = true
	self._landing_timer = 0

	local landing_position = self._landing_position:unbox()

	Managers.event:trigger("event_register_danger_zone", unit, landing_position, 8)

	self._particle_id = World.create_particles(self._world, PARTICLE, landing_position, Unit.world_rotation(unit, 1))
	self._particle_var_index = World.find_particles_variable(self._world, PARTICLE, "intensity")

	World.set_particles_variable(self._world, self._particle_id, self._particle_var_index, Vector3(0.2, 0.2, 0.1))
	World.set_particles_emit_rate_multiplier(self._world, self._particle_id, 0)
end

ValkyrieGameplay.kill_overlap_disable = function (self)
	self._kill_overlap = false

	Managers.event:trigger("event_unregister_danger_zone", self._unit)

	if self._particle_id then
		World.stop_spawning_particles(self._world, self._particle_id)
	end
end

ValkyrieGameplay.hatch_open = function (self)
	if not self.is_server then
		return
	end

	local valkyrie_unit = self._unit
	local valkyrie_position = Unit.world_position(valkyrie_unit, 1)
	local hatch_node_index = Unit.node(valkyrie_unit, "hatch_push")
	local hatch_position = Unit.world_position(valkyrie_unit, hatch_node_index)
	local push_direction = Vector3.normalize(hatch_position - valkyrie_position)
	local players = Managers.player:players()

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit and ALIVE[player_unit] then
			local player_position = POSITION_LOOKUP[player_unit]

			if math.abs(player_position.x - hatch_position.x) < 2.4 and math.abs(player_position.y - hatch_position.y) < 2.4 then
				PUSH_TEMPLATE.speed = 11

				local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
				local locomotion_push_component = unit_data_extension:write_component("locomotion_push")

				Push.add(player_unit, locomotion_push_component, push_direction, PUSH_TEMPLATE, "attack")
			end
		end
	end
end

ValkyrieGameplay.component_data = {
	kill_overlap = {
		ui_name = "Kill overlapping",
		ui_type = "check_box",
		value = false,
	},
	landing_position = {
		ui_name = "Landing position",
		ui_type = "vector",
		value = Vector3Box(0, 0, 0),
	},
	inputs = {
		kill_overlap_enable = {
			accessibility = "public",
			type = "event",
		},
		kill_overlap_disable = {
			accessibility = "public",
			type = "event",
		},
		hatch_open = {
			accessibility = "public",
			type = "event",
		},
	},
}

return ValkyrieGameplay
