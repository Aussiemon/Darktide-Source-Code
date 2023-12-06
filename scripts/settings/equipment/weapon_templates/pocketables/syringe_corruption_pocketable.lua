local syringe_pocketable_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/syringe_pocketable_weapon_template_generator")
local Breed = require("scripts/utilities/breed")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local buff_name = "syringe_heal_corruption_buff"

local function validate_target_func(target_unit)
	if not Breed.is_player(Breed.unit_breed_or_nil(target_unit)) then
		return false
	end

	local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")

	if character_state_component and PlayerUnitStatus.is_disabled(character_state_component) then
		return false
	end

	local health_extension = target_unit and ScriptUnit.has_extension(target_unit, "health_system")
	local current_health_percent = health_extension and health_extension:current_health_percent()
	local can_use = current_health_percent and current_health_percent < 1

	return can_use
end

local hud_icon = "content/ui/materials/icons/pocketables/hud/syringe"
local hud_icon_small = "content/ui/materials/icons/pocketables/hud/small/party_syringe_corruption"
local pickup_name = "syringe_corruption_pocketable"
local assist_notification_type = "cleansed"
local vo_event = nil
local weapon_template = syringe_pocketable_weapon_template_generator(buff_name, validate_target_func, hud_icon, hud_icon_small, pickup_name, assist_notification_type, vo_event)

return weapon_template
