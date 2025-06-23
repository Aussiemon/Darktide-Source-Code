-- chunkname: @scripts/components/explosion_spawner.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local ExplosionSpawner = component("ExplosionSpawner")

ExplosionSpawner.init = function (self, unit, is_server)
	self:enable(unit)

	self._is_server = is_server
	self._unit = unit
	self._power_level = self:get_data(unit, "power_level")
	self._charge_level = self:get_data(unit, "charge_level")
	self._spawn_offset = self:get_data(unit, "spawn_offset")
	self._spawn_node = self:get_data(unit, "spawn_node")
	self._ignore_cover = self:get_data(unit, "ignore_cover")

	local explosion_template_name = self:get_data(unit, "explosion_template_name")

	self._explosion_template = ExplosionTemplates[explosion_template_name]

	local world = Unit.world(unit)
	local physics_world = World.physics_world(world)

	self._world = world
	self._physics_world = physics_world
end

ExplosionSpawner.events.unit_died = function (self)
	self:explosive_trigger()
end

ExplosionSpawner.editor_init = function (self, unit)
	self:enable(unit)
end

ExplosionSpawner.editor_validate = function (self, unit)
	return true, ""
end

ExplosionSpawner.enable = function (self, unit)
	return
end

ExplosionSpawner.disable = function (self, unit)
	return
end

ExplosionSpawner.destroy = function (self, unit)
	return
end

ExplosionSpawner.create_explosion = function (self)
	if not self._is_server then
		return
	end

	local world = self._world
	local physics_world = self._physics_world
	local unit = self._unit
	local explosion_template = self._explosion_template
	local power_level = self._power_level
	local charge_level = self._charge_level
	local spawn_offset = self._spawn_offset
	local spawn_node = self._spawn_node
	local explosion_position

	if spawn_node and spawn_node ~= "" and Unit.has_node(unit, spawn_node) then
		explosion_position = Unit.world_position(unit, Unit.node(unit, spawn_node))
	else
		explosion_position = Unit.local_position(unit, 1)
	end

	explosion_position = explosion_position + spawn_offset:unbox()

	local attack_type = AttackSettings.attack_types.explosion
	local is_critical_strike = false
	local ignore_cover = self._ignore_cover
	local item_or_nil, origin_slot_or_nil, optional_hit_units_table, optional_attacking_unit_owner_unit, optional_apply_owner_buffs
	local predicted = false

	Explosion.create_explosion(world, physics_world, explosion_position, Vector3.up(), unit, explosion_template, power_level, charge_level, attack_type, is_critical_strike, ignore_cover, item_or_nil, origin_slot_or_nil, optional_hit_units_table, optional_attacking_unit_owner_unit, optional_apply_owner_buffs, predicted)
end

ExplosionSpawner.component_data = {
	explosion_template_name = {
		ui_type = "text_box",
		value = "explosive_barrel",
		ui_name = "Explosion Template Name"
	},
	power_level = {
		ui_type = "number",
		decimals = 0,
		value = 500,
		ui_name = "Power Level",
		step = 1
	},
	charge_level = {
		ui_type = "number",
		decimals = 3,
		value = 1,
		ui_name = "Charge Level",
		step = 0.05
	},
	spawn_offset = {
		ui_type = "vector",
		ui_name = "Spawn Offset",
		step = 0.1,
		value = Vector3Box(0, 0, 0)
	},
	spawn_node = {
		ui_type = "text_box",
		value = "",
		ui_name = "Spawn Node"
	},
	ignore_cover = {
		ui_type = "check_box",
		value = false,
		ui_name = "Ignore Cover"
	},
	inputs = {
		create_explosion = {
			accessibility = "private",
			type = "event"
		}
	},
	extensions = {}
}

return ExplosionSpawner
