local BallisticRaycastPositionFinderActionModule = require("scripts/extension_systems/weapon/actions/modules/ballistic_raycast_position_finder_action_module")
local ChainLightningTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/chain_lightning_targeting_action_module")
local ClosestTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/closest_targeting_action_module")
local PsykerChainLightningSingleTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/psyker_chain_lightning_single_targeting_action_module")
local PsykerSmiteTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/psyker_smite_targeting_action_module")
local RaycastTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/raycast_targeting_action_module")
local SmartTargetingActionModule = require("scripts/extension_systems/weapon/actions/modules/smart_targeting_action_module")
local ChargeActionModule = require("scripts/extension_systems/weapon/actions/modules/charge_action_module")
local OverheatActionModule = require("scripts/extension_systems/weapon/actions/modules/overheat_action_module")
local WarpChargeActionModule = require("scripts/extension_systems/weapon/actions/modules/warp_charge_action_module")
local action_modules = {
	ballistic_raycast_position_finder = BallisticRaycastPositionFinderActionModule,
	chain_lightning = ChainLightningTargetingActionModule,
	charge = ChargeActionModule,
	closest_targeting = ClosestTargetingActionModule,
	overheat = OverheatActionModule,
	psyker_chain_lightning_single_targeting = PsykerChainLightningSingleTargetingActionModule,
	psyker_smite_targeting = PsykerSmiteTargetingActionModule,
	raycast_targeting = RaycastTargetingActionModule,
	smart_target_targeting = SmartTargetingActionModule,
	warp_charge = WarpChargeActionModule
}

return settings("ActionModules", action_modules)
