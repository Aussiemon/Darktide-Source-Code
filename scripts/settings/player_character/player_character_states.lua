﻿-- chunkname: @scripts/settings/player_character/player_character_states.lua

local PlayerCharacterStateCatapulted = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_catapulted")
local PlayerCharacterStateConsumed = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_consumed")
local PlayerCharacterStateDead = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_dead")
local PlayerCharacterStateDodging = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_dodging")
local PlayerCharacterStateExploding = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_exploding")
local PlayerCharacterStateFalling = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_falling")
local PlayerCharacterStateGrabbed = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_grabbed")
local PlayerCharacterStateHogtied = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_hogtied")
local PlayerCharacterStateHubEmote = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_hub_emote")
local PlayerCharacterStateHubJog = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_hub_jog")
local PlayerCharacterStateInteracting = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_interacting")
local PlayerCharacterStateJumping = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_jumping")
local PlayerCharacterStateKnockedDown = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_knocked_down")
local PlayerCharacterStateLadderClimbing = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_ladder_climbing")
local PlayerCharacterStateLadderTopEntering = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_ladder_top_entering")
local PlayerCharacterStateLadderTopLeaving = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_ladder_top_leaving")
local PlayerCharacterStateLedgeHanging = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_ledge_hanging")
local PlayerCharacterStateLedgeHangingFalling = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_ledge_hanging_falling")
local PlayerCharacterStateLedgeHangingPullUp = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_ledge_hanging_pull_up")
local PlayerCharacterStateLedgeVaulting = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_ledge_vaulting")
local PlayerCharacterStateLunging = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_lunging")
local PlayerCharacterStateMinigame = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_minigame")
local PlayerCharacterStateMutantCharged = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_mutant_charged")
local PlayerCharacterStateNetted = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_netted")
local PlayerCharacterStatePounced = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_pounced")
local PlayerCharacterStateSliding = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_sliding")
local PlayerCharacterStateSprinting = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_sprinting")
local PlayerCharacterStateStunned = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_stunned")
local PlayerCharacterStateWalking = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_walking")
local PlayerCharacterStateWarpGrabbed = require("scripts/extension_systems/character_state_machine/character_states/player_character_state_warp_grabbed")
local class_list = {
	catapulted = PlayerCharacterStateCatapulted,
	consumed = PlayerCharacterStateConsumed,
	dead = PlayerCharacterStateDead,
	dodging = PlayerCharacterStateDodging,
	exploding = PlayerCharacterStateExploding,
	falling = PlayerCharacterStateFalling,
	grabbed = PlayerCharacterStateGrabbed,
	hogtied = PlayerCharacterStateHogtied,
	hub_emote = PlayerCharacterStateHubEmote,
	hub_jog = PlayerCharacterStateHubJog,
	interacting = PlayerCharacterStateInteracting,
	jumping = PlayerCharacterStateJumping,
	knocked_down = PlayerCharacterStateKnockedDown,
	ladder_climbing = PlayerCharacterStateLadderClimbing,
	ladder_top_entering = PlayerCharacterStateLadderTopEntering,
	ladder_top_leaving = PlayerCharacterStateLadderTopLeaving,
	ledge_hanging = PlayerCharacterStateLedgeHanging,
	ledge_hanging_falling = PlayerCharacterStateLedgeHangingFalling,
	ledge_hanging_pull_up = PlayerCharacterStateLedgeHangingPullUp,
	ledge_vaulting = PlayerCharacterStateLedgeVaulting,
	lunging = PlayerCharacterStateLunging,
	minigame = PlayerCharacterStateMinigame,
	mutant_charged = PlayerCharacterStateMutantCharged,
	netted = PlayerCharacterStateNetted,
	pounced = PlayerCharacterStatePounced,
	sliding = PlayerCharacterStateSliding,
	sprinting = PlayerCharacterStateSprinting,
	stunned = PlayerCharacterStateStunned,
	walking = PlayerCharacterStateWalking,
	warp_grabbed = PlayerCharacterStateWarpGrabbed
}

return settings("PlayerCharacterStates", class_list)
