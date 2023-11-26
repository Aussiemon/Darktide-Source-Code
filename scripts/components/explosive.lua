-- chunkname: @scripts/components/explosive.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local Explosive = component("Explosive")

Explosive.init = function (self, unit, is_server)
	self:enable(unit)

	self._is_server = is_server
	self._unit = unit
	self._power_level = self:get_data(unit, "power_level")
	self._charge_level = self:get_data(unit, "charge_level")
	self._setting_name = self:get_data(unit, "setting_name")

	local explosion_template_name = self:get_data(unit, "explosion_template_name")

	self._explosion_template = ExplosionTemplates[explosion_template_name]

	local world = Managers.world:world("level_world")

	self._world = world

	local physics_world = World.physics_world(world)

	self._physics_world = physics_world
	self._exploded = false
end

Explosive.events.died = function (self)
	self:explosive_trigger()
end

Explosive.editor_init = function (self, unit)
	self:enable(unit)
end

Explosive.editor_validate = function (self, unit)
	return true, ""
end

Explosive.enable = function (self, unit)
	return
end

Explosive.disable = function (self, unit)
	return
end

Explosive.destroy = function (self, unit)
	return
end

Explosive.explosive_trigger = function (self)
	if not self._is_server then
		return
	end

	if not self._exploded then
		local attack_type = AttackSettings.attack_types.explosion
		local unit = self._unit
		local explosion_position

		if Unit.has_node(unit, "c_explosion") then
			explosion_position = Unit.world_position(unit, Unit.node(unit, "c_explosion"))
		else
			explosion_position = Unit.local_position(unit, 1)
		end

		local power_level = self._power_level
		local charge_level = self._charge_level

		self._exploded = true

		Explosion.create_explosion(self._world, self._physics_world, explosion_position, Vector3.up(), unit, self._explosion_template, power_level, charge_level, attack_type)
	end
end

Explosive.component_data = {
	explosion_template_name = {
		ui_type = "text_box",
		value = "explosive_barrel",
		ui_name = "Explosion Template Name"
	},
	power_level = {
		ui_type = "number",
		decimals = 0,
		value = 1000,
		ui_name = "Power Level",
		step = 1
	},
	charge_level = {
		ui_type = "number",
		decimals = 0,
		value = 1,
		ui_name = "Charge Level",
		step = 1
	},
	inputs = {
		explosive_trigger = {
			accessibility = "private",
			type = "event"
		}
	},
	extensions = {}
}

return Explosive
