-- chunkname: @scripts/extension_systems/visual_loadout/utilities/equipped_slot_scripts.lua

require("scripts/extension_systems/visual_loadout/equipped_slot_scripts/equipped_health_bar_gauge")

local MasterItems = require("scripts/backend/master_items")
local EquippedSlotScripts = {}
local _slot_scripts_to_create = {}
local SCRIPT_INDEX = table.mirror_array({
	"SCRIPT_NAME",
	"UNIT_1P",
	"UNIT_3P",
	"STRIDE",
})

EquippedSlotScripts._register_script = function (script_name, unit_1p, unit_3p, num_scripts)
	if script_name == "" then
		return num_scripts
	end

	local n = num_scripts * SCRIPT_INDEX.STRIDE

	_slot_scripts_to_create[n + SCRIPT_INDEX.SCRIPT_NAME] = script_name
	_slot_scripts_to_create[n + SCRIPT_INDEX.UNIT_1P] = not not unit_1p and unit_1p or false
	_slot_scripts_to_create[n + SCRIPT_INDEX.UNIT_3P] = unit_3p

	return num_scripts + 1
end

EquippedSlotScripts.create = function (equipped_slot_scripts_context, equipped_slot_scripts, fx_sources, slot)
	local num_scripts = 0
	local root_unit_1p, root_unit_3p = slot.unit_1p, slot.unit_3p
	local item_definitions = MasterItems.get_cached()

	if slot.attachments_by_unit_1p then
		local attachments = slot.attachments_by_unit_1p[root_unit_1p]

		for attachment_i = 1, #attachments do
			local unit_1p = attachments[attachment_i]
			local item_name = slot.item_name_by_unit_1p[unit_1p]
			local item = item_definitions[item_name]

			if item then
				local slot_scripts = item.equipped_slot_scripts

				if slot_scripts then
					for slot_script_i = 1, #slot_scripts do
						local script_name = slot_scripts[slot_script_i]
						local attachment_path = slot.attachment_id_lookup_1p[unit_1p]
						local unit_3p = slot.attachment_id_lookup_3p[attachment_path]

						num_scripts = EquippedSlotScripts._register_script(script_name, unit_1p, unit_3p, num_scripts)
					end
				end
			end
		end
	end

	local root_item = slot.item

	if root_item then
		local slot_scripts = root_item.equipped_slot_scripts

		if slot_scripts then
			for slot_script_i = 1, #slot_scripts do
				local script_name = slot_scripts[slot_script_i]

				num_scripts = EquippedSlotScripts._register_script(script_name, root_unit_1p, root_unit_3p, num_scripts)
			end
		end
	end

	local actual_num_scripts = 0

	if num_scripts > 0 and not equipped_slot_scripts[slot.name] then
		equipped_slot_scripts[slot.name] = {}
	end

	for script_i = num_scripts, 1, -1 do
		local n = (script_i - 1) * SCRIPT_INDEX.STRIDE
		local script_name = _slot_scripts_to_create[n + SCRIPT_INDEX.SCRIPT_NAME]
		local script_class = CLASSES[script_name]

		if script_class then
			local unit_1p = _slot_scripts_to_create[n + SCRIPT_INDEX.UNIT_1P]
			local unit_3p = _slot_scripts_to_create[n + SCRIPT_INDEX.UNIT_3P]
			local script = script_class:new(equipped_slot_scripts_context, slot, fx_sources, root_item, unit_1p, unit_3p)

			actual_num_scripts = actual_num_scripts + 1
			equipped_slot_scripts[slot.name][actual_num_scripts] = script
		end
	end

	table.clear(_slot_scripts_to_create)
end

EquippedSlotScripts.destroy = function (equipped_slot_scripts)
	local num_scripts = #equipped_slot_scripts

	for ii = 1, num_scripts do
		local equipped_slot_script = equipped_slot_scripts[ii]

		equipped_slot_script:destroy()
	end
end

EquippedSlotScripts.extensions_ready = function (equipped_slot_scripts_per_slot)
	for _, equipped_slot_scripts in pairs(equipped_slot_scripts_per_slot) do
		local num_scripts = #equipped_slot_scripts

		for ii = 1, num_scripts do
			local equipped_slot_script = equipped_slot_scripts[ii]

			if equipped_slot_script.extensions_ready then
				equipped_slot_script:extensions_ready()
			end
		end
	end
end

