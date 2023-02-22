require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/aim_luggable_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/aim_projectile_ads_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/aim_projectile_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/ammo_belt")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/ammo_count_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/auspex_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/auspex_scanning_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_lightning_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_weapon_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/charge_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/device")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/flamer_gas_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/flamer_pilot_light_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/flashlight")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_staff_aoe_targeting_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_block_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/grimoire_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/holo_sight")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/lasgun_ammo_display")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/lasgun_iron_sight")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/luggable")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/magazine_ammo")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/melee_ideling_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/overheat_display")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/plasmagun_overheat_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/power_weapon_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/psyker_chain_lightning_target_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/psyker_single_target_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/servo_skull_hover")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/skull_decoder_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/sticky_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/sweep_trail")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/syringe_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/target_units")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/thunder_hammer_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/warp_charge_venting_effects")
require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/weapon_temperature_effects")

local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WieldableSlotScripts = {}

WieldableSlotScripts.create = function (wieldable_slot_scripts_context, wieldable_slot_scripts, fx_sources, slot, item)
	local item_wieldable_slot_scripts = item.wieldable_slot_scripts

	if not item_wieldable_slot_scripts then
		return
	end

	local num_scripts = #item_wieldable_slot_scripts

	for ii = 1, num_scripts do
		local script_name = item_wieldable_slot_scripts[ii]
		local script_class = CLASSES[script_name]

		if script_class then
			local weapon_template = WeaponTemplate.weapon_template_from_item(item)
			local script = script_class:new(wieldable_slot_scripts_context, slot, weapon_template, fx_sources, item)
			wieldable_slot_scripts[slot.name][ii] = script
		end
	end
end

WieldableSlotScripts.destroy = function (wieldable_slot_scripts)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		wieldable_slot_script:destroy()
	end
end

WieldableSlotScripts.extensions_ready = function (wieldable_slot_scripts_per_slot)
	for _, wieldable_slot_scripts in pairs(wieldable_slot_scripts_per_slot) do
		local num_scripts = #wieldable_slot_scripts

		for ii = 1, num_scripts do
			local wieldable_slot_script = wieldable_slot_scripts[ii]

			if wieldable_slot_script.extensions_ready then
				wieldable_slot_script:extensions_ready()
			end
		end
	end
end

WieldableSlotScripts.update = function (wieldable_slot_scripts, unit, dt, t)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.update then
			wieldable_slot_script:update(unit, dt, t)
		end
	end
end

WieldableSlotScripts.fixed_update = function (wieldable_slot_scripts, unit, dt, t)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.fixed_update then
			wieldable_slot_script:fixed_update(unit, dt, t)
		end
	end
end

WieldableSlotScripts.post_update = function (wieldable_slot_scripts, unit, dt, t)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.post_update then
			wieldable_slot_script:post_update(unit, dt, t)
		end
	end
end

WieldableSlotScripts.update_unit_position = function (wieldable_slot_scripts, unit, dt, t)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		if wieldable_slot_script.update_unit_position then
			wieldable_slot_script:update_unit_position(unit, dt, t)
		end
	end
end

WieldableSlotScripts.wield = function (wieldable_slot_scripts)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		wieldable_slot_script:wield()
	end
end

WieldableSlotScripts.unwield = function (wieldable_slot_scripts)
	local num_scripts = #wieldable_slot_scripts

	for ii = 1, num_scripts do
		local wieldable_slot_script = wieldable_slot_scripts[ii]

		wieldable_slot_script:unwield()
	end
end

return WieldableSlotScripts
