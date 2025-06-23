-- chunkname: @scripts/components/prop_on_hit_physics.lua

local Component = require("scripts/utilities/component")
local PropOnHitPhysics = component("PropOnHitPhysics")

PropOnHitPhysics.init = function (self, unit, is_server)
	self._unit = unit
	self._is_server = is_server
	self._mass = self:get_data(unit, "mass")
	self._speed = self:get_data(unit, "speed_on_hit")
end

PropOnHitPhysics.editor_init = function (self)
	return
end

PropOnHitPhysics.editor_validate = function (self, unit)
	return true, ""
end

PropOnHitPhysics.enable = function (self, unit)
	return
end

PropOnHitPhysics.disable = function (self, unit)
	return
end

PropOnHitPhysics.destroy = function (self, unit)
	return
end

local function _add_force_on_parts(actor, mass, speed, attack_direction)
	local direction = attack_direction

	if not direction then
		local random_x = math.random() * 2 - 1
		local random_y = math.random() * 2 - 1
		local random_z = math.random() * 2 - 1
		local random_direction = Vector3(random_x, random_y, random_z)

		random_direction = Vector3.normalize(random_direction)
		direction = random_direction
	end

	Actor.add_impulse(actor, direction * mass * speed)
end

PropOnHitPhysics.events.on_hit = function (self, attack_direction)
	local unit = self._unit
	local mass = self._mass
	local speed = self._speed
	local actor = Unit.actor(unit, self:get_data(unit, "actor_name"))

	if not self._is_server then
		_add_force_on_parts(actor, mass, speed, attack_direction)
	end

	if not self._is_server then
		Unit.flow_event(self._unit, "lua_prop_damaged")
	end

	if self._is_server and not rawget(_G, "LevelEditor") then
		Component.trigger_event_on_clients(self, "on_hit", "rpc_prop_on_hit_physics", attack_direction)
	end
end

PropOnHitPhysics.component_data = {
	actor_name = {
		ui_type = "text_box",
		value = "",
		ui_name = "Actor Name"
	},
	mass = {
		ui_type = "number",
		value = 1,
		ui_name = "Mass"
	},
	speed_on_hit = {
		ui_type = "number",
		min = 0,
		ui_name = "Impulse Speed on Hit",
		value = 5
	}
}

return PropOnHitPhysics
