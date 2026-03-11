-- ============================================================================================================ --
--	Version 0.1  
--	* Created SpecificGratz table for the configuration interface data.
--	* 
--	* Added Battleground victory messager.  TESTING
--	* Added Ding Gratz option controls.  Need to Test.
--	* Ding spam control functions added.  Testing.
--	* Ding message handler added.
--	* Adding English locales.
--	* Adding pending gratz tables.



-- * Guild gratz messages done.
-- * Battleground Victory message done.

-- Table of Contents
-- Local Fields
-- Spam Guard
-- BG Victory

-- 
-- ============================================================================================================ --
--  Version 0.6  11/27/2012
--  * Fixed the protomenu error.
--  * Updated for patch 5.1.
--  *  Party gratz seem to work.

-- Version 0.8.1

--	*  New guild gratz handler.
--  *  New local object neoPending


-- ======================================================================================================================= --
-- Local Fields
-- ======================================================================================================================= --
Gratz = LibStub("AceAddon-3.0","CallbackHandler-1.0"):NewAddon("Gratz", "AceConsole-3.0", "AceEvent-3.0" ,"AceTimer-3.0","AceHook-3.0");
local L						= LibStub("AceLocale-3.0"):GetLocale("Gratz")
local guildGratzTimer = nil;
local pendingGuildAchieves = {};
local cbh = LibStub("CallbackHandler-1.0")

local pendingList = {}
local hasSentVictoryMessageForBG = false
local dingWait = {}
local raidTimer = nil;
local guildTimer = nil;
local partyTimer = nil;
local bgTimer = nil;
local nearbyTimer = nil;
local pendingGratzTable =	{
								Raid			= {Achieves = {}, Earners = {}},
								Party			= {Achieves = {}, Earners = {}},
								Battleground	= {Achieves = {}, Earners = {}},
								Guild			= {Achieves = {}, Earners = {}},
								Nearby			= {Achieves = {}, Earners = {}}
							}

local neoPending = {
								Raid			= {Achieves = {}, Earners = {}},
								Party			= {Achieves = {}, Earners = {}},
								Battleground	= {Achieves = {}, Earners = {}},
								Guild			= {Achieves = {}, Earners = {}},
								Nearby			= {Achieves = {}, Earners = {}}
					}
								
function Gratz:RandomRangeCheck(min, max)
	if max == nil then
		return false
	end
	if min == nil then
		return false
	end
	if min > max then
		return false
	end


	return true
end
function Gratz:AddToNeoPending(chann, earner, realm, achieve)
	if realm == nil then
		realm =  GetRealmName();
	end
	if chann == "Guild" then
		if neoPending.Guild.Earners[earner.."_"..realm] == nil then
			neoPending.Guild.Earners[earner.."_"..realm] = {AchievementsEarned = {}}
			neoPending.Guild.Earners[earner.."_"..realm].AchievementsEarned[achieve] = true;
		else
			neoPending.Guild.Earners[earner.."_"..realm].AchievementsEarned[achieve] = true;
		
		end
		neoPending.Guild.Achieves[achieve] = true;
	end
	if chann == "Party" then
		if neoPending.Party.Earners[earner.."_"..realm] == nil then
			neoPending.Party.Earners[earner.."_"..realm] = {AchievementsEarned = {}}
			neoPending.Party.Earners[earner.."_"..realm].AchievementsEarned[achieve] = true;
		else
			neoPending.Party.Earners[earner.."_"..realm].AchievementsEarned[achieve] = true;
		
		end
		neoPending.Party.Achieves[achieve] = true;
	end
	if chann == "Raid" then
		if neoPending.Raid.Earners[earner.."_"..realm] == nil then
			neoPending.Raid.Earners[earner.."_"..realm] = {AchievementsEarned = {}}
			neoPending.Raid.Earners[earner.."_"..realm].AchievementsEarned[achieve] = true;
		else
			neoPending.Raid.Earners[earner.."_"..realm].AchievementsEarned[achieve] = true;
		
		end
		neoPending.Raid.Achieves[achieve] = true;
	end
	if chann == "Battleground" then
		if neoPending.Battleground.Earners[earner.."_"..realm] == nil then
			neoPending.Battleground.Earners[earner.."_"..realm] = {AchievementsEarned = {}}
			neoPending.Battleground.Earners[earner.."_"..realm].AchievementsEarned[achieve] = true;
		else
			neoPending.Battleground.Earners[earner.."_"..realm].AchievementsEarned[achieve] = true;
		
		end
		neoPending.Battleground.Achieves[achieve] = true;
	end
	if chann == "Nearby" then
		if neoPending.Nearby.Earners[earner.."_"..realm] == nil then
			neoPending.Nearby.Earners[earner.."_"..realm] = {AchievementsEarned = {}}
			neoPending.Nearby.Earners[earner.."_"..realm].AchievementsEarned[achieve] = true;
		else
			neoPending.Nearby.Earners[earner.."_"..realm].AchievementsEarned[achieve] = true;
		
		end
		neoPending.Nearby.Achieves[achieve] = true;
	end
end
 -- ================================================================================== --
 -- Gratz Handlers
 -- ================================================================================== --
 --NOT USED
