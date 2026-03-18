-- chunkname: @scripts/components/explosive_on_impact.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local ExplosiveOnImpact = component("ExplosiveOnImpact")

ExplosiveOnImpact.init = function (self, unit, is_server)
	self._is_server = is_server
	self._unit = unit
	self._power_level = self:get_data(unit, "power_level")
	self._charge_level = self:get_data(unit, "charge_level")

	local explosion_template_name = self:get_data(unit, "explosion_template_name")

	self._exploded = false
	self._explosion_template = ExplosionTemplates[explosion_template_name]

	local world = Managers.world:world("level_world")

	self._world = world

	local physics_world = World.physics_world(world)

	self._physics_world = physics_world

	if self._is_server and Managers and Managers.state then
		Managers.state.out_of_bounds:register_soft_oob_unit(unit, self, "_on_unit_out_of_bounds")
	end

	local run_update = true

	return run_update
end

ExplosiveOnImpact._on_unit_out_of_bounds = function (self, unit)
	local destructible_extension = ScriptUnit.has_extension(unit, "destructible_system")

	if destructible_extension == nil then
		Managers.state.unit_spawner:mark_for_deletion(unit)
	end
end

ExplosiveOnImpact.editor_init = function (self, unit)
	return
end

ExplosiveOnImpact.editor_validate = function (self, unit)
	return true, ""
end

ExplosiveOnImpact._play_sfx = function (self, event)
	local wwise_world = self._wwise_world

	WwiseWorld.trigger_resource_event(wwise_world, event, self._source_id)
end

ExplosiveOnImpact.update = function (self, unit, dt, t)
	return true
end

ExplosiveOnImpact.events.add_damage = function (self, damage, hit_actor, attack_direction)
	return
end

ExplosiveOnImpact._create_explosion = function (self)
	if not self._exploded then
		local attack_type = AttackSettings.attack_types.explosion
		local unit = self._unit
		local explosion_position = Unit.local_position(unit, 1)
		local power_level = self._power_level
		local charge_level = self._charge_level

		self._exploded = true

		Explosion.create_explosion(self._world, self._physics_world, explosion_position, Vector3.up(), unit, self._explosion_template, power_level, charge_level, attack_type)
	end
end

ExplosiveOnImpact.enable = function (self, unit)
	return
end

ExplosiveOnImpact.disable = function (self, unit)
	return
end

ExplosiveOnImpact.destroy = function (self, unit)
	local source_id = self._source_id

	if source_id then
		WwiseWorld.destroy_manual_source(self._wwise_world, source_id)
	end

	if self._is_server and Managers and Managers.state then
		Managers.state.out_of_bounds:unregister_soft_oob_unit(unit, self)
	end
end

ExplosiveOnImpact.detonate = function (self)
	self:_create_explosion()

	local unit = self._unit
	local world = self._world

	if self._is_server then
		Managers.state.unit_spawner:mark_for_deletion(unit)
	end
end

ExplosiveOnImpact.component_data = {
	explosion_template_name = {
		ui_name = "Explosion Template Name",
		ui_type = "combo_box",
		value = "explosive_barrel",
		options_keys = {
			"expedition_airstrike_nuke",
			"explosive_barrel",
			"fire_barrel",
		},
		options_values = {
			"expedition_airstrike_nuke",
			"explosive_barrel",
			"fire_barrel",
		},
	},
	power_level = {
		decimals = 0,
		step = 1,
		ui_name = "Power Level",
		ui_type = "number",
		value = 1000,
	},
	charge_level = {
		decimals = 0,
		step = 1,
		ui_name = "Charge Level",
		ui_type = "number",
		value = 1,
	},
	inputs = {
		detonate = {
			accessibility = "public",
			type = "event",
		},
	},
}

return ExplosiveOnImpact
