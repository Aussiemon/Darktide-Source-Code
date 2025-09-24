-- chunkname: @scripts/settings/buff/weapon_traits_buff_templates/weapon_trait_buff_templates.lua

local Ammo = require("scripts/utilities/ammo")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CheckProcFunctions = require("scripts/settings/buff/helper_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/helper_functions/conditional_functions")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local WarpCharge = require("scripts/utilities/warp_charge")
local attack_results = AttackSettings.attack_results
local damage_types = DamageSettings.damage_types
local buff_keywords = BuffSettings.keywords
local buff_stat_buffs = BuffSettings.stat_buffs
local buff_proc_events = BuffSettings.proc_events
local templates = {}

table.make_unique(templates)

return templates
