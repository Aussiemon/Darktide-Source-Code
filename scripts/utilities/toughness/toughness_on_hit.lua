-- chunkname: @scripts/utilities/toughness/toughness_on_hit.lua

local Push = require("scripts/extension_systems/character_state_machine/character_states/utilities/push")
local PushSettings = require("scripts/settings/damage/push_settings")
local push_templates = PushSettings.push_templates
local PUSH_TEMPLATE = push_templates.toughness
local ToughnessOnHit = {}

ToughnessOnHit.push_back = function (unit, attack_direction, attack_type)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local locomotion_push_component = unit_data_extension:write_component("locomotion_push")

	Push.add(unit, locomotion_push_component, attack_direction, PUSH_TEMPLATE, attack_type)
end

return ToughnessOnHit
