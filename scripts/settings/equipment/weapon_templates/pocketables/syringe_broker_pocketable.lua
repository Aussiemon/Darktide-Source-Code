-- chunkname: @scripts/settings/equipment/weapon_templates/pocketables/syringe_broker_pocketable.lua

local syringe_pocketable_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/syringe_pocketable_weapon_template_generator")
local Breed = require("scripts/utilities/breed")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local buff_name = "syringe_broker_buff"

local function validate_target_func(target_unit)
	if not Breed.is_player(Breed.unit_breed_or_nil(target_unit)) then
		return false
	end

	local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")

	if character_state_component and PlayerUnitStatus.is_disabled(character_state_component) then
		return false
	end

	return true
end

local hud_icon_small = "content/ui/materials/icons/pocketables/hud/small/party_syringe_power"
local pickup_name = "syringe_broker_pocketable"
local assist_notification_type = "stimmed"
local vo_event
local consume_on_use = false
local givable = false
local use_ability_charge = true
local undroppable = true
local auto_use = true
local weapon_template = syringe_pocketable_weapon_template_generator(buff_name, validate_target_func, hud_icon_small, pickup_name, assist_notification_type, vo_event, consume_on_use, givable, use_ability_charge, undroppable, auto_use)

table.insert(weapon_template.keywords, "pocketable_broker_syringe")

return weapon_template