function Gratz:HandleGuildGratz()
	
	--Step 1:  Determine how many people got achievements.
	earnerCount = #neoPending.Guild.Earners
	if earnerCount == 1 then
		--Step 2a:  Check to see if that person is on the specials list.
		isSpecial = false
		--Step 3a:  Check all the achievements for any on the specifics list.
		onSpecificsList = {}
		achievementCount = 0
		for player, tables in pairs (neoPending.Guild.Earners) do
			for key, val in pairs (neoPending.Guild.Earners[player].AchievementsEarned) do
				--TODO  check if achievement is on specifics list.
				achievementCount = achievementCount +1
			end
		end

		--Step 4a:  Deal with any specials or specifics.
		if isSpecial == true or #onSpecificsList ~= 0 then
		
		else
			--Step 5a:  Pick a message and send it.
			message = nil
			--Gratz.db.profile.UseOtherGratzForGuild
			indexmess = 0;

			if Gratz.db.profile.UseOtherGratzForGuild then
				if Gratz.db.profile.IndividualGratz ~= nil then
					if Gratz.db.profile.GuildGratzSingle ~= nil then
						if Gratz:RandomRangeCheck(1,#Gratz.db.profile.GuildGratzSingle+#Gratz.db.profile.IndividualGratz) == true then
							indexmess = random(1,#Gratz.db.profile.GuildGratzSingle+#Gratz.db.profile.IndividualGratz)
						end		
					else
						print("No gratz messages in Individual or Guild Individual")
						--indexmess = random(1,#Gratz.db.profile.GuildGratzSingle+#Gratz.db.profile.IndividualGratz)
					end
				else
					indexmess = random(1,#Gratz.db.profile.GuildGratzSingle)
				end
			else
				indexmess = random(1,#Gratz.db.profile.GuildGratzSingle)
			end

			if indexmess > #Gratz.db.profile.GuildGratzSingle then
				message = Gratz.db.profile.IndividualGratz[indexmess-#Gratz.db.profile.GuildGratzSingle].Message
			else
				message = Gratz.db.profile.GuildGratzSingle[indexmess].Message
			end
		
			name = strsplit("_",lastguildiename)
			message  = string.gsub(message, "#n", name)
			guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
			message  = string.gsub(message, "#g", guildName)
			message  = string.gsub(message, "#x", achievementCount)
			englishFaction, localizedFaction = UnitFactionGroup("player")
			message  = string.gsub(message, "#f", localizedFaction)
			message =  string.gsub(message, "#e", L["Alliance"])
			SendChatMessage(message,"GUILD")
		end
		
	else
		--Step 2a:  Check to see if any are on the specials list.
		onSpecialList = {}
		for player, tables in pairs (neoPending.Guild.Earners) do
			--TODO check for any specials.
		end
		--Step 3a:  Check all the achievements for any on the specifics list.
		onSpecificsList = {}
		for player, tables in pairs (neoPending.Guild.Earners) do
			for key, val in pairs (neoPending.Guild.Earners[player].AchievementsEarned) do
				--TODO  check if achievement is on specifics list.
			end
		end
		--Step 4a:  Deal with any specials or specifics.

		
		if #onSpecialList ~= 0 or #onSpecificsList ~= 0 then
			--Step 5aa:  


		else
			--Step 5ab:  Pick a message and send it.
			message = nil
			indexmess = 0;

			if Gratz.db.profile.UseOtherGratzForGuild then
				if Gratz.db.profile.GroupGratz ~= nil then
					if Gratz.db.profile.GuildGratzGroup ~= nil then
						indexmess = random(1,#Gratz.db.profile.GuildGratzGroup+#Gratz.db.profile.GroupGratz)
					else
						print("No gratz messages in Group or Guild Group")
					end
				else
					indexmess = random(1,#Gratz.db.profile.GuildGratzGroup)
				end
			else
				indexmess = random(1,#Gratz.db.profile.GuildGratzGroup)
			end

			if indexmess > #Gratz.db.profile.GuildGratzGroup then
				message = Gratz.db.profile.GroupGratz[indexmess-#Gratz.db.profile.GuildGratzGroup].Message --ERROR
			else
				message = Gratz.db.profile.GuildGratzGroup[indexmess].Message
			end
		
		
			guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
			message  = string.gsub(message, "#g", guildName)
			englishFaction, localizedFaction = UnitFactionGroup("player")
			message  = string.gsub(message, "#f", localizedFaction)
			message =  string.gsub(message, "#e", L["Alliance"])
			SendChatMessage(message,"GUILD")
		end
	end

neoPending.Guild = {Achieves = {}, Earners = {}}

end

function Gratz:PrintoutNeoPending()
--	print("Guild")
	for key, val in pairs (neoPending.Guild.Earners) do
		ach = " "
		for k, v in pairs (neoPending.Guild.Earners[key].AchievementsEarned) do
			ach = ach.." "..k
		end
		lin = key .. ": "..ach 
	--	print(lin)
	end
--print("Party")
	for key, val in pairs (neoPending.Party.Earners) do
		ach = " "
		for k, v in pairs (neoPending.Party.Earners[key].AchievementsEarned) do
			ach = ach.." "..k
		end
		lin = key .. ": "..ach 
		--print(lin)
	end
	--print("Raid")
	for key, val in pairs (neoPending.Raid.Earners) do
		ach = " "
		for k, v in pairs (neoPending.Raid.Earners[key].AchievementsEarned) do
			ach = ach.." "..k
		end
		lin = key .. ": "..ach 
		--print(lin)
	end
end
-- ======================================================================================================================= --



-- ======================================================================================================================= --
-- Group Timers
-- ======================================================================================================================= --


function Gratz:FindDetails(GroupType)

	if GroupType == "Party" then
		returnTable = {}
		returnTable.earnernumber = 0
		for k,v in pairs (pendingGratzTable.Party.Earners) do
		returnTable.earnernumber = returnTable.earnernumber +1;
		end

		returnTable.specifics ={}

		for akey,aval in pairs(pendingGratzTable.Party.Achieves) do
			if Gratz.db.profile.SpecificAchievementGratz[akey] ~= nil then
				tinsert(returnTable.specifics,akey);
			end
		end
		--Find all, if any special players in the list.
		returnTable.specials = {}
		for pkey, pval in pairs (pendingGratzTable.Party.Earners) do
			if Gratz.db.profile.Specials[pkey] ~= nil then
				tinsert(returnTable.specials,pkey);
			end
		end
		
		return returnTable; --Number of earners,  the number of specific achieve, number of special people in the list.
	end
	--BATTLEGROUND
	if GroupType == "Battleground" then
		returnTable = {}
		returnTable.earnernumber = #pendingGratzTable.Battleground.Earners

		returnTable.specifics ={}

		for akey,aval in pairs(pendingGratzTable.Battleground.Achieves) do
			if Gratz.db.profile.SpecificAchievementGratz[akey] ~= nil then
				tinsert(returnTable.specifics,akey);
			end
		end
		returnTable.specials = {}
		returnTable.blacklist = {}
		--Find all, if any special players in the list.
		return returnTable; --Number of earners,  the number of specific achieve, number of special people in the list.
	end
	--RAID
	if GroupType == "Raid" then
		returnTable = {}
		returnTable.earnernumber = #pendingGratzTable.Raid.Earners
		--print("Raid Earners # "..#pendingGratzTable.Raid.Earners)
		returnTable.specifics ={}

		for akey,aval in pairs(pendingGratzTable.Raid.Achieves) do
			if Gratz.db.profile.SpecificAchievementGratz[akey] ~= nil then
				tinsert(returnTable.specifics,akey);
			end
		end
		
		returnTable.specials = {}
		for pkey, pval in pairs (pendingGratzTable.Raid.Earners) do
			if Gratz.db.profile.Specials[pkey] ~= nil then
				tinsert(returnTable.specials,pkey);
			end
		end
		
		return returnTable; --Number of earners,  the number of specific achieve, number of special people in the list, blacklist count.
	end
	return nil;
end
function Gratz:RaidAchieveTimer(something)
		--print("Raid")
	for key, val in pairs (neoPending.Raid.Earners) do
		ach = " "
		for k, v in pairs (neoPending.Raid.Earners[key].AchievementsEarned) do
			ach = ach.." "..k
		end
		lin = key .. ": "..ach 
		--print(lin)
	end
	
	onSpecialList = {}
	onSpecificsList = {}
	for player, tables in pairs (neoPending.Guild.Earners) do
		--TODO check for any specials.
		for key, val in pairs (neoPending.Guild.Earners[player].AchievementsEarned) do
			--TODO  check if achievement is on specifics list.
		end
	end
	
	


	channel = "RAID"
	if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
		channel = "INSTANCE_CHAT"
	end
	


	--Wipe stored.
	neoPending.Raid = {Achieves = {}, Earners = {}}
	raidTimer = nil;
end
function Gratz:PartyAchieveTimer(something)
	if Gratz.db.profile.ActiveGratz[1] ~= true then
	return false
end
	channelMessageSent = false;
	--print("PARTY GRATZ")
	--Determine what kind of gratz message to send.
	details = Gratz:FindDetails("Party")
	messageType = 1; --Single
	
	if details.earnernumber  > 1 then
		messageType = 2; --Group
	end

	--print("Specials "..#details.specials)
	--print("Specifics "..#details.specifics)
	
		if messageType == 1 then
			if Gratz.db.profile.IndividualGratz ~= nil then
				if #Gratz.db.profile.IndividualGratz ~= 0 then
					messageIndex = random(1,#Gratz.db.profile.IndividualGratz)
					mess = Gratz.db.profile.IndividualGratz[messageIndex].Message
					name, rea = nil, nil
					for k,v in pairs (pendingGratzTable.Party.Earners) do
						name, rea = strsplit("_", k)
					end
			
				--pendingGratzTable.Party.Earners
					mess   = string.gsub(mess, "#n", name)
					if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
						SendChatMessage(mess,"INSTANCE_CHAT")
					else
						SendChatMessage(mess,"PARTY")
					end
				end
			end
		else
			if Gratz.db.profile.GroupGratz ~= nil then
				if #Gratz.db.profile.GroupGratz ~= 0 then
					messageIndex = random(1,#Gratz.db.profile.GroupGratz)
					mess = Gratz.db.profile.GroupGratz[messageIndex].Message
					if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
						SendChatMessage(mess,"INSTANCE_CHAT")
					else
						SendChatMessage(mess,"PARTY")
					end
				end
			end
		end
	
	
	--Are there any specials on the list?
	--Are there any specific achieves?
		
		--TODO Find out if any of the 


	--Clear tables
	pendingGratzTable.Party.Achieves = {}
	pendingGratzTable.Party.Earners = {}
	partyTimer = nil;
end

function Gratz:BGAchieveTimer(something)
	channelMessageSent = false;
--	print("BG GRATZ "..#neoPending.Battleground.Earners)
	--Determine what kind of gratz message to send.
	details = Gratz:FindDetails("Battleground")
	messageType = 1; --Single
	
	if #neoPending.Battleground.Earners  > 1 then
		messageType = 2; --Group
	end


	
	if messageType == 1 then
		if Gratz.db.profile.IndividualGratz ~= nil then
			if #Gratz.db.profile.IndividualGratz ~= 0 then
				messageIndex = random(1,#Gratz.db.profile.IndividualGratz)
				mess = Gratz.db.profile.IndividualGratz[messageIndex].Message
				name, rea = strsplit("_", pendingGratzTable.Battleground.Earners[1])
			--pendingGratzTable.Party.Earners
				mess   = string.gsub(mess, "#n", name)
				if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
					SendChatMessage(mess,"INSTANCE_CHAT")
				else
					SendChatMessage(mess,"BATTLEGROUND")
				end
			end
		end
		--print("BG Achievement message.  MessageType:  "..messageType)
	else
		if Gratz.db.profile.GroupGratz ~= nil then
			if #Gratz.db.profile.GroupGratz ~= 0 then
				messageIndex = random(1,#Gratz.db.profile.GroupGratz)
				mess = Gratz.db.profile.GroupGratz[messageIndex].Message
				if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
					SendChatMessage(mess,"INSTANCE_CHAT")
				else
				SendChatMessage(mess,"BATTLEGROUND")
				end
			end
		end
		--print("BG Achievement message.  MessageType:  "..messageType)

	end
	
	
	--Are there any specials on the list?
	--Are there any specific achieves?
		
		--TODO Find out if any of the 

	--Clear tables
	neoPending.Battleground.Achieves = {}
	neoPending.Battleground.Earners= {}
	bgTimer = nil;
end


-- ======================================================================================================================= --

-- ======================================================================================================================= --
local WhisperQueue = {}
local WhisperQueueTimer= nil

function Gratz:WhisperQueueFunction()
	local name = WhisperQueue[1].Name
	local realm = WhisperQueue[1].Realm
	local message = WhisperQueue[1].Message

	SendChatMessage(message, "WHISPER", name.."-"..realm)
	tremove(WhisperQueue,1)
	if Gratz:TableSize(WhisperQueue) == 0 then
		Gratz:CancelTimer(WhisperQueueTimer)
		WhisperQueueTimer = nil
	end

end

function Gratz:AddToWhisperQueue(name, realm, message)
	
	tinsert(WhisperQueue, {Name =name, Realm = realm, Message = message})
	if WhisperQueueTimer == nil then
		WhisperQueueTimer = Gratz:ScheduleRepeatingTimer("WhisperQueueFunction", 5)
	end
end




function Gratz:SendGratz(playername)


end


-- ========================================================================================== --
-- Spam Guard
-- ========================================================================================== --
local noGratzList = {}

function Gratz:RemoveFromNoGratz(playername)
	noGratzList[playername] = nil
end
--- This function is part of the spam guard mechanic for this addon.
-- It adds a person who has been recently gratzed to a table for 10 seconds.
-- If that person gets an achievement within 10 seconds of the last achievement,
-- no gratz will be sent.
function Gratz:AddToNoGratz(playername)
	if noGratzList[playername] == nil then
		noGratzList[playername] = self.ScheduleTimer("RemoveFromNoGratz", 10, playername);
	end
end
-- ========================================================================================== --
--	Database defaults.
-- ========================================================================================== --
--Database
local defaults ={	profile = {
						ActiveGratz					= {true , true,  true, true, true},
						SingleSettingGroup			= false,
						SingleSetting				= {	PARTY 			= true,
														RAID 			= true, 
														BATTLEGROUND 	= true, 
														GUILD 			= true, 
														NEARBY 			= true
													},
						IndividualGratz				= {},
						GroupGratz					= {},
						GuildGratzSingle			= {},
						GuildGratzGroup				= {},
						UseOtherGratzForGuild 		= true,
						DingGratz					= {},
						DingOn						= true,
						DingChannels				= {true,true,true,true, true},
						BGGratz						= {},
						BGGratzOn 					= true,
						SpecificAchievementGratz 	= {}, --Ignore, SingleMessages, GroupMessages
						AFKon 						= true,
						Delay 						= 5,
						MinDelay 					= 1,
						Specials 					= {},  -- Ignore, Whisper, Specific, SpecificList = {}
						WaitListSettings 			= {Enabled = true, Sorting = 1, TimeFormat = 1, DateFormat = 1, 
							Reminder = true, ReminderDelay = 15,Channels = {Raid = true, Party = true, Battleground = true, Guild = true, Nearby = true}},
						WaitList 					= {},
						UseRealm = true,
						TestList = {},
						Priorities = {Normal = 1, Specific = 1, Special = 1}

}}

-- Message Selection
--TODO:  Guild Normal
function Gratz:SelectNormalMessageGuild(numPeople)
	if numPeople == 1 then
		if Gratz.db.profile.UseOtherGratzForGuild and Gratz:TableSize(Gratz.db.profile.IndividualGratz)~=0 then
			--IndividualGratz
			if Gratz:TableSize(Gratz.db.profile.GuildGratzSingle) == 0 then
				return false
			end

			local selected = random(1, Gratz:TableSize(Gratz.db.profile.GuildGratzSingle) + Gratz:TableSize(Gratz.db.profile.IndividualGratz))
			if selected > Gratz:TableSize(Gratz.db.profile.GuildGratzSingle) then
				return true, Gratz.db.profile.IndividualGratz[selected].Message
			else
				guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
				local mess = string.gsub(Gratz.db.profile.GuildGratzSingle[selected].Message, "#g",guildName) 
				--string.gsub(mess, "#n", name)
				return true, mess
			end

		else
			if Gratz:TableSize(Gratz.db.profile.GuildGratzSingle) == 0 then
				return false
			end
			local selected = random(1, Gratz:TableSize(Gratz.db.profile.GuildGratzSingle))
			guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
			local mess = string.gsub(Gratz.db.profile.GuildGratzSingle[selected].Message, "#g",guildName) 
			--string.gsub(mess, "#n", name)
			return true, mess
		end
	else
		if Gratz.db.profile.UseOtherGratzForGuild and Gratz:TableSize(Gratz.db.profile.GroupGratz)~=0 then
			--GroupGratz
			if Gratz:TableSize(Gratz.db.profile.GuildGratzGroup) == 0 then
				return false
			end

			local selected = random(1, Gratz:TableSize(Gratz.db.profile.GuildGratzGroup) + Gratz:TableSize(Gratz.db.profile.GroupGratz))
			if selected > Gratz:TableSize(Gratz.db.profile.GuildGratzGroup) then
				return true, Gratz.db.profile.GroupGratz[selected].Message
			else
				guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
				local mess = string.gsub(Gratz.db.profile.GuildGratzGroup[selected].Message, "#g",guildName) 
				--string.gsub(mess, "#n", name)
				return true, mess
			end

		else
			if Gratz:TableSize(Gratz.db.profile.GuildGratzGroup) == 0 then
				return false
			end
			local selected = random(1, Gratz:TableSize(Gratz.db.profile.GuildGratzGroup))
			guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
			local mess = string.gsub(Gratz.db.profile.GuildGratzGroup[selected], "#g",guildName) 
			--string.gsub(mess, "#n", name)
			return true, mess
		end
	end

	return false
end

function Gratz:SelectNormalMessage(numPeople)
	if numPeople == 1 then
		if Gratz.db.profile.IndividualGratz == nil then
			return false
		end
		if Gratz:TableSize(Gratz.db.profile.IndividualGratz) == 0 then
			return false
		else
			local messageIndex = random(1, Gratz:TableSize(Gratz.db.profile.IndividualGratz))
			return true, Gratz.db.profile.IndividualGratz[messageIndex].Message
		end
	else
		if Gratz.db.profile.GroupGratz == nil then
			return false
		end
		if Gratz:TableSize(Gratz.db.profile.GroupGratz) == 0 then
			return false
		else
			local messageIndex = random(1, Gratz:TableSize(Gratz.db.profile.GroupGratz))
			return true, Gratz.db.profile.GroupGratz[messageIndex].Message
		end
	end
end
function Gratz:SelectSpecialsMessage(specials, numPeople)
	local tempSpecials = {}
	for k,v in pairs (specials) do
		tinsert(tempSpecials, v)
	end
	while Gratz:TableSize(tempSpecials) ~= 0 do
		local selected = random(1, Gratz:TableSize(tempSpecials))
		if numPeople == 1 then
			if Gratz.db.profile.Specials[tempSpecials[selected].Name.."-"..tempSpecials[selected].Realm].Messages == nil then
				tremove(tempSpecials, selected)
			else
				if Gratz:TableSize(Gratz.db.profile.Specials[tempSpecials[selected].Name.."-"..tempSpecials[selected].Realm].Messages) == 0 then
					tremove(tempSpecials, selected)
				else
					local messageIndex = random(1, Gratz:TableSize(Gratz.db.profile.Specials[tempSpecials[selected].Name.."-"..tempSpecials[selected].Realm].Messages))
					return true, Gratz.db.profile.Specials[tempSpecials[selected].ID].Messages[messageIndex], tempSpecials[selected].Name, tempSpecials[selected].Realm
				end
			end
		else
			if Gratz.db.profile.Specials[tempSpecials[selected].Name.."-"..tempSpecials[selected].Realm].GroupMessages == nil then
				tremove(tempSpecials, selected)
			else
				if Gratz:TableSize(Gratz.db.profile.Specials[tempSpecials[selected].Name.."-"..tempSpecials[selected].Realm].GroupMessages) == 0 then
					tremove(tempSpecials, selected)
				else
					local messageIndex = random(1, Gratz:TableSize(Gratz.db.profile.Specials[tempSpecials[selected].Name.."-"..tempSpecials[selected].Realm].GroupMessages))
					return true, Gratz.db.profile.Specials[tempSpecials[selected].Name.."-"..tempSpecials[selected].Realm].GroupMessages[messageIndex], tempSpecials[selected].Name, tempSpecials[selected].Realm
				end
			end
	
		end
	end
	return false
end
function Gratz:SelectSpecificMessage(specifics, numPeople)

	local tempSpecifics = {}
	for k,v in pairs (specifics) do
		tinsert(tempSpecifics, v)
	end
	while Gratz:TableSize(tempSpecifics) ~= 0 do
		local selected = random(1, Gratz:TableSize(tempSpecifics))
		if numPeople == 1 then
			if Gratz.db.profile.SpecificAchievementGratz[tempSpecifics[selected].ID].SingleMessages == nil then
				tremove(tempSpecifics, selected)
			else
				if Gratz:TableSize(Gratz.db.profile.SpecificAchievementGratz[tempSpecifics[selected].ID].SingleMessages) == 0 then
					tremove(tempSpecifics, selected)
				else
					local messageIndex = random(1, Gratz:TableSize(Gratz.db.profile.SpecificAchievementGratz[tempSpecifics[selected].ID].SingleMessages))
					return true, Gratz.db.profile.SpecificAchievementGratz[tempSpecifics[selected].ID].SingleMessages[messageIndex], tempSpecifics[selected].ID
				end
			end
		else
			if Gratz.db.profile.SpecificAchievementGratz[tempSpecifics[selected].ID].GroupMessages == nil then
				tremove(tempSpecifics, selected)
			else
				if Gratz:TableSize(Gratz.db.profile.SpecificAchievementGratz[tempSpecifics[selected].ID].GroupMessages) == 0 then
					tremove(tempSpecifics, selected)
				else
					local messageIndex = random(1, Gratz:TableSize(Gratz.db.profile.SpecificAchievementGratz[tempSpecifics[selected].ID].GroupMessages))
					return true, Gratz.db.profile.SpecificAchievementGratz[tempSpecifics[selected].ID].GroupMessages[messageIndex], tempSpecifics[selected].ID
				end
			end
	
		end
	end
	return false
end
--------------------------------------------------------------------------------------
local RaidQueue = {Normal = {}, Specific = {}, Special = {}}
local RaidQueueTimer = nil
function Gratz:AddToRaidQueueNormal(name, realm, id)
	tinsert(RaidQueue.Normal, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToRaidQueueSpecific(name, realm, id)
	tinsert(RaidQueue.Specific, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToRaidQueueSpecial(name, realm, id)
	tinsert(RaidQueue.Special, {Name = name, Realm =realm, ID = id})
end
function Gratz:RemoveFromRaidQueueNormal(k)
	tremove(RaidQueue.Normal, k)
end
function Gratz:RemoveFromRaidQueueSpecific(k)
	tremove(RaidQueue.Specific, k)
end
function Gratz:RemoveFromRaidQueueSpecial(k)
	tremove(RaidQueue.Special, k)
end


local PartyQueue = {Normal = {}, Specific = {}, Special = {}}
local PartyQueueTimer = nil
function Gratz:AddToPartyQueueNormal(name, realm, id)
	tinsert(PartyQueue.Normal, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToPartyQueueSpecific(name, realm, id)
	tinsert(PartyQueue.Specific, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToPartyQueueSpecial(name, realm, id)
	tinsert(PartyQueue.Special, {Name = name, Realm =realm, ID = id})
end
function Gratz:RemoveFromPartyQueueNormal(k)
	tremove(PartyQueue.Normal, k)
end
function Gratz:RemoveFromPartyQueueSpecific(k)
	tremove(PartyQueue.Specific, k)
end
function Gratz:RemoveFromPartyQueueSpecial(k)
	tremove(PartyQueue.Special, k)
end

local BGQueue = {Normal = {}, Specific = {}, Special = {}}
local BGQueueTimer = nil
function Gratz:AddToBGQueueNormal(name, realm, id)
	tinsert(BGQueue.Normal, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToBGQueueSpecific(name, realm, id)
	tinsert(BGQueue.Specific, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToBGQueueSpecial(name, realm, id)
	tinsert(BGQueue.Special, {Name = name, Realm =realm, ID = id})
end
function Gratz:RemoveFromBGQueueNormal(k)
	tremove(BGQueue.Normal, k)
end
function Gratz:RemoveFromBGQueueSpecific(k)
	tremove(BGQueue.Specific, k)
end
function Gratz:RemoveFromBGQueueSpecial(k)
	tremove(BGQueue.Special, k)
end

local NearbyQueue = {Normal = {}, Specific = {}, Special = {}}
local NearbyQueueTimer = nil
function Gratz:AddToNearbyQueueNormal(name, realm, id)
	tinsert(NearbyQueue.Normal, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToNearbyQueueSpecific(name, realm, id)
	tinsert(NearbyQueue.Specific, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToNearbyQueueSpecial(name, realm, id)
	tinsert(NearbyQueue.Special, {Name = name, Realm =realm, ID = id})
end
function Gratz:RemoveFromNearbyQueueNormal(k)
	tremove(NearbyQueue.Normal, k)
end
function Gratz:RemoveFromNearbyQueueSpecific(k)
	tremove(NearbyQueue.Specific, k)
end
function Gratz:RemoveFromNearbyQueueSpecial(k)
	tremove(NearbyQueue.Special, k)
end


local GuildQueue = {Normal = {}, Specific = {}, Special = {}}
local GuildQueueTimer = nil
function Gratz:AddToGuildQueueNormal(name, realm, id)
	tinsert(GuildQueue.Normal, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToGuildQueueSpecific(name, realm, id)
	tinsert(GuildQueue.Specific, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToGuildQueueSpecial(name, realm, id)
	tinsert(GuildQueue.Special, {Name = name, Realm =realm, ID = id})
end
function Gratz:RemoveFromGuildQueueNormal(k)
	tremove(GuildQueue.Normal, k)
end
function Gratz:RemoveFromGuildQueueSpecific(k)
	tremove(GuildQueue.Specific, k)
end
function Gratz:RemoveFromGuildQueueSpecial(k)
	tremove(GuildQueue.Special, k)
end




-----------------------------------------------------------



local TestQueue = {Normal = {}, Specific = {}, Special = {}}
local TestQueueTimer = nil
function Gratz:AddToTestQueueNormal(name, realm, id)
	tinsert(TestQueue.Normal, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToTestQueueSpecific(name, realm, id)
	tinsert(TestQueue.Specific, {Name = name, Realm =realm, ID = id})
end
function Gratz:AddToTestQueueSpecial(name, realm, id)
	tinsert(TestQueue.Special, {Name = name, Realm =realm, ID = id})
end
function Gratz:RemoveFromTestQueueNormal(k)
	tremove(TestQueue.Normal, k)
end
function Gratz:RemoveFromTestQueueSpecific(k)
	tremove(TestQueue.Specific, k)
end
function Gratz:RemoveFromTestQueueSpecial(k)
	tremove(TestQueue.Special, k)
end
function Gratz:AddNewSpecial(name, realm)
	if Gratz.db.profile.Specials[name.."-"..realm] == nil then
		Gratz.db.profile.Specials[name.."-"..realm] = {Enabled = true, Ignore = false, Whisper = false, Seperate = false, Messages = {}, GroupMessages = {}}
	end

end
function Gratz:RemoveSpecial(name, realm)
	Gratz.db.profile.Specials[name.."-"..realm] = nil
end


--TestQueueTimer =Gratz:ScheduleTimer("TestQueueTimerFunc", 5)
function Gratz:IsPersonOnIgnore(name, realm)
	key = name .."_"..realm;
	if Gratz.db.profile.Specials[key] ~= nil then
		if Gratz.db.profile.Specials[key].Ignore == true then
			return true
		else
			return false
		end
	end
		return false;
end
function Gratz:CheckSpecialsForWhispers(specials)
	neoSpecials = {}

	whisperednames = {}
	for k,v in pairs (specials) do
		local nr = specials[k].Name.."-"..specials[k].Realm
		if Gratz.db.profile.Specials[nr] ~= nil then
			if Gratz.db.profile.Specials[nr].Whisper == true and Gratz:TableSize(Gratz.db.profile.Specials[nr].Messages)~= 0 then
				local message = nil
				local messageIndex = random(1, Gratz:TableSize(Gratz.db.profile.Specials[nr].Messages))
				local messageB = ""
				if UseRealm then
					messageB =string.gsub(Gratz.db.profile.Specials[nr].Messages[messageIndex], "#n", nameANDrealm)
				else
					messageB =string.gsub(Gratz.db.profile.Specials[nr].Messages[messageIndex], "#n", Gratz:splitAtFirst(nameANDrealm, "-"))
				end
				Gratz:AddToWhisperQueue(specials[k].Name, specials[k].Realm, message)
				whisperednames[nr] = true
			else
				tinsert(neoSpecials, specials[k])
			end
		else
			tinsert(neoSpecials, specials[k])
		end

	end
	return neoSpecials, whisperednames
end


function Gratz:RaidQueueTimerFunc ()
	
	local testHasNormal = false
	if Gratz:TableSize(RaidQueue.Normal) ~= 0 then
		testHasNormal = true
	end
	local testHasSpecific = false
	if Gratz:TableSize(RaidQueue.Specific) ~= 0 then
		testHasSpecific = true
	end
	local testHasSpecial = false
	if Gratz:TableSize(RaidQueue.Special) ~= 0 then
		testHasSpecial = true
	end
	

	--print("Normal: "..Gratz:TableSize(RaidQueue.Normal)..". Specific: "..Gratz:TableSize(RaidQueue.Specific)..". Special: "..Gratz:TableSize(RaidQueue.Special))
	RaidQueueTimer = nil
	local neoSpecials, whisperList = Gratz:CheckSpecialsForWhispers(RaidQueue.Special)
	RaidQueue.Special = {}

	--Count the number of people.
	local peopleInTest = {}
	for k = 1, Gratz:TableSize(neoSpecials) do
		peopleInTest[neoSpecials[k].Name.."-"..neoSpecials[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(RaidQueue.Specific) do
		peopleInTest[RaidQueue.Specific[k].Name.."-"..RaidQueue.Specific[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(RaidQueue.Normal) do
		peopleInTest[RaidQueue.Normal[k].Name.."-"..RaidQueue.Normal[k].Realm] = true
	end
	--whisperList
	for k = 1, Gratz:TableSize(whisperList) do
		peopleInTest[k] = true
	end
	local NumberOfPeople = Gratz:TableSize(peopleInTest)
	--print(Gratz:TableSize(peopleInTest))


	local priorityTable = {}
	priorityTable[1] = {}
	priorityTable[2] = {}
	priorityTable[3] = {}
	if testHasNormal then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Normal],"Normal")
	end
	if testHasSpecific then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Specific],"Specific")
	end
	if Gratz:TableSize(neoSpecials) ~= 0 then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Special],"Special")
	end

	local validFound = false
	local messageA = ""
	local topPriorityFound = false
	while validFound == false and topPriorityFound == false do

		local topP = 0
		for k = 1,3 do
			if Gratz:TableSize(priorityTable[k]) ~= 0 and topPriorityFound == false then
				topP = k
				topPriorityFound = true
			end
		end
		local pick = ""
		if topP ~= 0 then
		if Gratz:TableSize(priorityTable[topP]) > 1 then
			local randi = random(1,Gratz:TableSize(priorityTable[topP]))
			pick = priorityTable[topP][randi]
			if pick == "Special" then
				--Gratz:SelectSpecialsMessage(specials, numPeople)
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessage(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(RaidQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
		
		else
			pick  = priorityTable[topP][1]
			if pick == "Special" then
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessage(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(RaidQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
		
		end
		else
			return false
		end
		
		
	end

	--string.gsub(mess, "#n", name)
	if NumberOfPeople > 1 then
		print(messageA)
	else
		if Gratz.db.profile.UseRealm then
			--peopleInTest
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local messageB =string.gsub(messageA, "#n", nameANDrealm)
			if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
				SendChatMessage(mess, "INSTANCE_CHAT")
			else
				SendChatMessage(messageB,"RAID")
			end
			
		else	
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local nameA, realmA = Gratz:splitAtFirst(nameANDrealm, "-")
			local messageB = string.gsub(messageA, "#n", nameA)
			if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
				SendChatMessage(mess, "INSTANCE_CHAT")
			else
				SendChatMessage(messageB,"RAID")
			end
		
			--print(messageB)
		end
	end

	RaidQueue.Normal = {}
	RaidQueue.Special = {}
	RaidQueue.Specific = {}
end

function Gratz:PartyQueueTimerFunc ()
	
	local testHasNormal = false
	if Gratz:TableSize(PartyQueue.Normal) ~= 0 then
		testHasNormal = true
	end
	local testHasSpecific = false
	if Gratz:TableSize(PartyQueue.Specific) ~= 0 then
		testHasSpecific = true
	end
	local testHasSpecial = false
	if Gratz:TableSize(PartyQueue.Special) ~= 0 then
		testHasSpecial = true
	end
	

	--print("Normal: "..Gratz:TableSize(PartyQueue.Normal)..". Specific: "..Gratz:TableSize(PartyQueue.Specific)..". Special: "..Gratz:TableSize(PartyQueue.Special))
	PartyQueueTimer = nil
	local neoSpecials, whisperList = Gratz:CheckSpecialsForWhispers(PartyQueue.Special)
	PartyQueue.Special = {}

	--Count the number of people.
	local peopleInTest = {}
	for k = 1, Gratz:TableSize(neoSpecials) do
		peopleInTest[neoSpecials[k].Name.."-"..neoSpecials[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(PartyQueue.Specific) do
		peopleInTest[PartyQueue.Specific[k].Name.."-"..PartyQueue.Specific[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(PartyQueue.Normal) do
		peopleInTest[PartyQueue.Normal[k].Name.."-"..PartyQueue.Normal[k].Realm] = true
	end
	--whisperList
	for k = 1, Gratz:TableSize(whisperList) do
		peopleInTest[k] = true
	end
	local NumberOfPeople = Gratz:TableSize(peopleInTest)
	--print(Gratz:TableSize(peopleInTest))


	local priorityTable = {}
	priorityTable[1] = {}
	priorityTable[2] = {}
	priorityTable[3] = {}
	if testHasNormal then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Normal],"Normal")
	end
	if testHasSpecific then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Specific],"Specific")
	end
	if Gratz:TableSize(neoSpecials) ~= 0 then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Special],"Special")
	end

	local validFound = false
	local messageA = ""
	local topPriorityFound = false
	while validFound == false and topPriorityFound == false do

		local topP = 0
		for k = 1,3 do
			if Gratz:TableSize(priorityTable[k]) ~= 0 and topPriorityFound == false then
				topP = k
				topPriorityFound = true
			end
		end
		local pick = ""
		if topP ~= 0 then
		if Gratz:TableSize(priorityTable[topP]) > 1 then
			local randi = random(1,Gratz:TableSize(priorityTable[topP]))
			pick = priorityTable[topP][randi]
			if pick == "Special" then
				--Gratz:SelectSpecialsMessage(specials, numPeople)
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessage(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(PartyQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
		
		else
			pick  = priorityTable[topP][1]
			if pick == "Special" then
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessage(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(PartyQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
		
		end
		else
		return false
		
		end
		
	end

	--string.gsub(mess, "#n", name)
	if NumberOfPeople > 1 then
		print(messageA)
	else
		if Gratz.db.profile.UseRealm then
			--peopleInTest
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local messageB =string.gsub(messageA, "#n", nameANDrealm)
			SendChatMessage(messageB,"INSTANCE_CHAT")
		else	
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local nameA, realmA = Gratz:splitAtFirst(nameANDrealm, "-")
			local messageB = string.gsub(messageA, "#n", nameA)
			--if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
				SendChatMessage(mess, "INSTANCE_CHAT")
			
			
			--print(messageB)
		end
	end

	PartyQueue.Normal = {}
	PartyQueue.Special = {}
	PartyQueue.Specific = {}
end

function Gratz:BGQueueTimerFunc ()
	
	local testHasNormal = false
	if Gratz:TableSize(BGQueue.Normal) ~= 0 then
		testHasNormal = true
	end
	local testHasSpecific = false
	if Gratz:TableSize(BGQueue.Specific) ~= 0 then
		testHasSpecific = true
	end
	local testHasSpecial = false
	if Gratz:TableSize(BGQueue.Special) ~= 0 then
		testHasSpecial = true
	end
	

	--print("Normal: "..Gratz:TableSize(BGQueue.Normal)..". Specific: "..Gratz:TableSize(BGQueue.Specific)..". Special: "..Gratz:TableSize(BGQueue.Special))
	BGQueueTimer = nil
	local neoSpecials, whisperList = Gratz:CheckSpecialsForWhispers(BGQueue.Special)
	BGQueue.Special = {}

	--Count the number of people.
	local peopleInTest = {}
	for k = 1, Gratz:TableSize(neoSpecials) do
		peopleInTest[neoSpecials[k].Name.."-"..neoSpecials[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(BGQueue.Specific) do
		peopleInTest[BGQueue.Specific[k].Name.."-"..BGQueue.Specific[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(BGQueue.Normal) do
		peopleInTest[BGQueue.Normal[k].Name.."-"..BGQueue.Normal[k].Realm] = true
	end
	--whisperList
	for k = 1, Gratz:TableSize(whisperList) do
		peopleInTest[k] = true
	end
	local NumberOfPeople = Gratz:TableSize(peopleInTest)
	--print(Gratz:TableSize(peopleInTest))


	local priorityTable = {}
	priorityTable[1] = {}
	priorityTable[2] = {}
	priorityTable[3] = {}
	if testHasNormal then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Normal],"Normal")
	end
	if testHasSpecific then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Specific],"Specific")
	end
	if Gratz:TableSize(neoSpecials) ~= 0 then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Special],"Special")
	end

	local validFound = false
	local messageA = ""
	local topPriorityFound = false
	while validFound == false and topPriorityFound == false do

		local topP = 0
		for k = 1,3 do
			if Gratz:TableSize(priorityTable[k]) ~= 0 and topPriorityFound == false then
				topP = k
				topPriorityFound = true
			end
		end
		local pick = ""
		if topP ~= 0 then
		if Gratz:TableSize(priorityTable[topP]) > 1 then
			local randi = random(1,Gratz:TableSize(priorityTable[topP]))
			pick = priorityTable[topP][randi]
			if pick == "Special" then
				--Gratz:SelectSpecialsMessage(specials, numPeople)
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessage(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(BGQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
		
		else
			pick  = priorityTable[topP][1]
			if pick == "Special" then
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessage(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(BGQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
		
		end
		else
			return false
		end

		
	end

	--string.gsub(mess, "#n", name)
	if NumberOfPeople > 1 then
		print(messageA)
	else
		if Gratz.db.profile.UseRealm then
			--peopleInTest
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local messageB =string.gsub(messageA, "#n", nameANDrealm)
			if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
				SendChatMessage(mess, "INSTANCE_CHAT")
			else

				SendChatMessage(messageB,"RAID")
			end
		else	
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local nameA, realmA = Gratz:splitAtFirst(nameANDrealm, "-")
			local messageB = string.gsub(messageA, "#n", nameA)
			SendChatMessage(messageB,"RAID")
			--print(messageB)
		end
	end

	BGQueue.Normal = {}
	BGQueue.Special = {}
	BGQueue.Specific = {}
end

function Gratz:GuildQueueTimerFunc ()
	
	local testHasNormal = false
	if Gratz:TableSize(GuildQueue.Normal) ~= 0 then
		testHasNormal = true
	end
	local testHasSpecific = false
	if Gratz:TableSize(GuildQueue.Specific) ~= 0 then
		testHasSpecific = true
	end
	local testHasSpecial = false
	if Gratz:TableSize(GuildQueue.Special) ~= 0 then
		testHasSpecial = true
	end
	

	--print("Normal: "..Gratz:TableSize(GuildQueue.Normal)..". Specific: "..Gratz:TableSize(GuildQueue.Specific)..". Special: "..Gratz:TableSize(GuildQueue.Special))
	GuildQueueTimer = nil
	local neoSpecials, whisperList = Gratz:CheckSpecialsForWhispers(GuildQueue.Special)
	GuildQueue.Special = {}

	--Count the number of people.
	local peopleInTest = {}
	for k = 1, Gratz:TableSize(neoSpecials) do
		peopleInTest[neoSpecials[k].Name.."-"..neoSpecials[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(GuildQueue.Specific) do
		peopleInTest[GuildQueue.Specific[k].Name.."-"..GuildQueue.Specific[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(GuildQueue.Normal) do
		peopleInTest[GuildQueue.Normal[k].Name.."-"..GuildQueue.Normal[k].Realm] = true
	end
	--whisperList
	for k = 1, Gratz:TableSize(whisperList) do
		peopleInTest[k] = true
	end
	local NumberOfPeople = Gratz:TableSize(peopleInTest)
	--print(Gratz:TableSize(peopleInTest))


	local priorityTable = {}
	priorityTable[1] = {}
	priorityTable[2] = {}
	priorityTable[3] = {}
	if testHasNormal then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Normal],"Normal")
	end
	if testHasSpecific then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Specific],"Specific")
	end
	if Gratz:TableSize(neoSpecials) ~= 0 then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Special],"Special")
	end

	local validFound = false
	local messageA = ""
	local topPriorityFound = false
	while validFound == false and topPriorityFound == false do

		local topP = 0
		for k = 1,3 do
			if Gratz:TableSize(priorityTable[k]) ~= 0 and topPriorityFound == false then
				topP = k
				topPriorityFound = true
			end
		end
		local pick = ""

		if topP ~= 0 then
		if Gratz:TableSize(priorityTable[topP]) > 1 then
			local randi = random(1,Gratz:TableSize(priorityTable[topP]))
			pick = priorityTable[topP][randi]
			if pick == "Special" then
				--Gratz:SelectSpecialsMessage(specials, numPeople)
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessageGuild(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(GuildQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
		
		else
			pick  = priorityTable[topP][1]
			if pick == "Special" then
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessageGuild(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(GuildQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
		
		end
		else
			return false
		end
	end

	--string.gsub(mess, "#n", name)
	if NumberOfPeople > 1 then
		print(messageA)
	else
		if Gratz.db.profile.UseRealm then
			--peopleInTest
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local messageB =string.gsub(messageA, "#n", nameANDrealm)
			SendChatMessage(messageB,"GUILD")
		else	
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local nameA, realmA = Gratz:splitAtFirst(nameANDrealm, "-")
			local messageB = string.gsub(messageA, "#n", nameA)
			SendChatMessage(messageB,"GUILD")
			--print(messageB)
		end
	end

	GuildQueue.Normal = {}
	GuildQueue.Special = {}
	GuildQueue.Specific = {}
end

function Gratz:NearbyQueueTimerFunc ()
	
	local testHasNormal = false
	if Gratz:TableSize(NearbyQueue.Normal) ~= 0 then
		testHasNormal = true
	end
	local testHasSpecific = false
	if Gratz:TableSize(NearbyQueue.Specific) ~= 0 then
		testHasSpecific = true
	end
	local testHasSpecial = false
	if Gratz:TableSize(NearbyQueue.Special) ~= 0 then
		testHasSpecial = true
	end
	

	--print("Normal: "..Gratz:TableSize(NearbyQueue.Normal)..". Specific: "..Gratz:TableSize(NearbyQueue.Specific)..". Special: "..Gratz:TableSize(NearbyQueue.Special))
	NearbyQueueTimer = nil
	local neoSpecials, whisperList = Gratz:CheckSpecialsForWhispers(NearbyQueue.Special)
	NearbyQueue.Special = {}

	--Count the number of people.
	local peopleInTest = {}
	for k = 1, Gratz:TableSize(neoSpecials) do
		peopleInTest[neoSpecials[k].Name.."-"..neoSpecials[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(NearbyQueue.Specific) do
		peopleInTest[NearbyQueue.Specific[k].Name.."-"..NearbyQueue.Specific[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(NearbyQueue.Normal) do
		peopleInTest[NearbyQueue.Normal[k].Name.."-"..NearbyQueue.Normal[k].Realm] = true
	end
	--whisperList
	for k = 1, Gratz:TableSize(whisperList) do
		peopleInTest[k] = true
	end
	local NumberOfPeople = Gratz:TableSize(peopleInTest)
	--print(Gratz:TableSize(peopleInTest))


	local priorityTable = {}
	priorityTable[1] = {}
	priorityTable[2] = {}
	priorityTable[3] = {}
	if testHasNormal then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Normal],"Normal")
	end
	if testHasSpecific then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Specific],"Specific")
	end
	if Gratz:TableSize(neoSpecials) ~= 0 then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Special],"Special")
	end

	local validFound = false
	local messageA = ""
	local topPriorityFound = false
	while validFound == false and topPriorityFound == false do

		local topP = 0
		for k = 1,3 do
			if Gratz:TableSize(priorityTable[k]) ~= 0 and topPriorityFound == false then
				topP = k
				topPriorityFound = true
			end
		end
		local pick = ""
		if Gratz:TableSize(priorityTable[topP]) > 1 then
			local randi = random(1,Gratz:TableSize(priorityTable[topP]))
			pick = priorityTable[topP][randi]
			if pick == "Special" then
				--Gratz:SelectSpecialsMessage(specials, numPeople)
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessage(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(NearbyQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
		
		else
			pick  = priorityTable[topP][1]
			if pick == "Special" then
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessage(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(NearbyQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
		
		end
		
	end

	--string.gsub(mess, "#n", name)
	if NumberOfPeople > 1 then
		print(messageA)
	else
		if Gratz.db.profile.UseRealm then
			--peopleInTest
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local messageB =string.gsub(messageA, "#n", nameANDrealm)
			SendChatMessage(messageB,"SAY")
		else	
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local nameA, realmA = Gratz:splitAtFirst(nameANDrealm, "-")
			local messageB = string.gsub(messageA, "#n", nameA)
			SendChatMessage(messageB,"SAY")
			--print(messageB)
		end
	end

	NearbyQueue.Normal = {}
	NearbyQueue.Special = {}
	NearbyQueue.Specific = {}
end

function Gratz:TestQueueTimerFunc ()
	
	local testHasNormal = false
	if Gratz:TableSize(TestQueue.Normal) ~= 0 then
		testHasNormal = true
	end
	local testHasSpecific = false
	if Gratz:TableSize(TestQueue.Specific) ~= 0 then
		testHasSpecific = true
	end
	local testHasSpecial = false
	if Gratz:TableSize(TestQueue.Special) ~= 0 then
		testHasSpecial = true
	end
	

	print("Normal: "..Gratz:TableSize(TestQueue.Normal)..". Specific: "..Gratz:TableSize(TestQueue.Specific)..". Special: "..Gratz:TableSize(TestQueue.Special))
	TestQueueTimer = nil
	local neoSpecials, whisperList = Gratz:CheckSpecialsForWhispers(TestQueue.Special)
	TestQueue.Special = {}

	--Count the number of people.
	local peopleInTest = {}
	for k = 1, Gratz:TableSize(neoSpecials) do
		peopleInTest[neoSpecials[k].Name.."-"..neoSpecials[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(TestQueue.Specific) do
		peopleInTest[TestQueue.Specific[k].Name.."-"..TestQueue.Specific[k].Realm] = true
	end
	for k = 1, Gratz:TableSize(TestQueue.Normal) do
		peopleInTest[TestQueue.Normal[k].Name.."-"..TestQueue.Normal[k].Realm] = true
	end
	--whisperList
	for k = 1, Gratz:TableSize(whisperList) do
		peopleInTest[k] = true
	end
	local NumberOfPeople = Gratz:TableSize(peopleInTest)
	--print(Gratz:TableSize(peopleInTest))


	local priorityTable = {}
	priorityTable[1] = {}
	priorityTable[2] = {}
	priorityTable[3] = {}
	if testHasNormal then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Normal],"Normal")
	end
	if testHasSpecific then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Specific],"Specific")
	end
	if Gratz:TableSize(neoSpecials) ~= 0 then
		tinsert(priorityTable[Gratz.db.profile.Priorities.Special],"Special")
	end

	local validFound = false
	local messageA = ""
	local topPriorityFound = false
	while validFound == false and topPriorityFound == false do

		local topP = 0
		for k = 1,3 do
			if Gratz:TableSize(priorityTable[k]) ~= 0 and topPriorityFound == false then
				topP = k
				topPriorityFound = true
			end
		end
		local pick = ""
		if Gratz:TableSize(priorityTable[topP]) > 1 then
			local randi = random(1,Gratz:TableSize(priorityTable[topP]))
			pick = priorityTable[topP][randi]
			if pick == "Special" then
				--Gratz:SelectSpecialsMessage(specials, numPeople)
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessage(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(TestQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], randi)
				end
				topPriorityFound = validFound
			end
		
		else
			pick  = priorityTable[topP][1]
			if pick == "Special" then
				validFound, messageA, na, re = Gratz:SelectSpecialsMessage(neoSpecials, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Normal" then
				validFound, messageA = Gratz:SelectNormalMessage(NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
			if pick == "Specific" then
				validFound, messageA, AID = Gratz:SelectSpecificMessage(TestQueue.Specific, NumberOfPeople)
				if validFound == false then
					tremove(priorityTable[topP], 1)
				end
				topPriorityFound = validFound
			end
		
		end
		
	end

	--string.gsub(mess, "#n", name)
	if NumberOfPeople > 1 then
		print(messageA)
	else
		if Gratz.db.profile.UseRealm then
			--peopleInTest
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local messageB =string.gsub(messageA, "#n", nameANDrealm)
			print(messageB)
		else	
			local nameANDrealm = ""
			for k,v in pairs (peopleInTest) do
				nameANDrealm = k
			end
			local nameA, realmA = Gratz:splitAtFirst(nameANDrealm, "-")
			local messageB = string.gsub(messageA, "#n", nameA)
			print(messageB)
		end
	end

	TestQueue.Normal = {}
	TestQueue.Special = {}
	TestQueue.Specific = {}
end

local  testUI = {type = "group", name = "Test", args = {}}
function Gratz:RemoveTestUI()

	for k = 1,Gratz:TableSize(Gratz.db.profile.TestList) do
		testUI.args["name"..k] = nil
		testUI.args["realm"..k] = nil
		testUI.args["id"..k] = nil
		testUI.args["del"..k] = nil
	end
end
function Gratz:AddTestUI(k)
	testUI.args["name"..k] = {	name = "name",
								type = "input", 
								order = 4+(k*4), 
								set = function (info, val)Gratz.db.profile.TestList[k].Name = val end,
								get = function () return Gratz.db.profile.TestList[k].Name end}
	testUI.args["realm"..k] = {	name = "Realm",
								type = "input", 
								order = 5+(k*4), 
								set = function (info, val)Gratz.db.profile.TestList[k].Realm = val end,
								get = function () return Gratz.db.profile.TestList[k].Realm end}
	testUI.args["id"..k] = {	width = "half",
								name = "ID",
								type = "input", 
								order = 6+(k*4), 
								set = function (info, val)Gratz.db.profile.TestList[k].ID = val end,
								get = function () return Gratz.db.profile.TestList[k].ID end}
	testUI.args["del"..k] = {	width = "half",
								name = "Delete",
								type = "execute", 
								order = 7+(k*4), 
								func = function ()	Gratz:RemoveTestUI() 
													Gratz:RemoveTest(k) 
													Gratz:FillTestUI()
										end}
end
function Gratz:FillTestUI()
	for k = 1, Gratz:TableSize(Gratz.db.profile.TestList) do
		Gratz:AddTestUI(k)
	end
end
function Gratz:AddTest()
	tinsert(Gratz.db.profile.TestList,{Name = "", Realm = "", ID = 0})
end
function Gratz:RemoveTest(k)
	for i = k+1, Gratz:TableSize(Gratz.db.profile.TestList) do
		Gratz.db.profile.TestList[i-1] = Gratz.db.profile.TestList[i]
	end
	tremove(Gratz.db.profile.TestList,Gratz:TableSize(Gratz.db.profile.TestList))
end

 testUI =	{type = "group", 
			name = "Test", 
			args = {
					addButton = {	type = "execute",
									name = "Add", 
									order = 1, 
									func = function()	Gratz:AddTest() 
														Gratz:AddTestUI(Gratz:TableSize(Gratz.db.profile.TestList)) 
											end},
					testButton = {	type = "execute", 
									name = "Test", 
									order = 2, 
									func = function () 
														for k = 1,Gratz:TableSize(Gratz.db.profile.TestList) do 
															Gratz:ProcessAchieve(Gratz.db.profile.TestList[k].Name, Gratz.db.profile.TestList[k].Realm, Gratz.db.profile.TestList[k].ID, "Test") 
														end
											end},
					borderH = {		type = "header", 
									name = "Tests", 
									order = 3}
					}
}
--Sorting values
-- 1 = Time, Oldest to Newest
-- -1 = Time, Newest to Oldest
-- 2 = Name, A to Z
-- -2 = Name, Z to A
-- 3 = Realm, A to Z
-- -3 = Realm, Z to A
-- Time Format
-- 1 = 12 AM PM
-- 2 = 24
-- DateFormat
-- 1 Month/Day/Year
-- 2 Day/Month/Year

-- Database Management

function Gratz:AddNewSpecific(id)
	if Gratz.db.profile.SpecificAchievementGratz[id] == nil then
		Gratz.db.profile.SpecificAchievementGratz[id] = {Enabled = true, Ignore = false, SingleMessages = {}, GroupMessages = {}, Priority = 1}
	end
end
function Gratz:RemoveSpecific(id)
	if Gratz.db.profile.SpecificAchievementGratz[id] ~= nil then
		Gratz.db.profile.SpecificAchievementGratz[id] = nil
	end
end
--Ding


function Gratz:AddNewDing(message)
	table.insert(Gratz.db.profile.DingGratz, message)
end
function Gratz:RemoveDing(index)
	table.remove(Gratz.db.profile.DingGratz, index)
end




-- 
-- ========================================================================================== --
--	Specific Achievement Gratz Interface
-- ========================================================================================== --
local tempAchieveID = 1070;
local specificConfig = {
		type = "group",
		name = "Specific Achievements",
		args = {
					AchieveName = {	type = "description",
									name = "",
									order = 2 },
					AchieveDesc = {
									type = "description",
									name = "",
									order = 3},
					AddAchieve = {
									type = "execute",
									name = "Add",
									order = 4,
									func = function () 
												if GetAchievementInfo(tempAchieveID) ~= nil then
													if Gratz.db.profile.SpecificAchievementGratz[tempAchieveID] == nil then
						--Gratz.db.profile.SpecificAchievementGratz[tempAchieveID]
														Gratz:AddNewSpecific(tempAchieveID)
														Gratz:AddSpecificAchieveUI (tempAchieveID)
													end
												end
											end
				},
					NewAchieveBox = {
									type = "input",
									order = 1,
									name = "Achievement ID",
									get = function ()  return tempAchieveID end,
									set = function (info, val) Gratz:UpdateAchieveDesc (val)end,
									order = 1
					},
					Delay = {		type = "description",
									name = "Note:  It may take a moment for this to fill up once you first log on.",
									order = 5 }
		}
}
function Gratz:FillSpecificAchieves()
	Gratz:ScheduleTimer(function () for k,v in pairs (Gratz.db.profile.SpecificAchievementGratz) do

										Gratz:AddSpecificAchieveUI (k)
									end  
							end, 20, {})
	
end

function Gratz:AddNewGroupSpecific(key)
	tinsert(Gratz.db.profile.SpecificAchievementGratz[key].GroupMessages, "Gratz")
	Gratz:AddToGroupSpecificUI(key, Gratz:TableSize(Gratz.db.profile.SpecificAchievementGratz[key].GroupMessages))
end

function Gratz:RemoveGroupSpecificUI(key, index)
	--Gratz.db.profile.SpecificAchievementGratz[tostring(key)].SingleMessages
	for k = 1, Gratz:TableSize(Gratz.db.profile.SpecificAchievementGratz[key].GroupMessages) do
		specificConfig.args[tostring(key)].args.GroupGroup.args[tostring(k)] = nil
	end
	specificConfig.args[tostring(key)].args.GroupGroup.args[tostring(index)] = nil
	tremove(Gratz.db.profile.SpecificAchievementGratz[(key)].GroupMessages, index)
	--Gratz.db.profile.SpecificAchievementGratz[(key)].SingleMessages[(index)] = nil
	for k,v in pairs (Gratz.db.profile.SpecificAchievementGratz[key].GroupMessages) do
		Gratz:AddToGroupSpecificUI(key, k)
		
	end
end
function Gratz:AddToGroupSpecificUI(key, index)
	specificConfig.args[tostring(key)].args.GroupGroup.args[tostring(index)] = {
			type = "group",
			name = index..". "..Gratz.db.profile.SpecificAchievementGratz[key].GroupMessages[index],
			args = {
				Delete = {	type = "execute", 
							name = "Delete", 
							func = function() Gratz:RemoveGroupSpecificUI(key, index) end,
							order = 2},
				message = {	type = "input", 
							name = "Message",
							set = function(info, val)	specificConfig.args[tostring(key)].args.GroupGroup.args[tostring(index)].name =index..". ".. val 
														Gratz.db.profile.SpecificAchievementGratz[(key)].GroupMessages[(index)] =val end, 
							get = function () return Gratz.db.profile.SpecificAchievementGratz[(key)].GroupMessages[(index)] end,
							order =1}
			}

	}
	
end
function Gratz:RemoveSpecificAchieveUI(key)
specificConfig.args[tostring(key)] = nil

end
function Gratz:SetAchieveIgnore(id, name, val)
	if val then
		specificConfig.args[tostring(id)].name = "|cffff0000"..name
	else
		specificConfig.args[tostring(id)].name = name
	end
end
function Gratz:AddSpecificAchieveUI (key)
	
	local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText = GetAchievementInfo(key)
	if Name == nil then
		return false
	end
	specificConfig.args[tostring(key)] = {	type = "group",
											order = 5,
											name = Name,
											args = { --|cffff0000"..
													AchieveName = {		type = "description", 
																		fontSize = "large", 
																		name = Name, 
																		order = 1,
																		icon = Image },
													AchieveDesc = {		type = "description", 
																		name = Description, 
																		order = 2},
													AchieveIgnore = {	type = "toggle", 
																		name = "Ignore", 
																		order = 3, 
																		set = function (info, val) Gratz.db.profile.SpecificAchievementGratz[key].Ignore = val Gratz:SetAchieveIgnore(key, Name, val) end, 
																		get = function () return Gratz.db.profile.SpecificAchievementGratz[key].Ignore  end},
													EnabledTog = {		type = "toggle", 
																		name = "Enabled", 
																		order = 4, 
																		set = function(info, val)Gratz.db.profile.SpecificAchievementGratz[key].Enabled= val end,
																		get = function()return Gratz.db.profile.SpecificAchievementGratz[key].Enabled end},
													DeleteAchieve = {	type = "execute", 
																		name = "Delete", 
																		func = function () 
																					Gratz:RemoveSpecific(key)
																					Gratz:RemoveSpecificAchieveUI(key)
																		end,
																		order =5},
													SingleGroup = {		type = "group", 
																		name = "Single",
																		args ={
																				AddSingleMessage = {	type = "execute",
																										name = "Add Single",
																										func = function()  Gratz:AddNewSingleSpecific(key) end}
																					}
													},
													GroupGroup = {		type = "group",
																		name = "Group",
																		args ={AddGroupMessage = {
																										type = "execute",
																										name = "Add Group",
																										func = function()Gratz:AddNewGroupSpecific(key) end} 
																		}
								}
											}


	}
	 Gratz:SetAchieveIgnore(key, Name, Gratz.db.profile.SpecificAchievementGratz[key].Ignore)
--Gratz.db.profile.SpecificAchievementGratz[id] = {Enabled = true, Ignore = false, SingleMessages = {}, GroupMessages = {}, Priority = 1}
	for k,v in pairs (Gratz.db.profile.SpecificAchievementGratz[key].SingleMessages) do
		Gratz:AddToSingleSpecificUI(key, k)
		
	end
	for k,v in pairs (Gratz.db.profile.SpecificAchievementGratz[key].GroupMessages) do
		Gratz:AddToGroupSpecificUI(key, k)
	end
end
function Gratz:AddNewSingleSpecific(key)
	tinsert(Gratz.db.profile.SpecificAchievementGratz[key].SingleMessages, "Gratz")
	Gratz:AddToSingleSpecificUI(key, Gratz:TableSize(Gratz.db.profile.SpecificAchievementGratz[key].SingleMessages))
end

function Gratz:RemoveSingleSpecific(key, index)
	--Gratz.db.profile.SpecificAchievementGratz[tostring(key)].SingleMessages
	 
end
function Gratz:RemoveSingleSpecificUI(key, index)
	--Gratz.db.profile.SpecificAchievementGratz[tostring(key)].SingleMessages
	for k = 1, Gratz:TableSize(Gratz.db.profile.SpecificAchievementGratz[key].SingleMessages) do
		specificConfig.args[tostring(key)].args.SingleGroup.args[tostring(k)] = nil
	end
	specificConfig.args[tostring(key)].args.SingleGroup.args[tostring(index)] = nil
	tremove(Gratz.db.profile.SpecificAchievementGratz[(key)].SingleMessages, index)
	--Gratz.db.profile.SpecificAchievementGratz[(key)].SingleMessages[(index)] = nil
	for k,v in pairs (Gratz.db.profile.SpecificAchievementGratz[key].SingleMessages) do
		Gratz:AddToSingleSpecificUI(key, k)
		
	end
end
function Gratz:AddToSingleSpecificUI(key, index)
	specificConfig.args[tostring(key)].args.SingleGroup.args[tostring(index)] = {
			type = "group",
			name = index..". "..Gratz.db.profile.SpecificAchievementGratz[key].SingleMessages[index],
			args = {
				Delete = {			type = "execute", 
									name = "Delete", 
									func = function() Gratz:RemoveSingleSpecificUI(key, index) end,
									order = 2},
				message = {			type = "input", 
									name = "Message",
									set = function(info, val)	specificConfig.args[tostring(key)].args.SingleGroup.args[tostring(index)].name =index..". ".. val 
														Gratz.db.profile.SpecificAchievementGratz[(key)].SingleMessages[(index)] =val 
									end, 
									get = function () return Gratz.db.profile.SpecificAchievementGratz[(key)].SingleMessages[(index)] end,
									order =1},
				IndividualDesc = {
									type = "description",
									order = 2,
									name = L["INDIVIDUAL_MESSAGE_DESC"] .."\n"..L["INDIVIDUAL_MESSAGE_DESC1"]}
			}

	}
	
end
function Gratz:UpdateAchieveDesc (val)
	if GetAchievementInfo(val) ~= nil then
		IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText = GetAchievementInfo(val)
		tempAchieveID = val
		specificConfig.args.AchieveName.name = "Name: "..Name;
		specificConfig.args.AchieveDesc.name = Description
	else
		specificConfig.args.AchieveName.name = "Name: ";
		specificConfig.args.AchieveDesc.name = ""
	end
end
--IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText = GetAchievementInfo(achievementID or categoryID, index)

-- ========================================================================================== --
--	Special Gratz Interface
-- ========================================================================================== --
local tempspecialname = ""
local tempspecialrealm = ""
local specialConfig = {
		type = "group",
		name = "Special Players",
		args = {
					AddPlayer = {
									type = "execute",
									name = "Add",
									order = 4,
									func = function () 
												
													if Gratz.db.profile.Specials[tempspecialname.."-"..tempspecialrealm] == nil then
														Gratz:AddNewSpecial(tempspecialname, tempspecialrealm)
														Gratz:AddSpecialAchieveUI (tempspecialname.."-"..tempspecialrealm)
													end
												
											end
				},
					NewPlayerNameBox = {
									type = "input",
									order = 1,
									name = "Player Name",
									get = function ()  return tempspecialname end,
									set = function (info, val)  tempspecialname = val end,
									order = 1
					},
					NewPlayerRealmBox = {
									type = "input",
									order = 1,
									name = "Player Realm",
									get = function ()  return tempspecialrealm end,
									set = function (info, val)  tempspecialrealm = val end,
									order = 2
					}
		}
}
function Gratz:FillSpecialAchieves()
	for k,v in pairs (Gratz.db.profile.Specials) do

		Gratz:AddSpecialAchieveUI (k)
	end  

	
end

function Gratz:AddNewGroupSpecial(name, realm)
	tinsert(Gratz.db.profile.Specials[name.."-"..realm].GroupMessages, "Gratz")
	Gratz:AddToGroupSpecialUI(name, realm, Gratz:TableSize(Gratz.db.profile.Specials[name.."-"..realm].GroupMessages))
end

function Gratz:RemoveGroupSpecialUI(name, realm, index)
	--Gratz.db.profile.Special[tostring(key)].Messages
	for k = 1, Gratz:TableSize(Gratz.db.profile.Specials[name.."-"..realm].GroupMessages) do
		specialConfig.args[name.."-"..realm].args.GroupGroup.args[tostring(k)] = nil
	end
	specialConfig.args[name.."-"..realm].args.GroupGroup.args[tostring(index)] = nil
	tremove(Gratz.db.profile.Specials[name.."-"..realm].GroupMessages, index)
	--Gratz.db.profile.Special[(key)].Messages[(index)] = nil
	for k,v in pairs (Gratz.db.profile.Specials[name.."-"..realm].GroupMessages) do
		Gratz:AddToGroupSpecialUI(name, realm, k)
		
	end
end
function Gratz:AddToGroupSpecialUI(name, realm, index)
	specialConfig.args[name.."-"..realm].args.GroupGroup.args[tostring(index)] = {
			type = "group",
			name = index..". "..Gratz.db.profile.Specials[name.."-"..realm].GroupMessages[index],
			args = {
				Delete = {	type = "execute", 
							name = "Delete", 
							func = function() Gratz:RemoveGroupSpecialUI(name, realm, index) end,
							order = 2},
				message = {	type = "input", 
							name = "Message",
							set = function(info, val)	specialConfig.args[name.."-"..realm].args.GroupGroup.args[tostring(index)].name =index..". ".. val 
														Gratz.db.profile.Specials[name.."-"..realm].GroupMessages[(index)] =val end, 
							get = function () return Gratz.db.profile.Specials[name.."-"..realm].GroupMessages[(index)] end,
							order =1}
			}

	}
	
end
function Gratz:RemoveSpecialAchieveUI(name, realm)
	specialConfig.args[name.."-"..realm] = nil
end
function Gratz:SetPlayerIgnore(name, realm, val)
	if val then
		specialConfig.args[name.."-"..realm].name = "|cffff0000"..name.."-"..realm
	else
		specialConfig.args[name.."-"..realm].name = name.."-"..realm
	end
end
function Gratz:AddSpecialAchieveUI (key)
	local name, realm = Gratz:splitAtFirst(key, "-")
	specialConfig.args[key] = {	type = "group",
											order = 5,
											name = key,
											args = { --|cffff0000"..
													PlayerIgnore = {	type = "toggle", 
																		name = "Ignore", 
																		order = 3, 
																		set = function (info, val) Gratz:SetPlayerIgnore(name, realm, val) Gratz.db.profile.Specials[name.."-"..realm].Ignore = val end, 
																		get = function () return Gratz.db.profile.Specials[name.."-"..realm].Ignore  end},
													EnabledTog = {		type = "toggle", 
																		name = "Enabled", 
																		order = 4, 
																		set = function(info, val)Gratz.db.profile.Specials[name.."-"..realm].Enabled= val end,
																		get = function()return Gratz.db.profile.Specials[name.."-"..realm].Enabled end},
													DeletePlayer = {	type = "execute", 
																		name = "Delete", 
																		func = function () 
																					Gratz:RemoveSpecial(name, realm)
																					Gratz:RemoveSpecialAchieveUI(name, realm)
																		end,
																		order =5},
													WhispTog = {		type = "toggle",
																		name = "Whisper",
																		order = 4,
																		set = function (info, val) Gratz.db.profile.Specials[name.."-"..realm].Whisper = val end,
																		get = function () return Gratz.db.profile.Specials[name.."-"..realm].Whisper end },
													SingleGroup = {		type = "group", 
																		name = "Single",
																		args ={
																				AddSingleMessage = {	type = "execute",
																										name = "Add Single",
																										func = function()  Gratz:AddNewSingleSpecial(name, realm) end}
																					}
													},
													GroupGroup = {		type = "group",
																		name = "Group",
																		args ={AddGroupMessage = {
																										type = "execute",
																										name = "Add Group",
																										func = function()Gratz:AddNewGroupSpecial(name, realm) end} 
																		}
								}
							}

	}
	 Gratz:SetPlayerIgnore(name, realm, Gratz.db.profile.Specials[name.."-"..realm].Ignore)
--Gratz.db.profile.Special[id] = {Enabled = true, Ignore = false, Messages = {}, GroupMessages = {}, Priority = 1}
	for k,v in pairs (Gratz.db.profile.Specials[name.."-"..realm].Messages) do
		Gratz:AddToSingleSpecialUI(name, realm, k)
		
	end
	for k,v in pairs (Gratz.db.profile.Specials[name.."-"..realm].GroupMessages) do
		Gratz:AddToGroupSpecialUI(name, realm, k)
	end
end
function Gratz:AddNewSingleSpecial(name, realm)
	tinsert(Gratz.db.profile.Specials[name.."-"..realm].Messages, "Gratz")
	Gratz:AddToSingleSpecialUI(name, realm, Gratz:TableSize(Gratz.db.profile.Specials[name.."-"..realm].Messages))
end

function Gratz:RemoveSingleSpecific(name, realm, index)
	--Gratz.db.profile.Special[tostring(key)].Messages
	 
end
function Gratz:RemoveSingleSpecialUI(name, realm, index)
	--Gratz.db.profile.Special[tostring(key)].Messages
	for k = 1, Gratz:TableSize(Gratz.db.profile.Specials[name.."-"..realm].Messages) do
		specialConfig.args[name.."-"..realm].args.SingleGroup.args[tostring(k)] = nil
	end
	specialConfig.args[name.."-"..realm].args.SingleGroup.args[tostring(index)] = nil
	tremove(Gratz.db.profile.Specials[name.."-"..realm].Messages, index)
	--Gratz.db.profile.Special[(key)].Messages[(index)] = nil
	for k,v in pairs (Gratz.db.profile.Specials[name.."-"..realm].Messages) do
		Gratz:AddToSingleSpecialUI(name, realm, k)
		
	end
end
function Gratz:AddToSingleSpecialUI(name, realm, index)
	specialConfig.args[name.."-"..realm].args.SingleGroup.args[tostring(index)] = {
			type = "group",
			name = index..". "..Gratz.db.profile.Specials[name.."-"..realm].Messages[index],
			args = {
				Delete = {			type = "execute", 
									name = "Delete", 
									func = function() Gratz:RemoveSingleSpecialUI(name, realm, index) end,
									order = 2},
				message = {			type = "input", 
									name = "Message",
									set = function(info, val)	specialConfig.args[name.."-"..realm].args.SingleGroup.args[tostring(index)].name =index..". ".. val 
														Gratz.db.profile.Specials[name.."-"..realm].Messages[(index)] =val 
									end, 
									get = function () return Gratz.db.profile.Specials[name.."-"..realm].Messages[(index)] end,
									order =1},
				IndividualDesc = {
									type = "description",
									order = 2,
									name = L["INDIVIDUAL_MESSAGE_DESC"] .."\n"..L["INDIVIDUAL_MESSAGE_DESC1"]}
			}

	}
	
end


-- ======================================================================================================================							
local GratzMain = {
						type = "group",
						name = "Gratz",
						args = {
									AFK =	{
												type = "toggle",
												name = L["AFK"] ,
												order = 7,
												get =	function () 
															return Gratz.db.profile.AFKon 
														end,
												set =	function (info, val) 
															Gratz.db.profile.AFKon = val
														end,
												desc = L["AFK_DESC"]
									},
									UseRealm = {type = "toggle", 
												name = "Include Realm Name", 
												get = function () return Gratz.db.profile.UseRealm end, 
												order = 7,
												set = function (info, val) Gratz.db.profile.UseRealm = val end, 
												desc = "Sets whether to include the realm name of a player in the gratz" },
									Groups = {
												type = "multiselect",
												name = L["CHANNEL"] ,
												desc = L["CHANNEL_DESC"] ,
												order = 8,
												values = {L["PARTY"],L["RAID"],L["BATTLEGROUND"],L["GUILD"], L["NEARBY"]},
												get =	function (info, k)  
															return Gratz.db.profile.ActiveGratz[k]  
														end,
												set =	function (info, k, newv) 

															Gratz.db.profile.ActiveGratz[k] = newv 
														end
									},
									mindelay = {
												type = "range",
												name = L["MINDELAY"],
												min = 1,
												max = 60,
												step = 1,
												order = 2,
												get = function () return Gratz.db.profile.MinDelay end,
												set = function (info, val) 
														if val <=Gratz.db.profile.Delay then
															Gratz.db.profile.MinDelay = val	
														end

												end
									},
									delay = {
												type = "range",
												name = L["MAXDELAY"],
												min = 1,
												order = 3,
												max = 60,
												step = 1,
												get =	function () 
															return Gratz.db.profile.Delay 
														end,
												set =	function (info, val) 
															if val >= Gratz.db.profile.MinDelay then
																Gratz.db.profile.Delay = val 
															end
														end
									},

							PrioritiesHeader = {	type = "header", 
													order = 9, 
													name = "Priorities"},
							NormalPriority = {		type = "select", 
													style = "dropdown", 
													name = "Normal", 
													values = {1,2,3},
													get = function () return Gratz.db.profile.Priorities.Normal end, 
													set = function (info, val) Gratz.db.profile.Priorities.Normal = val end, order =10},
							SpecificPriority = {	type = "select", 
													style = "dropdown", 
													name = "Specific", 
													values = {1,2,3},
													get = function () return Gratz.db.profile.Priorities.Specific end, 
													set = function (info, val) Gratz.db.profile.Priorities.Specific = val end, order =11},
							SpecialPriority = {		type = "select", 
													style = "dropdown", 
													name = "Special", 
													values = {1,2,3},
													get = function () return Gratz.db.profile.Priorities.Special end, 
													set = function (info, val) Gratz.db.profile.Priorities.Special = val end, order =12},
						--	WaitlistSettings = {type = "header", name ="Wait List Settings", order = 13},
					--		WaitlistEnabled = {
					--							type = "toggle",
					--							name = "Enabled" ,
					--						order = 14,
					--							get =	function () 
					--										return Gratz.db.profile.WaitListSettings.Enabled 
					--									end,
					--							set =	function (info, val) 
					--										Gratz.db.profile.WaitListSettings.Enabled = val
					--									end,
					--							desc = "Sets whether the waitlist is enabled or not"
					--		},
					--		ReminderEnabled = {
					--							type = "toggle",
					--							name = "Reminder" ,
					--						order = 15,
						--						get =	function () 
					--										return Gratz.db.profile.WaitListSettings.Reminder 
					--									end,
					--							set =	function (info, val) 
					--										Gratz.db.profile.WaitListSettings.Reminder = val
					--									end,
					--							desc = "Sets whether the reminder function for achieves on the wait list is on."
					--		},
					--		ReminderTime = {type = "input", 
					--						name = "Reminder Time", 
					--						get = function () return Gratz.db.profile.WaitListSettings.ReminderDelay end, 
					--						set = function (info, val) if tonumber(val) ~= nil then if tonumber(val) > 0 then Gratz.db.profile.WaitListSettings.ReminderDelay = val end end end, 
					--						order = 16},
							TestHeader = {	type = "header", 
											name ="Test Buttons", 
											order = 90},
							TestGuildSingle = {	type ="execute", 
												name = "Test Guild Single",
												order = 90, 
												func = function() 
							Gratz:AddToGuildQueueNormal("TEST", "TEST", 123)
			GuildQueueTimer =Gratz:ScheduleTimer("GuildQueueTimerFunc", random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay))
		
													--Gratz:AddToNeoPending("Guild", "THIS IS A TEST", "TEST", 1)
													--Gratz:PrintoutNeoPending()
													--if guildTimer == nil then
													--	guildTimer = Gratz:ScheduleTimer("SendGuildGratz", random(1,Gratz.db.profile.Delay), {})
													--end
							end},
							TestGuildGroup = {	type ="execute", 
												name = "Test Guild Group",
												order = 90, 
												func = function() 
																Gratz:AddToNeoPending("Guild", "THIS IS A TEST", "TEST", 1)
																Gratz:AddToNeoPending("Guild", "THIS IS A TEST2", "TEST2", 1)
																Gratz:PrintoutNeoPending()
																if guildTimer == nil then
																	guildTimer = Gratz:ScheduleTimer("SendGuildGratz", random(1,Gratz.db.profile.Delay), {})
																end
												end},
							TestRaidGroup = {	type ="execute", 
												name = "Test Raid Group",
												order = 90, 
												func = function() 
															Gratz:AddToNeoPending("Raid", "THIS IS A TEST", "TEST", 1)
															Gratz:AddToNeoPending("Raid", "THIS IS A TEST2", "TEST2", 1)
															Gratz:PrintoutNeoPending()
															if raidTimer == nil then
																raidTimer = Gratz:ScheduleTimer("SendRGratz",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
															end
												end}
								}
					}
-- =======================================================================================================
-- Ding Gratz UI
-- ======================================================================================================================							
local DingGratzOptions =	{
								type = "group",
								name = L["DING_GROUP"],
								args =	{
	DingEnabled =	{
						type = "toggle",
						name = L["ENABLED"],
						order = 1,
						get = function () return Gratz.db.profile.DingOn end,
						set = function (info, val) Gratz.db.profile.DingOn = val end
	
					},
	DingGroups =	{
						type = "multiselect",
						name = L["DING_GROUP_DESC"],
						values = {L["RAID"], L["PARTY"], L["BATTLEGROUND"], L["GUILD"], "Whisper"},
						get = function(info, val) return true end,
						set = function (info, Key, newValue) end, --DingChannels
						order = 2,
					},
	AddDing =		{
						type = "execute",
						name = L["ADD_MESSAGE"],
						order = 3,
						func = function () Gratz:AddDing() end
					}

										}
}

function Gratz:RemoveDing(index)
	DingGratzOptions.args[tostring(index)] = nil
	DingGratzOptions.args[tostring(#Gratz.db.profile.DingGratz)] = nil
	tremove(Gratz.db.profile.DingGratz,index)
	for i = index, #Gratz.db.profile.DingGratz  do
		DingGratzOptions.args[tostring(i)] = nil
		Gratz:AddDingToUI(i)
	end
end
					
function Gratz:AddDing()
	tinsert(Gratz.db.profile.DingGratz,{Message =L["DINGGRATZ1"]})
	Gratz:AddDingToUI(#Gratz.db.profile.DingGratz)
end

function Gratz:AddDingToUI(index)
	if key == 0 then
		Gratz.db.profile.DingGratz[key] = nil
		return false;
	end
	orderi,orderf = math.modf(index/10)
	DingGratzOptions.args[tostring(index)] =	{
			type = "group",
			name = index..". "..Gratz.db.profile.DingGratz[index].Message,
			order = 2 + orderi,
			args =	{
						DingMessageBox =	{
												type = "input",
												name = L["DING_NAME"],
												set = function (info, val) 
															Gratz.db.profile.DingGratz[index].Message = val
															DingGratzOptions.args[tostring(index)].name = index..". "..Gratz.db.profile.DingGratz[index].Message
														end,
												get = function() return Gratz.db.profile.DingGratz[index].Message end,
												order = 1,
												width = "full"
											},
						DingSpecialDesc =	{
												type = "description",
												name = L["DING_DESC"].."\n"..L["DING_DESC1"].."\n"..L["DING_DESC2"] .."\n"..L["DING_DESC3"],
												order = 2
											},
						RemoveDing =		{
												type = "execute",
												name = L["DELETE"] ,
												order = 3,
												func = function ()Gratz:RemoveDing(index) end
											}
					}
												}

end					

function Gratz:FillUpDing()
	for key, val in pairs (Gratz.db.profile.DingGratz) do
		Gratz:AddDingToUI(key)
	end	
end
function Gratz:ClearDing()
	for key, val in pairs (Gratz.db.profile.DingGratz) do
		DingGratzOptions.args[tostring(key)] = nil
	end	
end
-- =======================================================================================================
--	Individual Gratz.
-- ===================================================================================================================					
local IndividualGratzOptions =		{
										type = "group",
										name = L["INDIVIDUAL_NAME"],
										args = {
					AddButton = {
									type = "execute",
									name = L["ADD_MESSAGE"],
									order = 1,
									func = function () tinsert(Gratz.db.profile.IndividualGratz,{Message = L["INDIVIDUALGRATZ1"], groups = {true ,true,  true,  true},#Gratz.db.profile.IndividualGratz+1 })
														Gratz:AddIndividualMessage(#Gratz.db.profile.IndividualGratz)
											end
								}
										
												}

}

function Gratz:AddIndividualMessage(key)
	if key == 0 then
		Gratz.db.profile.IndividualGratz[key] = nil
		return false;
	end
	if Gratz.db.profile.IndividualGratz == nil then
		return false
	end
if Gratz.db.profile.IndividualGratz[key] == nil then
		return false
	end
	orderi,orderf = math.modf(key/10)
	IndividualGratzOptions.args[tostring(key)] =	{
										type = "group",
										name = tostring(key)..". "..self.db.profile.IndividualGratz[key].Message,
										order = 2 + orderi,
										args = {
													MessageBox = {
																		type = "input",
																		get = function() return self.db.profile.IndividualGratz[key].Message end,
																		name = L["INDIVIDUAL_MESSAGE"],
																		set = function(info, val) self.db.profile.IndividualGratz[key].Message = val 
																		IndividualGratzOptions.args[tostring(key)].name = tostring(key)..". "..self.db.profile.IndividualGratz[key].Message
																		end,
																		order = 1,
																		width = "full"},
													IndividualDesc = {
																		type = "description",
																		order = 2,
																		name = L["INDIVIDUAL_MESSAGE_DESC"] .."\n"..L["INDIVIDUAL_MESSAGE_DESC1"]},
													Delete = {
																		type = "execute",
																		name = L["DELETE"],
																		func = function () 
																				IndividualGratzOptions.args[tostring(key)] = nil	--Remove this one from the list in the UI.
																				IndividualGratzOptions.args[tostring(#Gratz.db.profile.IndividualGratz)] = nil --Remove the last one from UI.
																				tremove(Gratz.db.profile.IndividualGratz,key)	-- Remove from DB
																				for i = key, #Gratz.db.profile.IndividualGratz  do --Reposition
																					IndividualGratzOptions.args[tostring(i)] = nil
																					Gratz:AddIndividualMessage(i)
																				end
																		end} 
											}

										}
end
function Gratz:FillIndividualGratzOptions()
	for key, val in pairs (self.db.profile.IndividualGratz) do
		Gratz:AddIndividualMessage(key)
	end

end
function Gratz:ClearIndividualGratz()
	for key, val in pairs (IndividualGratzOptions.args) do
		IndividualGratzOptions.args[tostring(key)] = nil
	end
end

-- =======================================================================================================
--	Guild Gratz
-- =======================================================================================================
local GuildGratzMenu	=  {

			type = "group",
			name = "Guild Gratz",
			args = {
						guilddesc = {
								type = "description",
								name = "These are gratzs only for guildies."
						},
						useOnlyGuildGratz = {
									type = "toggle",
									name = "Only use guild gratz in guild",
									get = function () return Gratz.db.profile.UseOtherGratzForGuild end,
									set = function(info, val)Gratz.db.profile.UseOtherGratzForGuild=val end
						
						},
						SingleGuildieGratz = {
													type = "group",
													name = "Single",
													order = 1,
													args = {
													AddSingleGuildGratz = {
																	type = "execute",
																	name = "Add Message",
																	func = function () Gratz:AddSingleGuild (L["GUILD_SINGLE_GRATZ"]) end
																		}

															}
						},
				GroupGuildieGratz = {
													type = "group",
													name = "Group",
													order = 2,
													args = {
													AddGroupGuildGratz = {
																	type = "execute",
																	name = "Add Message",
																	func = function () Gratz:AddGroupGuild (L["GUILD_GROUP_GRATZ"]) end
																		}

															}
											}
			
						}




}
function Gratz:TestGuildGroupMessage (message)

	mess = message
	guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	mess  = string.gsub(mess, "#g", guildName)
	englishFaction, localizedFaction = UnitFactionGroup("player")
	mess  = string.gsub(mess, "#f", localizedFaction)
	mess =  string.gsub(mess, "#e", L["Alliance"])

end
function Gratz:AddGroupGuild (message)
	--Gratz.db.profile.GuildGratzGroup[#Gratz.db.profile.GuildGratzGroup] = {Message = message}
	tinsert(Gratz.db.profile.GuildGratzGroup,{Message = message})
	Gratz:AddGroupGuildUI (#Gratz.db.profile.GuildGratzGroup)
end
function Gratz:AddGroupGuildUI (key)
	if key == 0 then
		Gratz.db.profile.GuildGratzGroup[key] = nil
		return false;
	end
orderi,orderf = math.modf(key/10)
	if Gratz.db.profile.GuildGratzGroup == nil then
		return false
	end
if Gratz.db.profile.GuildGratzGroup[key] == nil then
		return false
	end
	if key == 0 then
	tremove(Gratz.db.profile.GuildGratzGroup,key)
		return false
	end
	GuildGratzMenu.args.GroupGuildieGratz.args[tostring(key)] = {
															type = "group",
															name = key..". "..Gratz.db.profile.GuildGratzGroup[key].Message,
															order = 2+orderi,
															args = {
																		MessageBox = {
																				type = "input",
																				name = "Message",
																				get = function () return Gratz.db.profile.GuildGratzGroup[key].Message end,
																				set = function (info, val) 
																					GuildGratzMenu.args.GroupGuildieGratz.args[tostring(key)].name = key..". "..val
																					Gratz.db.profile.GuildGratzGroup[key].Message = val end,
																				order = 1,
																				width = "full"
																		},
																		desc = {
																			type = "description",
																			name = "INSERT HERE",
																			order = 2
																		},
																		RemoveButton = {
																			type = "execute",
																			name = "Delete",
																			order = 3,
																			func = function () 
																			
																						GuildGratzMenu.args.GroupGuildieGratz.args[tostring(key)] = nil	--Remove this one from the list in the UI.
																						GuildGratzMenu.args.GroupGuildieGratz.args[tostring(#Gratz.db.profile.GuildGratzGroup)] = nil --Remove the last one from UI.
																						tremove(Gratz.db.profile.GuildGratzGroup,key)	-- Remove from DB
																						for i = key, #Gratz.db.profile.GuildGratzGroup  do --Reposition
																							GuildGratzMenu.args.GroupGuildieGratz.args[tostring(i)] = nil
																							Gratz:AddGroupGuildUI(i)
																						end
																			end
																		},
			TestButton = {
				name = L["TEST"],
				type = "execute",
				order = 4,
				func = function() Gratz:TestGuildGroupMessage (Gratz.db.profile.GuildGratzGroup[key].Message)   end


	}

																	}


	}
end
function Gratz:TestGuildSingleMessage (message)

	mess = message
	mess  = string.gsub(mess, "#n", UnitName("player") )
	mess  = string.gsub(mess, "#x", 2)
	guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	mess  = string.gsub(mess, "#g", guildName)
	englishFaction, localizedFaction = UnitFactionGroup("player")
	mess  = string.gsub(mess, "#f", localizedFaction)
	mess =  string.gsub(mess, "#e", L["Alliance"])

end
function Gratz:AddSingleGuild (message)
	--tinsert(Gratz.db.profile.GuildGratzSingle,{Message = message})
	--Gratz.db.profile.GuildGratzSingle[#Gratz.db.profile.GuildGratzSingle] = {Message = message}
	tinsert(Gratz.db.profile.GuildGratzSingle,{Message = message})
	Gratz:AddSingleGuildUI (#Gratz.db.profile.GuildGratzSingle)
end


function Gratz:AddSingleGuildUI (key)
	if key == 0 then
		Gratz.db.profile.GuildGratzSingle[key] = nil
		return false;
	end

	if Gratz.db.profile.GuildGratzSingle == nil then
		return false
	end
if Gratz.db.profile.GuildGratzSingle[key] == nil then
		return false
	end
	orderi,orderf = math.modf(key/10)
	GuildGratzMenu.args.SingleGuildieGratz.args[tostring(key)] = {
															type = "group",
															name = key..". "..Gratz.db.profile.GuildGratzSingle[key].Message,
															order = 2+orderi,
															args = {
																		MessageBox = {
																				type = "input",
																				name = "Message",
																				get = function () return Gratz.db.profile.GuildGratzSingle[key].Message end,
																				set = function (info, val) 
																					GuildGratzMenu.args.SingleGuildieGratz.args[tostring(key)].name = key..". "..val
																					Gratz.db.profile.GuildGratzSingle[key].Message = val end,
																				order = 1,
																				width = "full"
																		},
																		desc = {
																			type = "description",
																			name = "INSERT HERE",
																			order = 2
																		},
																		RemoveButton = {
																			type = "execute",
																			name = "Delete",
																			order = 3,
																			func = function () 
																			
																						GuildGratzMenu.args.SingleGuildieGratz.args[tostring(key)] = nil	--Remove this one from the list in the UI.
																						GuildGratzMenu.args.SingleGuildieGratz.args[tostring(#Gratz.db.profile.GuildGratzSingle)] = nil --Remove the last one from UI.
																						tremove(Gratz.db.profile.GuildGratzSingle,key)	-- Remove from DB
																						for i = key, #Gratz.db.profile.GuildGratzSingle  do --Reposition
																							GuildGratzMenu.args.SingleGuildieGratz.args[tostring(i)] = nil
																							Gratz:AddSingleGuildUI(i)
																						end
																			end
																		},
			TestButton = {
				name = L["TEST"],
				type = "execute",
				order = 4,
				func = function() Gratz:TestGuildSingleMessage (Gratz.db.profile.GuildGratzSingle[key].Message)   end


	}

																	}


	}
end

function Gratz:FillUpGuildGratz()
	--Single
	for k, v in pairs (Gratz.db.profile.GuildGratzSingle) do
		Gratz:AddSingleGuildUI (k)
	end
	for k, v in pairs (Gratz.db.profile.GuildGratzGroup) do
		Gratz:AddGroupGuildUI (k)
	end
end
function Gratz:ClearGuildGratz()
	for k, v in pairs (GuildGratzMenu.args.SingleGuildieGratz.args) do
		GuildGratzMenu.args.SingleGuildieGratz.args[tostring(k)] = nil
	end
	for k, v in pairs (GuildGratzMenu.args.GroupGuildieGratz.args) do
		GuildGratzMenu.args.GroupGuildieGratz.args[tostring(k)] = nil
	end
end
-- ===================================================================================================================
--	Group Gratz UI
-- ===================================================================================================================
local GroupGratzOptions =		{
										type = "group",
										name = "Group Gratz",
										args = {
													AddButton = {
																	type = "execute",
																	name = L["ADD_MESSAGE"],
																	order = 1,
																	func = function () tinsert(Gratz.db.profile.GroupGratz,{Message = "Congratz everyone", groups = {true ,true,  true,  true},#Gratz.db.profile.IndividualGratz+1 })
																						Gratz:AddGroupMessage(#Gratz.db.profile.GroupGratz)
																			end
																}
												}
}	
	
function Gratz:AddGroupMessage(key)
	GroupGratzOptions.args[tostring(key)] =	{
										type = "group",
										name = tostring(key).."."..self.db.profile.GroupGratz[key].Message,
										order = 2,
										args = {
								MessageBox = {
												type = "input",
												get = function() return self.db.profile.GroupGratz[key].Message end,
												name = L["GROUP_MESSAGE_NAME"],
												set =	function(info, val) 
															self.db.profile.GroupGratz[key].Message = val 
															GroupGratzOptions.args[tostring(key)].name = tostring(key).."."..self.db.profile.GroupGratz[key].Message
														end,
												order = 1,
												width = "full"
											},
								TestButton = {
									type = "execute",
									name = L["TEST"],
									func = function ()Gratz:TestGroupGratz (self.db.profile.GroupGratz[key].Message )  end
								},
								Delete =	{
												type = "execute",
												name = L["DELETE"],
												func =	function () 
															GroupGratzOptions.args[tostring(key)] = nil
															GroupGratzOptions.args[tostring(#Gratz.db.profile.GroupGratz)] = nil
															tremove(Gratz.db.profile.GroupGratz,key)
															for i = key, #Gratz.db.profile.GroupGratz  do
																GroupGratzOptions.args[tostring(i)] = nil
																Gratz:AddGroupMessage(i)
															end
														end

											}
												}

										}
end	
function Gratz:TestGroupGratz (message)
	mess = message

	englishFaction, localizedFaction = UnitFactionGroup("player")
	mess  = string.gsub(mess, "#f", localizedFaction)
	mess =  string.gsub(mess, "#e", L["Alliance"])



end
function Gratz:FillGroupGratzOptions()
	for key, val in pairs (self.db.profile.GroupGratz) do
		Gratz:AddGroupMessage(key)
	end

end
function Gratz:ClearGroupGratzOptions()
	for key, val in pairs (GroupGratzOptions.args) do
		GroupGratzOptions.args[tostring(key)] = nil
	end
end
--	BG Victory
-- =======================================================================================================
local BGVictoryOptions = {
							type = "group",
							name = L["BG_VICTORY_GROUP"],
							order = 3,
							args =	{
	AddMessage =	{
						type = "execute",
						name = L["ADD_MESSAGE"],
						func =	function () 
									Gratz:AddBGVictToDB();
								end,
						order = 1
					},
	EnableVictory =	{
						type = "toggle",
						name = L["ENABLED"],
						get =	function () 
									return Gratz.db.profile.BGGratzOn 
								end,
						set =	function (info, val) 
									Gratz.db.profile.BGGratzOn = val 
								end,
						order = 2
					}
									} --End of args
}
--- This function removes a Battleground Victory Message from the database 
--  and the message list in the UI.  When it removes a message, it will remove
-- the list elements of the messages after it and decrease the keys of those messages
-- by 1 before reposting them on the message list.
--
-- @param index 
function Gratz:RemoveBGVict(index)
	BGVictoryOptions.args[tostring(index)] = nil
	BGVictoryOptions.args[tostring(#Gratz.db.profile.BGGratz)] = nil
	tremove(Gratz.db.profile.BGGratz,index)
	for i = index, #Gratz.db.profile.BGGratz  do
		BGVictoryOptions.args[tostring(i)] = nil
		Gratz:AddBGVictToUI(i)
	end
end
--- This function will add a Battleground Victory Message to 
--  the UI list of Battleground Victory Messages.  The messages 
--  are ordered by 2 + how many 10's can be divided out of the 
--  message's key number.
--  Each message is given a group containing an edit box to change 
--  the message, an insert element list, showing the strings that 
--  can be replaced when the message is used, and a delete button.
-- @param index   the integer number value used to store this 
-- Battleground Victory Message.
function Gratz:AddBGVictToUI(index)
	if Gratz.db.profile.BGGratz == nil then
		return false
	end
if Gratz.db.profile.BGGratz[index] == nil then
		return false
	end
	orderi,orderf = math.modf(index/10)
	BGVictoryOptions.args[tostring(index)] =	{
			type = "group",
			name = index..". "..Gratz.db.profile.BGGratz[index].Message,
			order = 2+orderi,
			args =	{
						MessageEditBox =	{
												type = "input",
												name = L["BG_VICTORY_MESSAGE_NAME"],
												desc = L["BG_VICTORY_MESSAGE_DESC"],
												get = function () return Gratz.db.profile.BGGratz[index].Message end,
												set = function (info, val) 
													Gratz.db.profile.BGGratz[index].Message = val 
													BGVictoryOptions.args[tostring(index)].name = index..". "..Gratz.db.profile.BGGratz[index].Message
												end,
												order = 1,
												width = "full"
											},
						InsertOptionDesc =	{
												type = "description",
												order = 2,
												name = L["BG_INSERT_DESC"] .."\n"..L["BG_INSERT_DESC1"] .."\n"..L["BG_INSERT_DESC2"].."\n"..L["BG_INSERT_DESC3"]
											},
						DeleteVictory =		{
												type = "execute",
												name = L["DELETE"],
												func = function() Gratz:RemoveBGVict(index) end,
												order = 5
											}
					}
												}
end
--- This function is used to add a new Battleground 
--  victory message to the Gratz database.  It will 
--  select one of the premade Battleground Victory 
--  Messages randomly.
--
function Gratz:AddBGVictToDB()
	WhichBGVict = random(1,5)
	key = "BGVICT"..WhichBGVict
	tinsert(Gratz.db.profile.BGGratz,{Message = L[key]})
	Gratz:AddBGVictToUI(#Gratz.db.profile.BGGratz)
end
--- This function fills up the Battleground Victory 
-- Message list on the UI with those in the database.
function Gratz:FillBGVict ()
	for index = 1, #Gratz.db.profile.BGGratz do
	 Gratz:AddBGVictToUI(index)
	 end
end
function Gratz:ClearBGVict()
	for k,v in pairs(BGVictoryOptions.args) do
		BGVictoryOptions.args[tostring(k)] = nil
	end
end
function Gratz:ProfCopy (x1, x2, x3)
	print("COPY")
end
-- =======================================================================================================
function Gratz:OnInitialize()
    -- Called when the addon is loaded
	--Gratz:SetUpSpecificAchieveGratz()
	self.db = LibStub("AceDB-3.0"):New("GRATZ", defaults)
	
	Gratz:FillIndividualGratzOptions();
	Gratz:FillGroupGratzOptions()
	Gratz:FillBGVict ()
	Gratz:FillTestUI()
	Gratz:FillSpecialAchieves()
	--Gratz:FillUpSpecials();
	Gratz:FillUpDing()
	Gratz:FillUpGuildGratz()
	Gratz:FillSpecificAchieves()
	local config = LibStub("AceConfig-3.0")
	local registry = LibStub("AceConfigRegistry-3.0")
	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	registry:RegisterOptionsTable("Gratz Main", GratzMain)
	registry:RegisterOptionsTable("Individual Gratz", IndividualGratzOptions)
	registry:RegisterOptionsTable("Group Gratz", GroupGratzOptions)
	registry:RegisterOptionsTable("Battleground Victory", BGVictoryOptions)
	registry:RegisterOptionsTable("Special Players",specialConfig)
	registry:RegisterOptionsTable("Ding Gratz",DingGratzOptions)
	registry:RegisterOptionsTable("Guild Gratz",GuildGratzMenu)
	registry:RegisterOptionsTable("Specific Achievements",specificConfig)
	registry:RegisterOptionsTable("Profiles", profiles)
	registry:RegisterOptionsTable("Test",testUI)


	local dialog = LibStub("AceConfigDialog-3.0")

	self.optionFrames = {
							main		= dialog:AddToBlizOptions("Gratz Main", "Gratz"),
							Ind			= dialog:AddToBlizOptions("Individual Gratz","Individual Gratz", "Gratz"),
							gro			= dialog:AddToBlizOptions("Group Gratz","Group Gratz", "Gratz"),
							ding		= dialog:AddToBlizOptions("Ding Gratz","Ding Gratz", "Gratz"),
							guild		= dialog:AddToBlizOptions("Guild Gratz","Guild Gratz", "Gratz"),
							bg			= dialog:AddToBlizOptions("Battleground Victory","Battleground Victory", "Gratz"),
							Spe			= dialog:AddToBlizOptions("Special Players","Special Players", "Gratz"),
							Specific	= dialog:AddToBlizOptions("Specific Achievements","Specific Achievements", "Gratz"),
							profiles	= dialog:AddToBlizOptions("Profiles", "Profiles", "Gratz"),
							test		= dialog:AddToBlizOptions("Test", "Test", "Gratz")
						}

 
    -- Print a message to the chat frame
    self:RegisterEvent("CHAT_MSG_WHISPER")
    self:RegisterEvent("CHAT_MSG_ACHIEVEMENT")
    self:RegisterEvent("CHAT_MSG_GUILD")
    self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
    self:RegisterEvent("CHAT_MSG_RAID")
	self:RegisterEvent("CHAT_MSG_PARTY")
	self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	self.db.RegisterCallback(self, "OnProfileCopied ", "ProfCopy")
	self.db.RegisterCallback(self, "OnProfileChanged", "SetupOptions")
	self.db.RegisterCallback(self, "OnNewProfile", "SetupOptions")
	--self.db.RegisterCallback(self, "OnProfileCopied", "SetupOptions")
	self:SecureHook("LeaveBattlefield","BGReset")
	
end
function Gratz:NewProfile(...)
	print("New profile created")
	Gratz:SetupOptions(...)
end
function Gratz:ProfileCopied(...)
	print("Profile copied")
	Gratz:SetupOptions(...)
end
function Gratz:SetupOptions(...)
	print("E")
	Gratz:ClearIndividualGratz()
	Gratz:FillIndividualGratzOptions();
	Gratz:ClearGroupGratzOptions()
	Gratz:FillGroupGratzOptions()
	Gratz:ClearBGVict()
	Gratz:FillBGVict ()
	--Gratz:FillUpSpecials();
	Gratz:ClearDing()
	Gratz:FillUpDing()
	Gratz:ClearGuildGratz()
	Gratz:FillUpGuildGratz()
end
function Gratz:OnEnable()
    -- Called when the addon is enabled

    -- Print a message to the chat frame
    self:RegisterEvent("CHAT_MSG_WHISPER")
    self:RegisterEvent("CHAT_MSG_ACHIEVEMENT")
    self:RegisterEvent("CHAT_MSG_GUILD")
    self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
	self:RegisterEvent("CHAT_MSG_RAID")
    self:RegisterEvent("CHAT_MSG_PARTY")
	self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
end

function Gratz:OnDisable()
    -- Called when the addon is disabled
end
function Gratz:BGReset()
	hasSentVictoryMessageForBG = false
end
function Gratz:splitAtFirst(str, pattern)

	local startIndex, endIndex = strfind(str,pattern)
	if startIndex ~= nil then
		return strsub(str,0,  startIndex-1), strsub(str, startIndex+strlen(pattern))
	end
	return nil
end
-- ========================================================================== --
-- Events
function Gratz:CHAT_MSG_ACHIEVEMENT(event, message, sender)


	local senderName, senderRealm =  Gratz:splitAtFirst(sender, "-")

	achieveID, achGUID = Gratz:ParseAchievementLink(message)
	


	if senderName ~= UnitName("player")  then
		str = senderName;
		
		--senderName, senderRealm = strsplit("-", sender)
		if UnitInBattleground(senderName) ~= nil then
			-- {L["PARTY"],L["RAID"],L["BATTLEGROUND"],L["GUILD"], L["NEARBY"]}
			if Gratz.db.profile.ActiveGratz[3] == true then

				--UnitIsSameServer
				--sender = { strsplit("-", "Benier-Mok'nathal") }
				Gratz:ProcessAchieve(senderName, senderRealm, achieveID, "Battleground")
			--	Gratz:AddEntryToPending("Battleground", senderName, senderRealm, achieveID)
			--	Gratz:AddToNeoPending("Battleground", senderName, senderRealm, achieveID)
				
				--if bgTimer == nil then
				--	bgTimer = Gratz:ScheduleTimer("BGAchieveTimer",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
				--end
			end
			--bgTimer

		end
		if UnitInRaid(senderName) ~= nil and UnitInBattleground(senderName) == nil then
			if Gratz.db.profile.ActiveGratz[2] == true then
		
			--print("Starting to add to raid")
				Gratz:ProcessAchieve(senderName, senderRealm, achieveID, "Raid")
			--	Gratz:AddEntryToPending("Raid", senderName, senderRealm, achieveID)
				--Gratz:AddToNeoPending("Raid", senderName, senderRealm, achieveID)
				--if raidTimer == nil then
				--	raidTimer = Gratz:ScheduleTimer("SendRGratz",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
				--end
			end
			
		end
		if UnitInParty(senderName) ~= nil and UnitInRaid(senderName) == nil and UnitInBattleground(senderName) == nil then
			if Gratz.db.profile.ActiveGratz[1] == true then
			--Gratz:AddEntryToPending("Guild", achiever, GetRealmName(), achievID)
			--Gratz:ProcessAchieve(senderName, senderRealm, achieveID, "Guild")
				--Gratz:AddEntryToPending("Party", senderName, senderRealm, achieveID)
				--Gratz:AddToNeoPending("Party", senderName, senderRealm, achieveID)
				Gratz:ProcessAchieve(senderName, senderRealm, achieveID, "Party")
				--if partyTimer == nil then
				--	partyTimer = Gratz:ScheduleTimer("PartyAchieveTimer",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
				--end
			end
		end
		if UnitInParty(senderName) == nil and UnitInRaid(senderName) == nil and UnitInBattleground(senderName) == nil then
			if Gratz.db.profile.ActiveGratz[5] == true then
				--str = str.."nearby"
				Gratz:ProcessAchieve(senderName, senderRealm, achieveID, "Nearby")
				--Gratz:AddEntryToPending("Nearby", senderName, senderRealm, achieveID)
				--Gratz:AddToNeoPending("Nearby", senderName, senderRealm, achieveID)
				--if nearbyTimer == nil then
				--	nearbyTimer = Gratz:ScheduleTimer("NearbyHandler",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
				--end
			end
		end
		
	end
end
function Gratz:GetPlayerName()
	local name, realm = UnitName("player")
	return name.."-"..GetRealmName()

end
function Gratz:CHAT_MSG_WHISPER(event, message, achiever)


	if achiever ~= Gratz:GetPlayerName() then
		if string.find(string.lower(message),"%f[%a]ding%f[%A]") ~= nil then 
			Gratz:DingHandlerName (achiever, "WHISPER")
		end

	end
end
function Gratz:CHAT_MSG_GUILD(event, message, achiever)

	if achiever ~= Gratz:GetPlayerName() then
		if string.find(string.lower(message),"%f[%a]ding%f[%A]") ~= nil then 
			Gratz:DingHandlerName (achiever, "GUILD")
		end
	end

end
function Gratz:CHAT_MSG_PARTY(event, message, achiever)
	if achiever ~= Gratz:GetPlayerName() then
		if string.find(string.lower(message),"%f[%a]ding%f[%A]") ~= nil then 
			Gratz:DingHandlerName (achiever, "PARTY")
		end
	end
end
function Gratz:CHAT_MSG_RAID(event, message, achiever)

	if achiever ~= Gratz:GetPlayerName()then
		if string.find(string.lower(message),"%f[%a]ding%f[%A]") ~= nil then 
			Gratz:DingHandlerName (achiever, "RAID")
		end

	end
end
function Gratz:CHAT_MSG_GUILD_ACHIEVEMENT(event, message, achiever)
	local senderName, senderRealm =  Gratz:splitAtFirst(achiever, "-")

	achieveID, achGUID = Gratz:ParseAchievementLink(message)
	if UnitName("player") ~= senderName then
	
		Gratz:ProcessAchieve(senderName, senderRealm, achieveID, "Guild")
	end
	
	--if UnitName("player") ~= achiever and (Gratz.db.profile.AFKon or  UnitIsAFK("player") == nil) and Gratz:IsPersonOnIgnore(achiever, GetRealmName()) == false then
	--	if Gratz.db.profile.ActiveGratz[4] == true then
	--		tim = random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay);
	--		achievID, achievGUID = Gratz:ParseAchievementLink(message)
	--		Gratz:AddToNeoPending("Guild", achiever, GetRealmName(), achievID)
	--		Gratz:PrintoutNeoPending()
	--		if guildTimer == nil then
	--			guildTimer = Gratz:ScheduleTimer("SendGuildGratz", random(1,Gratz.db.profile.Delay), {})
	--		end
	--	end

	--end
end

--Wait List

function Gratz:IsInWaitList(name, realm, id)

	for k,v in pairs(Gratz.db.profile.WaitList) do
		if v.Name == name and v.Realm == realm and v.ID == id then
			return true, k
		end
	end
	return false
end
function Gratz:AddToWaitList(achieverName, achieverRealm, achievementID, channel)
	if Gratz.db.profile.WaitListSettings.Enabled == false then
		return false
	end
--Get Date and Time.
	local TD = strsplit((os.date("%Y-%B-%d-%H-%M-%p")),"-")
	local channs = {Party = false, Raid = false, Battleground = false, Guild = false, Nearby = false}
	channs[channel] = true
	
	local isIn, ke = Gratz:IsInWaitList(achieverName, achieverRealm, achievementID)
	if isIn == false then
		table.insert(Gratz.db.profile.WaitList, {Selected = false, 
		Name = achieverName, 
		Realm = achieverRealm, 
		ID = achievementID, 
		AMPM = TD[6],
		Hour = TD[4],
		Minute = TD[5], 
		Day = TD[3], 
		Month = TD[2], 
		Year = TD[1], 
		Channels =channs})
	else
		Gratz.db.profile.WaitList[ke].Channels[channel] = true
	end
end
function Gratz:RemoveFromWaitlist(index)
	table.remove(Gratz.db.profile.WaitList, index)
end
function Gratz:RemoveFromWaitlistByInfo(name, realm, id)
	for k,v in pairs (Gratz.db.profile.WaitList) do
		if v.Name == name and v.Realm == realm and v.ID == id then
			Gratz.db.profile.WaitList[k] = nil
			return true
		end
	end
	return false
end

function Gratz:ProcessAchieve(name, realm, id, channel)
	if realm == nil then
		realm = ""
	end
	if name == nil then
		name = ""

	end
	--print("Name: "..name.." Realm: "..realm)
	local isSpecific = false
	local isSpecialPlayer = false

	if UnitName("player") == name then
		return false
	end
	--Check to see if the channel is one that is to be watched.

	if channel == "Guild" then
		if Gratz.db.profile.ActiveGratz[4] == false then
			print("FAL")
			return false
		end
	end
	if channel == "Test" then
		
	end
	if channel == "Raid" then
		if Gratz.db.profile.ActiveGratz[2] == false then
			return false
		end
	end
	if channel == "Party" then
		if Gratz.db.profile.ActiveGratz[1] == false then
			return false
		end
	end
	if channel == "Battleground" then
		if Gratz.db.profile.ActiveGratz[3] == false then
			return false
		end
	end
	if channel == "Nearby" then
		if Gratz.db.profile.ActiveGratz[5] == false then
			return false
		end
	end
	--Check to see if the person is on the ignore list.
	if Gratz.db.profile.Specials[name.."-"..realm] ~= nil then
		if Gratz.db.profile.Specials[name.."-"..realm].Enabled == true then

			if Gratz.db.profile.Specials[name.."-"..realm].Ignore == true then
				return false
			end
			--Mark achieve to also go into the specials stack.
			isSpecialPlayer = true
		end
	end

	if Gratz.db.profile.SpecificAchievementGratz[id] ~= nil then
		if Gratz.db.profile.SpecificAchievementGratz[id].Enabled == true then
			if Gratz.db.profile.SpecificAchievementGratz[id].Ignore == true then

				return false
			end
			--Mark to add to specific stack
			isSpecific = true
		end
	end

	--Add to normal if not marked for specific or special
	if channel == "Test" then
		if isSpecific == false and isSpecialPlayer == false then
			Gratz:AddToTestQueueNormal(name, realm, id)
		end
		if isSpecific  then
			Gratz:AddToTestQueueSpecific(name, realm, id)
		end
		if isSpecialPlayer  then
			Gratz:AddToTestQueueSpecial(name, realm, id)
		end
		if TestQueueTimer == nil then
			TestQueueTimer =Gratz:ScheduleTimer("TestQueueTimerFunc", 5)
		end
	end

	if channel == "Raid" then
		if isSpecific == false and isSpecialPlayer == false then
			Gratz:AddToRaidQueueNormal(name, realm, id)
		end
		if isSpecific  then
			Gratz:AddToRaidQueueSpecific(name, realm, id)
		end
		if isSpecialPlayer  then
			Gratz:AddToRaidQueueSpecial(name, realm, id)
		end
		if RaidQueueTimer == nil then
			RaidQueueTimer = Gratz:ScheduleTimer("RaidQueueTimerFunc", random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay))
		end
	end
	if channel == "Battleground" then
		if isSpecific == false and isSpecialPlayer == false then
			Gratz:AddToBGQueueNormal(name, realm, id)
		end
		if isSpecific  then
			Gratz:AddToBGQueueSpecific(name, realm, id)
		end
		if isSpecialPlayer  then
			Gratz:AddToBGQueueSpecial(name, realm, id)
		end
		if BGQueueTimer == nil then
			BGQueueTimer =Gratz:ScheduleTimer("BGQueueTimerFunc", random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay))
		end
	end

	if channel == "Party" then
		if isSpecific == false and isSpecialPlayer == false then
			Gratz:AddToPartyQueueNormal(name, realm, id)
		end
		if isSpecific  then
			Gratz:AddToPartyQueueSpecific(name, realm, id)
		end
		if isSpecialPlayer  then
			Gratz:AddToPartyQueueSpecial(name, realm, id)
		end
		if PartyQueueTimer == nil then
			PartyQueueTimer =Gratz:ScheduleTimer("PartyQueueTimerFunc", random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay))
		end
	end
	if channel == "Guild" then
		if isSpecific == false and isSpecialPlayer == false then
			Gratz:AddToGuildQueueNormal(name, realm, id)
		end
		if isSpecific  then
			Gratz:AddToGuildQueueSpecific(name, realm, id)
		end
		if isSpecialPlayer  then
			Gratz:AddToGuildQueueSpecial(name, realm, id)
		end
		if GuildQueueTimer == nil then
			--Gratz:AddToGuildQueueNormal(name, realm, id)
			GuildQueueTimer =Gratz:ScheduleTimer("GuildQueueTimerFunc", random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay))
		end
	end
	if channel == "Nearby" then
		if isSpecific == false and isSpecialPlayer == false then
			Gratz:AddToNearbyQueueNormal(name, realm, id)
		end
		if isSpecific  then
			Gratz:AddToNearbyyQueueSpecific(name, realm, id)
		end
		if isSpecialPlayer  then
			Gratz:AddToNearbyQueueSpecial(name, realm, id)
		end
		if NearbyQueueTimer == nil then
			NearbyQueueTimer =Gratz:ScheduleTimer("NearbyQueueTimerFunc", random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay))
		end
	end
	--TODO:  Add to the correct channel
	--TODO:  Add to waitlist

	if Gratz.db.profile.WaitListSettings.Enabled == true then
	
	end
end
--Works for regular battlegrounds.
function Gratz:UPDATE_BATTLEFIELD_SCORE(...)
	--local REGreenTeamName, REGreenTeamRating, REGreenNewTeamRating, REGreenMMR = GetBattlefieldTeamInfo(0);
	--local REGoldTeamName, REGoldTeamRating, REGoldNewTeamRating, REGoldMMR = GetBattlefieldTeamInfo(1);
	if GetBattlefieldWinner() ~= nil then
		if IsActiveBattlefieldArena() == nil then
			englishFaction, localizedFaction = UnitFactionGroup("player")
			-- The Horde side wins the Battleground.
			if GetBattlefieldWinner() == 0 and englishFaction == "Horde" then
				if hasSentVictoryMessageForBG == false then
					name, instanceType, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, mapID = GetInstanceInfo()
					if Gratz.db.profile.BGGratzOn == true then

						mess  = string.gsub(Gratz.db.profile.BGGratz[random(1,#(Gratz.db.profile.BGGratz))].Message, "#b", name)
						mess  = string.gsub(mess, "#f", localizedFaction)
						mess =  string.gsub(mess, "#e", L["Alliance"])
						if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
							SendChatMessage(mess, "INSTANCE_CHAT")
						else
							SendChatMessage(mess, "BATTLEGROUND")
						end
						
						hasSentVictoryMessageForBG = true
					end
				end
			end
			-- The Alliance side wins the Battleground.
			if GetBattlefieldWinner() == 1 and englishFaction == "Alliance" then
				if hasSentVictoryMessageForBG == false then
					name, instanceType, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, mapID = GetInstanceInfo()
					hasSentVictoryMessageForBG = true
					if Gratz.db.profile.BGGratzOn == true then
						mess = string.gsub(Gratz.db.profile.BGGratz[random(1,#(Gratz.db.profile.BGGratz))].Message, "#b", name)
						mess  = string.gsub(mess, "#f", localizedFaction)
						mess =  string.gsub(mess, "#e", L["Horde"])
						if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
							SendChatMessage(mess, "INSTANCE_CHAT")
						else
							SendChatMessage(mess, "BATTLEGROUND")
						end
						hasSentVictoryMessageForBG = true
					end
				end
			end
		end
	end
end
-- ========================================================================== --
function Gratz:NearbyHandler(input)
	if Gratz.db.profile.ActiveGratz[5] ~= true then
	return false
end
	nearbyTimer = nil;
	
	nearbyCount = 0;
	lastNearby = nil
	for pkey, pval in pairs (neoPending.Nearby.Earners) do
		nearbyCount = nearbyCount + 1;
		lastNearby = pkey;
	end

	if nearbyCount == 1 then
		message = nil
		--Gratz.db.profile.UseOtherGratzForGuild
		indexmess = 0;

		if Gratz.db.profile.IndividualGratz ~= nil then
			if #Gratz.db.profile.IndividualGratz ~= 0 then
				indexmess = random(1, #Gratz.db.profile.IndividualGratz)
				message = Gratz.db.profile.IndividualGratz[indexmess].Message
				name = strsplit("_",lastNearby)
				message  = string.gsub(message, "#n", name)

				SendChatMessage(message,"SAY")
			end
		else
			print("Gratz: Error.  No individual gratz messages.")
		end
	else
		message = nil
		--Gratz.db.profile.UseOtherGratzForGuild
		indexmess = 0;

		if Gratz.db.profile.GroupGratz ~= nil then
			if #Gratz.db.profile.GroupGratz ~= 0 then
				indexmess = random(1, #Gratz.db.profile.GroupGratz)
				message = Gratz.db.profile.GroupGratz[indexmess].Message
				--name = strsplit("_",lastNearby)
			--	message  = string.gsub(message, "#n", name)

				SendChatMessage(message,"SAY")
				end
		else
			print("Gratz: Error.  No group gratz messages.")
		end
	end

	--neoPending.Nearby.Earners
	neoPending.Nearby.Achieves = {}
	neoPending.Nearby.Earners = {}
end
function Gratz:SendGuildGratz (input)


if Gratz.db.profile.ActiveGratz[4] ~= true then
	return false
end

	guildTimer = nil;
	alist = {}
	for akey, aval in pairs (neoPending.Guild.Achieves) do
		--SpecificAchievementGratz
		if Gratz.db.profile.SpecificAchievementGratz[akey] ~= nil then
			tinsert(alist,akey)
		end
	end

	guildieCount = 0;
	lastguildiename = nil;
	for pkey, pval in pairs (neoPending.Guild.Earners) do
		guildieCount = guildieCount + 1;
		lastguildiename = pkey;
	end
	if guildieCount == 1 then

		if (Gratz.db.profile.UseOtherGratzForGuild == false and Gratz.db.profile.GuildGratzSingle == nil) or 
			(Gratz.db.profile.UseOtherGratzForGuild == true and Gratz.db.profile.IndividualGratz == nil and Gratz.db.profile.GuildGratzSingle == nil) then
			return nil
		end

		message = nil
		--Gratz.db.profile.UseOtherGratzForGuild
		indexmess = 0;

		if Gratz.db.profile.UseOtherGratzForGuild and Gratz.db.profile.IndividualGratz ~= nil then
			if #Gratz.db.profile.GuildGratzSingle+#Gratz.db.profile.IndividualGratz ~= 0 then
				indexmess = random(1,#Gratz.db.profile.GuildGratzSingle+#Gratz.db.profile.IndividualGratz)
			end
		else
			if Gratz.db.profile.GuildGratzSingle ~= nil then
				if #Gratz.db.profile.GuildGratzSingle ~= 0 then
					indexmess = random(1,#Gratz.db.profile.GuildGratzSingle)
				end
			else
				print("Gratz: Error.  No single guild gratz messages or individual messages.")
			end
		end
	
		if indexmess > #Gratz.db.profile.GuildGratzSingle then
			if  Gratz.db.profile.IndividualGratz[indexmess-#Gratz.db.profile.GuildGratzSingle].Message ~= nil then
				message = Gratz.db.profile.IndividualGratz[indexmess-#Gratz.db.profile.GuildGratzSingle].Message
			else
				print("CAUGHT ERROR 2")
			end
		else
			if Gratz.db.profile.GuildGratzSingle[indexmess] ~= nil then
				if Gratz.db.profile.GuildGratzSingle[indexmess].Message ~= nil then
					message = Gratz.db.profile.GuildGratzSingle[indexmess].Message
				else
					print("ERR CAUGHT")
				end
			end
		end
		if message ~= nil then
		name = strsplit("_",lastguildiename)
		message  = string.gsub(message, "#n", name)
		guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
		message  = string.gsub(message, "#g", guildName)
		SendChatMessage(message,"GUILD")
		end
	else
		if (Gratz.db.profile.UseOtherGratzForGuild == false and Gratz.db.profile.GuildGratzGroup == nil) or 
			(Gratz.db.profile.UseOtherGratzForGuild == true and Gratz.db.profile.GroupGratz == nil and Gratz.db.profile.GuildGratzGroup == nil) then
			return nil
		end
		indexmess = 0;

		if Gratz.db.profile.UseOtherGratzForGuild and Gratz.db.profile.GroupGratz ~= nil then
			if #Gratz.db.profile.GuildGratzGroup ~= 0 and #Gratz.db.profile.GroupGratz ~= 0 then
				indexmess = random(1,#Gratz.db.profile.GuildGratzGroup+#Gratz.db.profile.GroupGratz)
			end
		else
			if Gratz.db.profile.GuildGratzGroup ~= nil then
				if #Gratz.db.profile.GuildGratzGroup+#Gratz.db.profile.GroupGratz ~= 0 then
					indexmess = random(1,#Gratz.db.profile.GuildGratzGroup)
				end
			else
				print("Gratz: Error.  No group guild gratz messages or group messages.")
			end
		end


		if indexmess > #Gratz.db.profile.GuildGratzGroup then
			message = Gratz.db.profile.GroupGratz[indexmess-#Gratz.db.profile.GuildGratzGroup].Message --ERROR
		else
			if Gratz.db.profile.GuildGratzGroup[indexmess] ~= nil then
				message = Gratz.db.profile.GuildGratzGroup[indexmess].Message
			end
		end
		
		if message ~= nil and type(message) == "string" then
		guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
		message  = string.gsub(message, "#g", guildName)
		SendChatMessage(message,"GUILD")
		end
	end
	

	neoPending.Guild.Achieves = {}
	neoPending.Guild.Earners = {}
end

function Gratz:SendRGratz (input)
if Gratz.db.profile.ActiveGratz[2] ~= true then
	return false
end
	RaidTimer = nil;

	for akey, aval in pairs (neoPending.Raid.Achieves) do
		
		
	end
	guildieCount = 0;
	lastguildiename = nil;
	for pkey, pval in pairs (neoPending.Raid.Earners) do
		guildieCount = guildieCount + 1;
		lastguildiename = pkey;
	end
	--print("Number of raid gratz = "..#neoPending.Raid.Earners)
	if #neoPending.Raid.Earners == 1 then

		message = nil
		--Gratz.db.profile.UseOtherGratzForGuild
		indexmess = 0;
		if #Gratz.db.profile.IndividualGratz == 0 then
			print("Gratz:  Error.  There are no messages in individual section.  No gratz sent")
		else
			indexmess = random(1,#Gratz.db.profile.IndividualGratz)
			message = Gratz.db.profile.IndividualGratz[indexmess].Message	
			name = strsplit("_",lastguildiename)
			message  = string.gsub(message, "#n", name)
			--guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
			--message  = string.gsub(message, "#g", guildName)
			SendChatMessage(message,"RAID")
		end
	else
		indexmess = 0;
		if #Gratz.db.profile.GroupGratz == 0 then
			print("Gratz:  Error.  There are no messages in group section.  No gratz sent")
		else
			indexmess = random(1,#Gratz.db.profile.GroupGratz)
			message = Gratz.db.profile.GroupGratz[indexmess].Message
			--guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
			--message  = string.gsub(message, "#g", guildName)
			SendChatMessage(message,"RAID")
		end
	end
	

	neoPending.Raid.Achieves = {}
	neoPending.Raid.Earners = {}
end
-- -------skip-----------+ ID + playerguid +comp +MM+DD+Y
--                      achievementID:playerGUID:completed:month:day:year:bits1:bits2:bits3:bits4
--|cffffff00|Hachievement:2336:060000000279E425:1:10:14:8:4294967295:4294967295:4294967295:4294967295|h[Insane in the Membrane]|h|r
--find Hachievement instead and make substring
--Parse by :
--|cffffff00|Hachievement    2336   060000000279E425  1  10  14  8  4294967295  4294967295  4294967295  4294967295|h[Insane in the Membrane]|h|r
--Find 0| and skip it to make a sub string Hachievement:2336:060000000279E425:1:10:14:8:4294967295:4294967295:4294967295:4294967295|h[Insane in the Membrane]|h|r.
--Find |h and remove it and all after to get Hachievement:2336:060000000279E425:1:10:14:8:4294967295:4294967295:4294967295:4294967295
--Split by :
function Gratz:ParseAchievementLink(msg)

	s, e =string.find((msg),"Hachievement:")
	ss, ee = string.find(string.sub(msg,e+1),":")
	achieveID = tonumber(string.sub(string.sub(msg,e+1),1,ee-1))
	--string.sub()
	rest = (string.sub(string.sub(msg,e+1),ee+1))
	ss1, ee1 = string.find(string.sub(string.sub(msg,e+1),ee+1),":")

	achieverGUID = tonumber(string.sub(rest,1,ss1-1),16);

	return achieveID, achieverGUID
end



-- ============================================================================================================== --
-- Ding Handling.
-- ============================================================================================================== --
---This function removes a player from the table of recent dingers.
--@param key:  The key that player is indexed in the table:  Player name - Realm Name
function Gratz:RemoveDingHold(key)
	self.CancelTimer(dingWait[name.."-"..realm],true)
	dingWait[name.."-"..realm] = nil
end
function Gratz:DingHandlerName (dinger, channel)
	if dingWait[dinger] == nil then
		if Gratz.db.profile.DingOn == true  and Gratz:TableSize(Gratz.db.profile.DingGratz) ~= 0 then  --{"Raid", "Party", "Battleground", "Guild"},
			mess = ""  --GetRealmName()
			mess = string.gsub(Gratz.db.profile.DingGratz[random(1,#(Gratz.db.profile.DingGratz))].Message, "#n", dinger)
			--mess = string.gsub(mess,"#c",className)
			--mess = string.gsub(mess,"#r",raceName)
			if channel == "RAID" and Gratz.db.profile.DingChannels[1] == true then
				if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
					SendChatMessage(mess, "INSTANCE_CHAT")
				else
					SendChatMessage(mess, "RAID")
				end
				dingWait[dinger] = self.ScheduleTimer("RemoveDingHold", 60, dinger)
			end
			if channel == "PARTY" and Gratz.db.profile.DingChannels[2] == true then
				if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
					SendChatMessage(mess, "INSTANCE_CHAT")
				else
					SendChatMessage(mess, "PARTY")
				end
				dingWait[dinger] = self.ScheduleTimer("RemoveDingHold", 60, dinger)
			end
			if channel == "BATTLEGROUND" and Gratz.db.profile.DingChannels[3] == true then
				if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
					SendChatMessage(mess, "INSTANCE_CHAT")
				else
					SendChatMessage(mess, "BATTLEGROUND")
				end
				dingWait[dinger] = self.ScheduleTimer("RemoveDingHold", 60, dinger)
			end
			if channel == "GUILD" and Gratz.db.profile.DingChannels[4] == true then
				SendChatMessage(mess, "GUILD")
				dingWait[dinger] = self.ScheduleTimer("RemoveDingHold", 60, dinger)
			end
		end
	end
end
function Gratz:DingHandlerGuild (dingerGUID, channel)  --name = "Special Characters/n#n: Name of the leveler./n#c: Class of the leveler./n#r: Race of the leveler.",
	className, classId, raceName, raceId, gender, name, realm = GetPlayerInfoByGUID(dingerGUID)
	if dingWait[name.."-"..realm] == nil then
		if Gratz.db.profile.DingOn == true then  --{"Raid", "Party", "Battleground", "Guild"},
			mess = ""  --GetRealmName()
			mess = string.gsub(Gratz.db.profile.DingGratz[random(1,#(Gratz.db.profile.DingGratz))], "#n", name)
			mess = string.gsub(mess,"#c",className)
			mess = string.gsub(mess,"#r",raceName)
			if channel == "RAID" and Gratz.db.profile.DingChannels[1] == true then
				if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
					SendChatMessage(mess, "INSTANCE_CHAT")
				else
					SendChatMessage(mess, "RAID")
				end
				dingWait[name.."-"..realm] = self.ScheduleTimer("RemoveDingHold", 60, name.."-"..realm)
			end
			if channel == "PARTY" and Gratz.db.profile.DingChannels[2] == true then
				if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
					SendChatMessage(mess, "INSTANCE_CHAT")
				else
					SendChatMessage(mess, "PARTY")
				end
				dingWait[name.."-"..realm] = self.ScheduleTimer("RemoveDingHold", 60, name.."-"..realm)
			end
			if channel == "BATTLEGROUND" and Gratz.db.profile.DingChannels[3] == true then
				if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
					SendChatMessage(mess, "INSTANCE_CHAT")
				else
					SendChatMessage(mess, "BATTLEGROUND")
				end
				dingWait[name.."-"..realm] = self.ScheduleTimer("RemoveDingHold", 60, name.."-"..realm)
			end
			if channel == "GUILD" and Gratz.db.profile.DingChannels[4] == true then
				SendChatMessage(mess, "GUILD")
				dingWait[name.."-"..realm] = self.ScheduleTimer("RemoveDingHold", 60, name.."-"..realm)
			end
			if channel == "WHISPER" and Gratz.db.profile.DingChannels[5] == true then
				SendChatMessage(mess, "WHISPER")
				dingWait[name.."-"..realm] = self.ScheduleTimer("RemoveDingHold", 60, name.."-"..realm)
			end
		end
	end
	
end
function Gratz:TableSize(tab)
	count = 0
	for key, val in pairs (tab) do
		count = count +1
	end
	return count
end