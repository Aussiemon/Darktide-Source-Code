-- chunkname: @scripts/components/prop_health.lua

local Attack = require("scripts/utilities/attack/attack")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local PropHealth = component("PropHealth")

PropHealth.init = function (self, unit, is_server)
	self._unit = unit
	self._is_server = is_server

	Unit.set_data(unit, "hit_mass", self:get_data(unit, "hit_mass"))

	local health_extension = ScriptUnit.fetch_component_extension(unit, "health_system")

	if health_extension then
		local health = self:get_data(unit, "max_health")
		local difficulty_scaling = self:get_data(unit, "difficulty_scaling")
		local create_game_object = self:get_data(unit, "create_game_object")
		local invulnerable = self:get_data(unit, "invulnerable")
		local unkillable = self:get_data(unit, "unkillable")
		local regenerate_health = self:get_data(unit, "regenerate_health")
		local breed_white_list = self:get_data(unit, "breed_white_list")
		local ignored_collider_actor_names = self:get_data(unit, "ignored_colliders")
		local speed_on_hit = self:get_data(unit, "speed_on_hit")

		health_extension:setup_from_component(create_game_object, health, difficulty_scaling, invulnerable, unkillable, regenerate_health, breed_white_list, ignored_collider_actor_names, speed_on_hit)

		self._health_extension = health_extension
	end
end

PropHealth.editor_init = function (self)
	return
end

PropHealth.editor_validate = function (self, unit)
	return true, ""
end

PropHealth.enable = function (self, unit)
	return
end

PropHealth.disable = function (self, unit)
	return
end

PropHealth.destroy = function (self, unit)
	return
end

PropHealth.prop_health_set_invulnerable = function (self)
	local health_extension = self._health_extension

	if health_extension then
		health_extension:set_invulnerable(true)
	end
end

PropHealth.prop_health_set_vulnerable = function (self)
	local health_extension = self._health_extension

	if health_extension then
		health_extension:set_invulnerable(false)
	end
end

PropHealth.prop_health_kill = function (self)
	local health_extension = self._health_extension

	if self._is_server and health_extension then
		health_extension:set_invulnerable(false)
		health_extension:set_unkillable(false)

		local damage_profile = DamageProfileTemplates.default

		Attack.execute(self._unit, damage_profile, "instakill", true)
	end
end

PropHealth.component_data = {
	max_health = {
		category = "Base Data",
		decimals = 0,
		max = 4000,
		min = 0,
		step = 1,
		ui_name = "Base Health",
		ui_type = "number",
		value = 100,
	},
	difficulty_scaling = {
		category = "Base Data",
		ui_name = "Difficulty Scaling",
		ui_type = "check_box",
		value = false,
	},
	create_game_object = {
		category = "Base Data",
		ui_name = "Sync Health to Clients",
		ui_type = "check_box",
		value = false,
	},
	invulnerable = {
		category = "Base Data",
		ui_name = "Invulnerable",
		ui_type = "check_box",
		value = false,
	},
	unkillable = {
		category = "Base Data",
		ui_name = "Unkillable",
		ui_type = "check_box",
		value = false,
	},
	regenerate_health = {
		category = "DO NOT USE - IS HACK",
		ui_name = "Regenerate Health",
		ui_type = "check_box",
		value = false,
	},
	hit_mass = {
		category = "Base Data",
		ui_name = "Hit Mass",
		ui_type = "number",
		value = 0,
	},
	breed_white_list = {
		category = "Ignores",
		is_optional = true,
		ui_name = "Breed Whitelist",
		ui_type = "text_box_array",
	},
	ignored_colliders = {
		category = "Ignores",
		is_optional = true,
		ui_name = "Ignored Colliders",
		ui_type = "text_box_array",
	},
	speed_on_hit = {
		category = "Debris",
		min = 0,
		ui_name = "Impulse Speed on Hit",
		ui_type = "number",
		value = 5,
	},
	inputs = {
		prop_health_set_invulnerable = {
			accessibility = "public",
			type = "event",
		},
		prop_health_set_vulnerable = {
			accessibility = "public",
			type = "event",
		},
		prop_health_kill = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"PropHealthExtension",
	},
}

return PropHealth
