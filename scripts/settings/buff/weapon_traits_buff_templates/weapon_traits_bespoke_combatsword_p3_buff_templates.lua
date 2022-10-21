local Ammo = require("scripts/utilities/ammo")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffUtils = require("scripts/settings/buff/buff_utils")
local CheckProcFunctions = require("scripts/settings/buff/validation_functions/check_proc_functions")
local ConditionalFunctions = require("scripts/settings/buff/validation_functions/conditional_functions")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Health = require("scripts/utilities/health")
local PlayerUnitAction = require("scripts/extension_systems/visual_loadout/utilities/player_unit_action")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Suppression = require("scripts/utilities/attack/suppression")
local Toughness = require("scripts/utilities/toughness/toughness")
local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local WarpCharge = require("scripts/utilities/warp_charge")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local keywords = BuffSettings.keywords
local stat_buffs = BuffSettings.stat_buffs
local proc_events = BuffSettings.proc_events
local replenish_types = ToughnessSettings.replenish_types
local templates = {}

return templates
