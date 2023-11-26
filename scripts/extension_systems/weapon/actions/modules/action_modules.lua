-- chunkname: @scripts/extension_systems/weapon/actions/modules/action_modules.lua

local BallisticRaycastPositionFinderActionModule = require("scripts/extension_systems/weapon/actions/modules/ballistic_raycast_position_finder_action_module")
local ChainLightningTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/chain_lightning_targeting_action_module")
local ClosestTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/closest_targeting_action_module")
local PsykerSmiteTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/psyker_smite_targeting_action_module")
local PsykerChainLightningSingleTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/psyker_chainlightning_single_targeting_action_module")
local RaycastTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/raycast_targeting_action_module")
local SmartTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/smart_targeting_action_module")
local ChargeActionModule = require("scripts/extension_systems/weapon/actions/modules/charge_action_module")
local OverheatActionModule = require("scripts/extension_systems/weapon/actions/modules/overheat_action_module")
local WarpChargeActionModule = require("scripts/extension_systems/weapon/actions/modules/warp_charge_action_module")
local action_modules = {
	ballistic_raycast_position_finder = BallisticRaycastPositionFinderActionModule,
	charge = ChargeActionModule,
	chain_lightning = ChainLightningTargetingActionModule,
	closest_targeting = ClosestTargetingActionModule,
	overheat = OverheatActionModule,
	raycast_targeting = RaycastTargetingActionModule,
	smart_target_targeting = SmartTargetingActionModule,
	psyker_smite_targeting = PsykerSmiteTargetingActionModule,
	psyker_chainlightning_single_targeting = PsykerChainLightningSingleTargetingActionModule,
	warp_charge = WarpChargeActionModule
}

return settings("ActionModules", action_modules)
