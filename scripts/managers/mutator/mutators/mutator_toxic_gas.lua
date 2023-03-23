require("scripts/managers/mutator/mutators/mutator_base")

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local attack_types = AttackSettings.attack_types
local MutatorToxicGas = class("MutatorToxicGas", "MutatorBase")

MutatorToxicGas.init = function (self, is_server, network_event_delegate, mutator_template, nav_world)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = true
	self._buffs = {}
	self._template = mutator_template
	self._gas_clouds = {}
	self._nav_world = nav_world
end

local CLOUD_TICK_FREQUENCY = 0.5

MutatorToxicGas.on_gameplay_post_init = function (self, level, themes)
	local is_main_path_available = Managers.state.main_path:is_main_path_available()

	if not is_main_path_available then
		return
	end

	local gas_settings = self._template.gas_settings
	local num_gas_clouds = gas_settings.num_gas_clouds
	local total_path_distance = MainPathQueries.total_path_distance()
	local path_distance_per_cloud = total_path_distance / num_gas_clouds

	for i = 1, num_gas_clouds do
		if not self._gas_clouds[i] then
			self._gas_clouds[#self._gas_clouds + 1] = {}
		end

		local gas_cloud = self._gas_clouds[i]
		local wanted_position = MainPathQueries.position_from_distance(path_distance_per_cloud * i)
		local liquid_area_template = LiquidAreaTemplates.toxic_gas

		LiquidArea.try_create(wanted_position, Vector3(0, 0, 1), self._nav_world, liquid_area_template)
	end

	self._next_cloud_tick = CLOUD_TICK_FREQUENCY
	self._players_dealt_damage_to = {}
end

local CORRUPTION_DAMAGE_TYPE = "corruption"
local CORRUPTION_PERMANENT_POWER_LEVEL = {
	5,
	5,
	8,
	12,
	20
}

MutatorToxicGas.update = function (self, dt, t)
	return
end

return MutatorToxicGas
