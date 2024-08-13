-- chunkname: @scripts/managers/stats/utility/stats_circumstance_util.lua

local circumstances = {}

local function _create_circumstance_entry(path)
	local _circumstance_data = require(path)

	for circumstance, data in pairs(_circumstance_data) do
		circumstances[circumstance] = data.mutators
	end
end

_create_circumstance_entry("scripts/settings/circumstance/templates/flash_mission_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/assault_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/darkness_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/default_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/dummy_resistance_changes_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/ember_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/extra_trickle_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/hub_skulls_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/hunting_grounds_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/more_hordes_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/more_monsters_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/more_specials_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/more_witches_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/noir_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/nurgle_manifestation_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/resistance_changes_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/stealth_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/toxic_gas_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/ventilation_purge_circumstance_template")
_create_circumstance_entry("scripts/settings/circumstance/templates/live_event_circumstance_template")

return settings("circumstances", circumstances)
