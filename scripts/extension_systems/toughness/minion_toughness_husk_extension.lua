local MinionToughnessHuskExtension = class("MinionToughnessHuskExtension")
local _get_network_values = nil
local CLIENT_RPCS = {
	"rpc_minion_toughness_attack_absorbed"
}
local STATES = table.enum("active", "depleted")

MinionToughnessHuskExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id, owner_id)
	self._unit = unit
	self._game_session = game_session
	self._game_object_id = game_object_id
	local breed = extension_init_data.breed
	self._toughness_template = breed.toughness_template
	self._stored_attacks = {}

	assert(not extension_init_context.is_server, "Only the clients should have MinionToughnessHuskExtensions registered")

	local network_event_delegate = extension_init_context.network_event_delegate

	network_event_delegate:register_session_unit_events(self, game_object_id, unpack(CLIENT_RPCS))

	self._game_object_id = game_object_id
	self._network_event_delegate = network_event_delegate
	self._state = STATES.active
end

MinionToughnessHuskExtension.destroy = function (self)
	self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))

	local toughness_template = self._toughness_template
	local linked_actor_name = toughness_template.linked_actor

	if linked_actor_name then
		self:_set_linked_actor_active(linked_actor_name, false)
	end
end

MinionToughnessHuskExtension.update = function (self, context, dt, t)
	local current_toughness_percent = self:current_toughness_percent()
	local current_state = self._state
	local new_state = current_toughness_percent > 0 and STATES.active or STATES.depleted

	if current_state ~= new_state then
		self:_switch_state(context, new_state)
	end
end

MinionToughnessHuskExtension.current_toughness_percent = function (self)
	local toughness_damage, max_toughness = _get_network_values(self._game_session, self._game_object_id)

	return 1 - toughness_damage / max_toughness
end

MinionToughnessHuskExtension.stored_attacks = function (self)
	return self._stored_attacks
end

MinionToughnessHuskExtension.toughness_damage = function (self)
	local toughness_damage, _ = _get_network_values(self._game_session, self._game_object_id)

	return toughness_damage
end

MinionToughnessHuskExtension.toughness_templates = function (self)
	return self._toughness_template, nil
end

MinionToughnessHuskExtension._switch_state = function (self, context, new_state)
	local toughness_template = self._toughness_template
	local linked_actor_name = toughness_template.linked_actor

	if linked_actor_name then
		local active = new_state == STATES.active

		self:_set_linked_actor_active(linked_actor_name, active)
	end

	self._state = new_state
end

MinionToughnessHuskExtension._set_linked_actor_active = function (self, linked_actor_name, active)
	local unit = self._unit
	local actor_id = Unit.find_actor(unit, linked_actor_name)
	local actor = Unit.actor(unit, actor_id)

	Actor.set_collision_enabled(actor, active)
	Actor.set_scene_query_enabled(actor, active)
end

MinionToughnessHuskExtension._store_toughness_attack_absorbed = function (self, damage_amount, impact_world_position)
	local attack = {
		damage_amount = damage_amount,
		impact_world_position = Vector3Box(impact_world_position)
	}
	local stored_attacks = self._stored_attacks

	table.insert(stored_attacks, attack)
end

function _get_network_values(game_session, game_object_id)
	local toughness_damage = GameSession.game_object_field(game_session, game_object_id, "toughness_damage")
	local max_toughness = GameSession.game_object_field(game_session, game_object_id, "toughness")

	return toughness_damage, max_toughness
end

MinionToughnessHuskExtension.rpc_minion_toughness_attack_absorbed = function (self, channel_id, game_object_id, impact_world_position, damage_amount)
	self:_store_toughness_attack_absorbed(damage_amount, impact_world_position)
end

return MinionToughnessHuskExtension
