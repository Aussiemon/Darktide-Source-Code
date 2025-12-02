-- chunkname: @scripts/settings/damage/impact_fx_parser.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local ImpactFxInjector = require("scripts/settings/damage/impact_fx_injector")
local MaterialQuerySettings = require("scripts/settings/material_query_settings")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local armor_hit_types = ArmorSettings.hit_types
local damage_types = DamageSettings.damage_types
local surface_hit_types = SurfaceMaterialSettings.hit_types
local surface_types = table.enum(unpack(MaterialQuerySettings.surface_materials))
local EMPTY_TABLE = {}
local damage_type_fx_configs = {}
local surface_material_fx_configs = {}

local function _include_impact_fx_configs(target_table, damage_or_surface_types, path)
	for damage_type_or_surface_material, _ in pairs(damage_or_surface_types) do
		local full_path = string.format(path, damage_type_or_surface_material)
		local exists = Application.can_get_resource("lua", full_path)

		if exists then
			local fx_config = require(full_path)

			target_table[damage_type_or_surface_material] = fx_config
		end
	end
end

local function _extract_armor_hit_fx(fx_type_config, hit_type)
	local fx = fx_type_config and fx_type_config[hit_type]

	if not fx then
		return nil
	end

	return table.clone(fx)
end

local function _extract_armor_hit_vfx(vfx_config, hit_type)
	local vfx, vfx_1p, vfx_3p
	local fx = vfx_config and vfx_config[hit_type]

	if fx then
		for _, vfx_entry in ipairs(fx) do
			local only_1p, only_3p = vfx_entry.only_1p, vfx_entry.only_3p

			if only_1p then
				vfx_1p = vfx_1p or {}
				vfx_1p[#vfx_1p + 1] = table.clone(vfx_entry)
				vfx_1p[#vfx_1p].only_1p = nil
				vfx_1p[#vfx_1p].only_3p = nil
			elseif only_3p then
				vfx_3p = vfx_3p or {}
				vfx_3p[#vfx_3p + 1] = table.clone(vfx_entry)
				vfx_3p[#vfx_3p].only_1p = nil
				vfx_3p[#vfx_3p].only_3p = nil
			else
				vfx = vfx or {}
				vfx[#vfx + 1] = table.clone(vfx_entry)
				vfx[#vfx].only_1p = nil
				vfx[#vfx].only_3p = nil
			end
		end
	end

	return vfx, vfx_1p, vfx_3p
end

local function _extract_armor_hit_sfx(sfx_config, hit_type)
	local sfx, sfx_husk, sfx_1p, sfx_3p, sfx_1p_direction_interface
	local fx = sfx_config and sfx_config[hit_type]

	if fx then
		for _, sfx_entry in ipairs(fx) do
			local event_name = sfx_entry.event

			if sfx_entry.only_1p then
				sfx_1p = sfx_1p or {}
				sfx_1p[#sfx_1p + 1] = event_name
			elseif sfx_entry.only_3p then
				sfx_3p = sfx_3p or {}
				sfx_3p[#sfx_3p + 1] = event_name
			elseif sfx_entry.hit_direction_interface then
				sfx_1p_direction_interface = sfx_1p_direction_interface or {}
				sfx_1p_direction_interface[#sfx_1p_direction_interface + 1] = event_name
			else
				sfx = sfx or {}
				sfx[#sfx + 1] = event_name

				if sfx_entry.append_husk_to_event_name then
					sfx_husk = sfx_husk or {}
					sfx_husk[#sfx_husk + 1] = event_name .. "_husk"
				end
			end
		end
	end

	return sfx, sfx_husk, sfx_1p, sfx_1p_direction_interface, sfx_3p
end

local function _target_sfx_table(parent_table, sfx_entry)
	if sfx_entry.normal_rotation then
		if not parent_table.normal_rotation then
			parent_table.normal_rotation = {}
		end

		return parent_table.normal_rotation
	else
		if not parent_table.attack_rotation then
			parent_table.attack_rotation = {}
		end

		return parent_table.attack_rotation
	end
end

local temp_table = {}

local function _create_surface_impact_fx_entry(material_type, damage_fx, material_fx, decal)
	local fx_table = {}

	if not damage_fx then
		return fx_table
	end

	local sfx, material_switch_sfx, sfx_husk, material_switch_sfx_husk

	if damage_fx.sfx or material_fx.sfx then
		table.clear(temp_table)
		table.append(temp_table, damage_fx.sfx or EMPTY_TABLE)
		table.append(temp_table, material_fx.sfx or EMPTY_TABLE)

		for _, sfx_entry in ipairs(temp_table) do
			if sfx_entry.group then
				material_switch_sfx = material_switch_sfx or {}

				local table_to_use = _target_sfx_table(material_switch_sfx, sfx_entry)

				table_to_use[#table_to_use + 1] = table.clone(sfx_entry)
				table_to_use[#table_to_use].append_husk_to_event_name = nil
				table_to_use[#table_to_use].state = material_type

				if sfx_entry.append_husk_to_event_name then
					material_switch_sfx_husk = material_switch_sfx_husk or {}

					local husk_table_to_use = _target_sfx_table(material_switch_sfx_husk, sfx_entry)
					local husk_event_name = sfx_entry.event .. "_husk"

					husk_table_to_use[#husk_table_to_use + 1] = table.clone(sfx_entry)
					husk_table_to_use[#husk_table_to_use].event = husk_event_name
					husk_table_to_use[#husk_table_to_use].append_husk_to_event_name = nil
					husk_table_to_use[#husk_table_to_use].state = material_type
				end
			else
				sfx = sfx or {}

				local event_name = sfx_entry.event
				local table_to_use = _target_sfx_table(sfx, sfx_entry)

				table_to_use[#table_to_use + 1] = event_name

				if sfx_entry.append_husk_to_event_name then
					sfx_husk = sfx_husk or {}

					local husk_table_to_use = _target_sfx_table(sfx_husk, sfx_entry)

					husk_table_to_use[#husk_table_to_use + 1] = event_name .. "_husk"
				end
			end
		end
	end

	if damage_fx.vfx or material_fx.vfx then
		fx_table.vfx = {}

		table.append(fx_table.vfx, table.clone(damage_fx.vfx or EMPTY_TABLE))
		table.append(fx_table.vfx, table.clone(material_fx.vfx or EMPTY_TABLE))
	end

	if damage_fx.unit or material_fx.unit then
		fx_table.unit = {}

		table.append(fx_table.unit, table.clone(damage_fx.unit or EMPTY_TABLE))
		table.append(fx_table.unit, table.clone(material_fx.unit or EMPTY_TABLE))
	end

	fx_table.sfx = sfx
	fx_table.material_switch_sfx = material_switch_sfx
	fx_table.sfx_husk = sfx_husk
	fx_table.material_switch_sfx_husk = material_switch_sfx_husk
	fx_table.decal = decal

	return fx_table
end

local function _add_impact_fx_to_lookup(lookup_table, impact_fx_type, damage_type, armor_or_material_type, hit_type, fx_table)
	if not lookup_table[damage_type] then
		lookup_table[damage_type] = {}
	end

	if not lookup_table[damage_type][impact_fx_type] then
		lookup_table[damage_type][impact_fx_type] = {}
	end

	if not lookup_table[damage_type][impact_fx_type][armor_or_material_type] then
		lookup_table[damage_type][impact_fx_type][armor_or_material_type] = {}
	end

	lookup_table[damage_type][impact_fx_type][armor_or_material_type][hit_type] = fx_table
end

local function _create_armor_impact_fx_templates(lookup_table, templates_table, damage_type, damage_type_fx_config)
	local armor_impact_fx = damage_type_fx_config.armor

	if armor_impact_fx then
		for armor_type, fx_config in pairs(armor_impact_fx) do
			local sfx_config = fx_config.sfx
			local vfx_config = fx_config.vfx
			local linked_decal_config = fx_config.linked_decal
			local blood_ball_config = fx_config.blood_ball

			for _, hit_type in pairs(armor_hit_types) do
				local sfx, sfx_husk, sfx_1p, sfx_1p_direction_interface, sfx_3p = _extract_armor_hit_sfx(sfx_config, hit_type)
				local vfx, vfx_1p, vfx_3p = _extract_armor_hit_vfx(vfx_config, hit_type)
				local fx_table = {
					sfx = sfx,
					sfx_husk = sfx_husk,
					sfx_1p = sfx_1p,
					sfx_1p_direction_interface = sfx_1p_direction_interface,
					sfx_3p = sfx_3p,
					vfx = vfx,
					vfx_1p = vfx_1p,
					vfx_3p = vfx_3p,
					linked_decal = _extract_armor_hit_fx(linked_decal_config, hit_type),
					blood_ball = _extract_armor_hit_fx(blood_ball_config, hit_type),
				}

				if table.size(fx_table) == 0 then
					-- Nothing
				else
					local fx_name = string.format("armor_fx_%s_%s_%s", damage_type, armor_type, hit_type)

					fx_table.name = fx_name
					templates_table[fx_name] = fx_table

					_add_impact_fx_to_lookup(lookup_table, "armor", damage_type, armor_type, hit_type, fx_table)
				end
			end
		end
	end
end

local function _create_surface_impact_fx_templates(lookup_table, templates_table, damage_type, damage_type_fx_config)
	local damage_surface_fx = damage_type_fx_config.surface or EMPTY_TABLE
	local damage_surface_fx_overrides = damage_type_fx_config.surface_overrides or EMPTY_TABLE
	local damage_surface_decal = damage_type_fx_config.surface_decal or EMPTY_TABLE

	for material_type, surface_material_fx_config in pairs(surface_material_fx_configs) do
		local surface_material_fx = damage_surface_fx[material_type] or EMPTY_TABLE
		local surface_material_fx_damage_overrides = damage_surface_fx_overrides[material_type]
		local surface_material_decal = damage_surface_decal[material_type] or EMPTY_TABLE

		for hit_type, _ in pairs(surface_hit_types) do
			local damage_fx = surface_material_fx[hit_type]
			local material_fx = surface_material_fx_damage_overrides and surface_material_fx_damage_overrides[hit_type] or surface_material_fx_config[hit_type]
			local decal = surface_material_decal[hit_type]
			local fx_table = _create_surface_impact_fx_entry(material_type, damage_fx, material_fx, decal)

			if table.size(fx_table) == 0 then
				-- Nothing
			else
				local fx_name = string.format("surface_fx_%s_%s_%s", damage_type, material_type, hit_type)

				fx_table.name = fx_name
				templates_table[fx_name] = table.clone(fx_table)

				_add_impact_fx_to_lookup(lookup_table, "material", damage_type, material_type, hit_type, fx_table)
			end
		end
	end
end

local running_from_batch = rawget(_G, "arg") ~= nil

if not running_from_batch then
	_include_impact_fx_configs(damage_type_fx_configs, damage_types, "scripts/settings/impact_fx/impact_fx_%s")
	_include_impact_fx_configs(surface_material_fx_configs, surface_types, "scripts/settings/impact_fx/material/material_impact_fx_%s")
end

local function parse()
	local impact_fx_lookup = {}
	local impact_fx_templates = {}

	for damage_type, fx_config in pairs(damage_type_fx_configs) do
		ImpactFxInjector.inject(damage_type, fx_config)
		_create_armor_impact_fx_templates(impact_fx_lookup, impact_fx_templates, damage_type, fx_config)
		_create_surface_impact_fx_templates(impact_fx_lookup, impact_fx_templates, damage_type, fx_config)
	end

	return impact_fx_lookup, impact_fx_templates
end

return parse