EquippedSlotScripts.server_correction_occurred = function (equipped_slot_scripts_per_slot, unit, from_frame)
	for _, equipped_slot_scripts in pairs(equipped_slot_scripts_per_slot) do
		local num_scripts = #equipped_slot_scripts

		for ii = 1, num_scripts do
			local equipped_slot_script = equipped_slot_scripts[ii]

			if equipped_slot_script.server_correction_occurred then
				equipped_slot_script:server_correction_occurred(unit, from_frame)
			end
		end
	end
end

EquippedSlotScripts.update = function (equipped_slot_scripts, unit, dt, t)
	for _, scripts in pairs(equipped_slot_scripts) do
		for ii = 1, #scripts do
			local equipped_slot_script = scripts[ii]

			if equipped_slot_script.update then
				equipped_slot_script:update(unit, dt, t)
			end
		end
	end
end

EquippedSlotScripts.fixed_update = function (equipped_slot_scripts, unit, dt, t, frame)
	for _, scripts in pairs(equipped_slot_scripts) do
		local num_scripts = #equipped_slot_scripts

		for ii = 1, num_scripts do
			local equipped_slot_script = equipped_slot_scripts[ii]

			if equipped_slot_script.fixed_update then
				equipped_slot_script:fixed_update(unit, dt, t, frame)
			end
		end
	end
end

EquippedSlotScripts.post_update = function (equipped_slot_scripts, unit, dt, t)
	local num_scripts = #equipped_slot_scripts

	for ii = 1, num_scripts do
		local equipped_slot_script = equipped_slot_scripts[ii]

		if equipped_slot_script.post_update then
			equipped_slot_script:post_update(unit, dt, t)
		end
	end
end

EquippedSlotScripts.update_unit_position = function (equipped_slot_scripts, unit, dt, t)
	local num_scripts = #equipped_slot_scripts

	for ii = 1, num_scripts do
		local equipped_slot_script = equipped_slot_scripts[ii]

		if equipped_slot_script.update_unit_position then
			equipped_slot_script:update_unit_position(unit, dt, t)
		end
	end
end

EquippedSlotScripts.update_first_person_mode = function (equipped_slot_scripts, first_person_mode)
	local num_scripts = #equipped_slot_scripts

	for ii = 1, num_scripts do
		local equipped_slot_script = equipped_slot_scripts[ii]

		if equipped_slot_script.update_first_person_mode then
			equipped_slot_script:update_first_person_mode(first_person_mode)
		end
	end
end

EquippedSlotScripts.wield = function (equipped_slot_scripts)
	local num_scripts = #equipped_slot_scripts

	for ii = 1, num_scripts do
		local equipped_slot_script = equipped_slot_scripts[ii]

		equipped_slot_script:wield()
	end
end

EquippedSlotScripts.unwield = function (equipped_slot_scripts)
	local num_scripts = #equipped_slot_scripts

	for ii = 1, num_scripts do
		local equipped_slot_script = equipped_slot_scripts[ii]

		equipped_slot_script:unwield()
	end
end

EquippedSlotScripts.on_sweep_hit = function (equipped_slot_scripts)
	local num_scripts = #equipped_slot_scripts

	for ii = 1, num_scripts do
		local equipped_slot_script = equipped_slot_scripts[ii]

		if equipped_slot_script.on_sweep_hit then
			equipped_slot_script:on_sweep_hit()
		end
	end
end

EquippedSlotScripts.on_sweep_start = function (equipped_slot_scripts, t)
	local num_scripts = #equipped_slot_scripts

	for ii = 1, num_scripts do
		local equipped_slot_script = equipped_slot_scripts[ii]

		if equipped_slot_script.on_sweep_start then
			equipped_slot_script:on_sweep_start(t)
		end
	end
end

EquippedSlotScripts.on_sweep_finish = function (equipped_slot_scripts)
	local num_scripts = #equipped_slot_scripts

	for ii = 1, num_scripts do
		local equipped_slot_script = equipped_slot_scripts[ii]

		if equipped_slot_script.on_sweep_finish then
			equipped_slot_script:on_sweep_finish()
		end
	end
end

EquippedSlotScripts.on_exit_damage_window = function (equipped_slot_scripts)
	local num_scripts = #equipped_slot_scripts

	for ii = 1, num_scripts do
		local equipped_slot_script = equipped_slot_scripts[ii]

		if equipped_slot_script.on_exit_damage_window then
			equipped_slot_script:on_exit_damage_window()
		end
	end
end

EquippedSlotScripts.on_action = function (equipped_slot_scripts, action_settings, t)
	local num_scripts = #equipped_slot_scripts

	for ii = 1, num_scripts do
		local equipped_slot_script = equipped_slot_scripts[ii]

		if equipped_slot_script.on_action then
			equipped_slot_script:on_action(action_settings, t)
		end
	end
end

return EquippedSlotScripts
