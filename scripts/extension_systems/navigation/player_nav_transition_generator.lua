-- chunkname: @scripts/extension_systems/navigation/player_nav_transition_generator.lua

local PlayerNavTransitionGenerator = class("PlayerNavTransitionGenerator")
local STATES = table.enum("waiting", "jumping", "falling", "ledge_vaulting")

PlayerNavTransitionGenerator.init = function (self, unit, nav_world, traverse_logic)
	self._nav_world = nav_world
	self._traverse_logic = traverse_logic

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._character_state_component = unit_data_extension:read_component("character_state")
	self._inair_state_component = unit_data_extension:read_component("inair_state")
	self._locomotion_component = unit_data_extension:read_component("locomotion")
	self._ledge_vaulting_character_state_component = unit_data_extension:read_component("ledge_vaulting_character_state")

	local invalid_vector = Vector3.invalid_vector()

	self._from_position, self._via_position = Vector3Box(invalid_vector), Vector3Box(invalid_vector)
	self._state = STATES.waiting
end

local ALLOWED_STATES = {
	falling = {
		falling = true
	},
	jumping = {
		jumping = true,
		falling = true
	},
	ledge_vaulting = {
		jumping = true,
		sprinting = true,
		ledge_vaulting = true,
		falling = true,
		walking = true
	}
}

PlayerNavTransitionGenerator.fixed_update = function (self, unit, is_on_nav_mesh, latest_position_on_nav_mesh)
	local current_position = self._locomotion_component.position
	local state, character_state_component = self._state, self._character_state_component
	local character_state_name = character_state_component.state_name

	if state == STATES.waiting then
		if character_state_name == "jumping" or character_state_name == "falling" then
			local from_position = is_on_nav_mesh and latest_position_on_nav_mesh or self:_find_from_position(current_position, latest_position_on_nav_mesh)

			if from_position then
				self._from_position:store(from_position)
				self._via_position:store(current_position)
			end

			self._state = STATES[character_state_name]
		elseif character_state_name == "ledge_vaulting" then
			local from_position = is_on_nav_mesh and latest_position_on_nav_mesh or self:_find_from_position(current_position, latest_position_on_nav_mesh)

			if from_position then
				self._from_position:store(from_position)

				local ledge_vaulting_comp = self._ledge_vaulting_character_state_component
				local left, right = ledge_vaulting_comp.left, ledge_vaulting_comp.right
				local ledge_mid = Vector3.lerp(left, right, 0.5)
				local via = Vector3.lerp(from_position, ledge_mid, 0.1)

				self._via_position:store(via)
			end

			self._state = STATES[character_state_name]
		end
	elseif state == STATES.jumping or state == STATES.falling then
		local inair_state_component = self._inair_state_component

		if inair_state_component.on_ground then
			local from_position = self._from_position:unbox()

			if Vector3.is_valid(from_position) then
				local should_jump = state == STATES.jumping

				Managers.state.bot_nav_transition:create_transition(from_position, self._via_position:unbox(), current_position, should_jump)
			end

			self:_reset_state()
		elseif not ALLOWED_STATES[state][character_state_name] then
			self:_reset_state()
		end
	elseif state == STATES.ledge_vaulting then
		local inair_state_component = self._inair_state_component

		if inair_state_component.on_ground and is_on_nav_mesh then
			local from_position = self._from_position:unbox()

			if Vector3.is_valid(from_position) then
				Managers.state.bot_nav_transition:create_transition(from_position, self._via_position:unbox(), current_position, true)
			end

			self:_reset_state()
		elseif not ALLOWED_STATES[state][character_state_name] then
			self:_reset_state()
		end
	end
end

local EPSILON_SQ = 0.0001
local MAX_DISTANCE_FROM_NAV_MESH_SQ = 4

PlayerNavTransitionGenerator._find_from_position = function (self, current_position, latest_position_on_nav_mesh)
	if latest_position_on_nav_mesh == nil then
		return nil
	end

	if Vector3.distance_squared(current_position, latest_position_on_nav_mesh) <= EPSILON_SQ then
		return latest_position_on_nav_mesh
	end

	local nav_world, traverse_logic = self._nav_world, self._traverse_logic
	local _, new_last_position = GwNavQueries.raycast(nav_world, latest_position_on_nav_mesh, current_position, traverse_logic)

	if Vector3.distance_squared(current_position, new_last_position) < MAX_DISTANCE_FROM_NAV_MESH_SQ then
		return new_last_position
	end
end

PlayerNavTransitionGenerator._reset_state = function (self)
	local invalid_vector = Vector3.invalid_vector()

	self._from_position:store(invalid_vector)
	self._via_position:store(invalid_vector)

	self._state = STATES.waiting
end

return PlayerNavTransitionGenerator
