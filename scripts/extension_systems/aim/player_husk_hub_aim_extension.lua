local HubAimConstraints = require("scripts/extension_systems/aim/utilities/hub_aim_constraints")
local PlayerHuskHubAimExtension = class("PlayerHuskHubAimExtension")

PlayerHuskHubAimExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session_id, game_object_id, owner_id)
	self._game_session_id = game_session_id
	self._game_object_id = game_object_id
	self._init_context = {
		aim_constraint_target_name = extension_init_data.aim_constraint_target_name,
		aim_constraint_target_torso_name = extension_init_data.aim_constraint_target_torso_name,
		aim_constraint_distance = extension_init_data.aim_constraint_distance,
		head_aim_weight_name = extension_init_data.head_aim_weight_name,
		torso_aim_weight_name = extension_init_data.torso_aim_weight_name
	}
	self._hub_aim_constraints = nil
end

PlayerHuskHubAimExtension.state_machine_changed = function (self, unit)
	self._hub_aim_constraints = HubAimConstraints:new(unit, self._init_context)
end

PlayerHuskHubAimExtension.update = function (self, unit, dt, t)
	local hub_aim_constraints = self._hub_aim_constraints

	if not hub_aim_constraints then
		return
	end

	local game_session_id = self._game_session_id
	local game_object_id = self._game_object_id
	local head_direction = GameSession.game_object_field(game_session_id, game_object_id, "hub_head_aim_direction")
	local torso_direction = GameSession.game_object_field(game_session_id, game_object_id, "hub_torso_aim_direction")
	local aim_state = GameSession.game_object_field(game_session_id, game_object_id, "hub_aim_state")
	local is_moving = hub_aim_constraints:is_moving()

	hub_aim_constraints:update(head_direction, torso_direction, is_moving, aim_state, dt, t)
end
