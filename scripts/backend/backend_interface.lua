﻿-- chunkname: @scripts/backend/backend_interface.lua

local Characters = require("scripts/backend/characters")
local MissionBoard = require("scripts/backend/mission_board")
local MissionHappenings = require("scripts/backend/mission_happenings")
local Account = require("scripts/backend/account")
local Hordes = require("scripts/backend/hordes")
local GameplaySession = require("scripts/backend/gameplay_session")
local HubSession = require("scripts/backend/hub_session")
local Gear = require("scripts/backend/gear")
local MasterData = require("scripts/backend/master_data")
local Matchmaker = require("scripts/backend/matchmaker")
local Progression = require("scripts/backend/progression")
local Store = require("scripts/backend/store")
local Wallet = require("scripts/backend/wallet")
local VersionChecker = require("scripts/backend/version_check")
local Social = require("scripts/backend/social")
local Contracts = require("scripts/backend/contracts")
local GameSettings = require("scripts/backend/game_settings")
local Immaterium = require("scripts/backend/immaterium")
local Commendations = require("scripts/backend/commendations")
local ExternalPayment = require("scripts/backend/external_payment")
local RegionLatency = require("scripts/backend/region_latency")
local MailBox = require("scripts/backend/mailbox")
local Wintracks = require("scripts/backend/wintracks")
local Crafting = require("scripts/backend/crafting")
local PlayerRewards = require("scripts/backend/player_rewards")
local Tracks = require("scripts/backend/tracks")
local Mastery = require("scripts/backend/mastery")
local Orders = require("scripts/backend/orders")
local Havoc = require("scripts/backend/havoc")
local BackendInterface = class("BackendInterface")

BackendInterface.init = function (self)
	self.characters = Characters:new()
	self.mission_board = MissionBoard:new()
	self.mission_happenings = MissionHappenings:new()
	self.account = Account:new()
	self.hordes = Hordes:new()
	self.gameplay_session = GameplaySession:new()
	self.hub_session = HubSession:new()
	self.gear = Gear:new()
	self.master_data = MasterData:new()
	self.matchmaker = Matchmaker:new()
	self.progression = Progression:new()
	self.store = Store:new()
	self.wallet = Wallet:new()
	self.version_check = VersionChecker:new()
	self.social = Social:new()
	self.contracts = Contracts:new()
	self.game_settings = GameSettings:new()
	self.immaterium = Immaterium:new()
	self.commendations = Commendations:new()
	self.external_payment = ExternalPayment:new()
	self.region_latency = RegionLatency:new()
	self.mailbox = MailBox:new()
	self.wintracks = Wintracks:new()
	self.crafting = Crafting:new()
	self.player_rewards = PlayerRewards:new()
	self.tracks = Tracks:new()
	self.mastery = Mastery:new()
	self.orders = Orders:new()
	self.havoc = Havoc:new()
end

return BackendInterface
