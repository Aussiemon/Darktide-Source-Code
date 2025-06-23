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
		value = 100,
		min = 0,
		step = 1,
		category = "Base Data",
		ui_type = "number",
		decimals = 0,
		ui_name = "Base Health",
		max = 4000
	},
	difficulty_scaling = {
		ui_type = "check_box",
		value = false,
		ui_name = "Difficulty Scaling",
		category = "Base Data"
	},
	create_game_object = {
		ui_type = "check_box",
		value = false,
		ui_name = "Sync Health to Clients",
		category = "Base Data"
	},
	invulnerable = {
		ui_type = "check_box",
		value = false,
		ui_name = "Invulnerable",
		category = "Base Data"
	},
	unkillable = {
		ui_type = "check_box",
		value = false,
		ui_name = "Unkillable",
		category = "Base Data"
	},
	regenerate_health = {
		ui_type = "check_box",
		value = false,
		ui_name = "Regenerate Health",
		category = "DO NOT USE - IS HACK"
	},
	hit_mass = {
		ui_type = "number",
		value = 0,
		ui_name = "Hit Mass",
		category = "Base Data"
	},
	breed_white_list = {
		ui_type = "text_box_array",
		is_optional = true,
		ui_name = "Breed Whitelist",
		category = "Ignores"
	},
	ignored_colliders = {
		ui_type = "text_box_array",
		is_optional = true,
		ui_name = "Ignored Colliders",
		category = "Ignores"
	},
	speed_on_hit = {
		ui_type = "number",
		min = 0,
		category = "Debris",
		value = 5,
		ui_name = "Impulse Speed on Hit"
	},
	inputs = {
		prop_health_set_invulnerable = {
			accessibility = "public",
			type = "event"
		},
		prop_health_set_vulnerable = {
			accessibility = "public",
			type = "event"
		},
		prop_health_kill = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"PropHealthExtension"
	}
}

return PropHealth
