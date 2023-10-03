local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerOverlapManager = class("PlayerOverlapManager")

PlayerOverlapManager.init = function (self, physics_world)
	self._physics_world = physics_world
	self._overlap_result = {}
	self._active = false
end

PlayerOverlapManager.destroy = function (self)
	return
end

PlayerOverlapManager.add_listening_actor = function (self, actor)
	if self._overlap_result[actor] then
		Log.warning("PlayerOverlapManager", "Trying to listen to an already registered actor")

		return
	end

	self._active = true
	local overlap_results = {}
	self._overlap_result[actor] = overlap_results

	return overlap_results
end

PlayerOverlapManager.remove_listening_actor = function (self, actor)
	self._overlap_result[actor] = nil
end

local player_units = {}
local deprecated_units = {}

PlayerOverlapManager.fixed_update = function (self, dt, t)
	if not self._active then
		return
	end

	local players = Managers.player:human_players()

	table.clear(player_units)

	for _, player in pairs(players) do
		local player_unit = player.player_unit

		if ALIVE[player_unit] then
			player_units[player_unit] = true

			self:_send_overlap_request(player_unit)
		end
	end

	for actor, _ in pairs(self._overlap_result) do
		local old_overlaps = self._overlap_result[actor]

		table.clear(deprecated_units)

		for overlap_unit, _ in pairs(old_overlaps) do
			if not player_units[overlap_unit] then
				deprecated_units[overlap_unit] = true
			end
		end

		for deprecated_unit, _ in pairs(deprecated_units) do
			old_overlaps[deprecated_unit] = nil
		end
	end
end

local HEIGHT = PlayerCharacterConstants.respawn_hot_join_height

PlayerOverlapManager._send_overlap_request = function (self, player_unit)
	local mover = Unit.mover(player_unit)
	local player_position = Unit.world_position(player_unit, 1)
	local player_radius = Mover.radius(mover)
	local capsule_rotation = Quaternion.look(Vector3.up())
	local capsule_size = Vector3(player_radius, HEIGHT / 2, player_radius)

	PhysicsWorld.overlap(self._physics_world, function (...)
		self:_receive_overlap_result(player_unit, ...)
	end, "shape", "capsule", "position", player_position + Vector3.up() * HEIGHT / 2, "rotation", capsule_rotation, "size", capsule_size, "collision_filter", "filter_platform_wall_trigger")
end

PlayerOverlapManager._receive_overlap_result = function (self, player_unit, _, hit_actors)
	for actor, _ in pairs(self._overlap_result) do
		self._overlap_result[actor][player_unit] = nil
	end

	for _, actor in pairs(hit_actors) do
		local overlaps_for_actor = self._overlap_result[actor]

		if overlaps_for_actor then
			overlaps_for_actor[player_unit] = true
		end
	end
end

return PlayerOverlapManager
