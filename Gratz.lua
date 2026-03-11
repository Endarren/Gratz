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
Gratz = LibStub("AceAddon-3.0"):NewAddon("Gratz", "AceConsole-3.0", "AceEvent-3.0" ,"AceTimer-3.0","AceHook-3.0");
local L						= LibStub("AceLocale-3.0"):GetLocale("Gratz")
local guildGratzTimer = nil;
local pendingGuildAchieves = {};


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
function Gratz:SpecialWhisperGratzSingle(achiever, achievement)
	--TODO Check to see if the person has a list of messages.
		if Gratz.db.profile.Specials[achiever].Specific == true then
			selectedMessage =  Gratz.db.profile.Specials[achiever].SpecificList[random(1,#Gratz.db.profile.Specials[achiever].SpecificList)];
			--SpecificList
			--random(1,#Gratz.db.profile.Specials[achiever].SpecificList)
		end
	--TODO If not, check for specific achievement gratz.

end

function Gratz:AddEntryToPending(channel, name, realm, achieve)
	--TODO fix realm nil
	
	if realm == nil then
		realm =  GetRealmName();
	end
	--print("Entry "..channel.." "..name.." "..realm.." "..achieve)
	if channel == "Guild" then
					--Add achievement.
					if pendingGratzTable.Guild.Achieves[achieve] == nil then
						pendingGratzTable.Guild.Achieves[achieve] = 1
					else
						pendingGratzTable.Guild.Achieves[achieve] = pendingGratzTable.Guild.Achieves[achieve] +1
					end
					--Add the achiever.
					pendingGratzTable.Guild.Earners[name.."_"..realm] = true;
		
	end
	if channel == "Raid" then
		--Add achievement.
		if pendingGratzTable.Raid.Achieves[achieve] == nil then
			pendingGratzTable.Raid.Achieves[achieve] = 1
		else
			pendingGratzTable.Raid.Achieves[achieve] = pendingGratzTable.Raid.Achieves[achieve] +1
		end
		--Add the achiever.
		pendingGratzTable.Raid.Earners[name.."_"..realm] = true;
--print("Adding "..name.." to Earners.  Size "..#pendingGratzTable.Raid.Earners)

	else
		if channel == "Party" then
			--Add achievement.
			if pendingGratzTable.Party.Achieves[achieve] == nil then
				pendingGratzTable.Party.Achieves[achieve] = 1
			else
				pendingGratzTable.Party.Achieves[achieve] = pendingGratzTable.Party.Achieves[achieve] +1
			end
			--Add the achiever.
			pendingGratzTable.Party.Earners[name.."_"..realm] = true;
			--print("Adding "..name)
		
		else
			if channel == "Battleground" then
				--Add achievement.
				if pendingGratzTable.Battleground.Achieves[achieve] == nil then
					pendingGratzTable.Battleground.Achieves[achieve] = 1
				else
					pendingGratzTable.Battleground.Achieves[achieve] = pendingGratzTable.Battleground.Achieves[achieve] +1
				end
				--Add the achiever.
				pendingGratzTable.Battleground.Earners[name.."_"..realm] = true;
			else
				
					if channel == "Nearby" then
						if pendingGratzTable.Nearby.Achieves[achieve] == nil then
							pendingGratzTable.Nearby.Achieves[achieve] = 1
						else
							pendingGratzTable.Nearby.Achieves[achieve] = pendingGratzTable.Nearby.Achieves[achieve] +1
						end
						
						pendingGratzTable.Nearby.Earners[name.."_"..realm] = true;
					else
					
					end
				
			end
		end
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
local defaults ={	profile = {
						ActiveGratz			= { true , true,  true, true, true},
						SingleSettingGroup	= false,
						SingleSetting		= {	PARTY = true,
												RAID = true, 
												BATTLEGROUND = true, 
												GUILD = true, 
												NEARBY = true
											},
						IndividualGratz		= {},
						GroupGratz			= {},
						GuildGratzSingle	= {},
						GuildGratzGroup		= {},
						UseOtherGratzForGuild = true,
						DingGratz			= {},
						DingOn				= true,
						DingChannels		= {true,true,true,true},
						BGGratz				=	{	
												},
						BGGratzOn = true,
						SpecificAchievementGratz = {}, --Ignored, SingleMessages, GroupMessages
						AFKon = true,
						Delay = 5,
						MinDelay = 1,
						Specials = {}  -- Ignore, Whisper, Specific, SpecificList = {}

}}

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
-- ========================================================================================== --
--	Specific Achievement Gratz Interface
-- ========================================================================================== --
local tempAchieveID = 1070;
local specificConfig = {
		type = "group",
		name = "Specific Achievements",
		args = {
					AchieveName = {type = "description",
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
						set = function (info, val) 
								Gratz:UpdateAchieveDesc (val)
								end,
						order = 1
			
						}
		}
}
function Gratz:AddSpecificAchieveUI (key)
	IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText = GetAchievementInfo(key)
specificConfig.args[key] = {type = "group",
						   order = 5,
							name = Name,
							args = {
								AchieveName = {type = "description", name = Name, order = 1,icon = Image },
								AchieveDesc = {type = "description", name = Description, order = 2},
								DeleteAchieve = {type = "execute", name = "Delete", func = function () end,order =3},
								SingleGroup = {type = "group", name = "Single",args ={
									AddSingleMessage = {type = "execute",name = "Add Single",func = function()  Gratz:AddNewSingleSpecific(key) end}
																					}
								},
								GroupGroup = {type = "group",name = "Group",
									args ={AddSingleMessage = {
									type = "execute",
									name = "Add Group",
									func = function() end
								}}
								}
							}

}
end
function Gratz:AddNewSingleSpecific(key)

	Gratz:AddToSingleSpecificUI(key)
end
function Gratz:AddToSingleSpecificUI(key)
	specificConfig.args[key].args.SingleGroup[key] = {
			type = "group",
			name = "BLANK",
			args = {
				Delete = { type = "execute", name = "Delete", func = function() end,order = 2},
				message = {type = "input", name = "Message",set = function(info, val) end, get = function () return "EMPTY" end,order =1}
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
--	Specials
-- ========================================================================================== --
	
local tempspecialname = ""

local specialConfig = {
						type = "group",
						name = "Special",
						args = {
						NeoNameBox = {
										type = "input",
										name = "Name",
										order = 1,
										set = function (info, val) tempspecialname = val end,
										get = function () return tempspecialname  end

},
						
						
						
						}



						}

			
-- ======================================================================================================================							
local GratzMain = {
						type = "group",
						name = "Gratz",
						args = {
									AFK =	{
												type = "toggle",
												name = L["AFK"] ,
												get =	function () 
															return Gratz.db.profile.AFKon 
														end,
												set =	function (info, val) 
															Gratz.db.profile.AFKon = val
														end,
												desc = L["AFK_DESC"]
											},
									Groups = {
												type = "multiselect",
												name = L["CHANNEL"] ,
												desc = L["CHANNEL_DESC"] ,
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
												max = 15,
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
												max = 15,
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
							TestGuildSingle = {type ="execute", name = "Test Guild Single", func = function() 
							
							Gratz:AddToNeoPending("Guild", "THIS IS A TEST", "TEST", 1)
							Gratz:PrintoutNeoPending()
							if guildTimer == nil then
								guildTimer = Gratz:ScheduleTimer("SendGuildGratz", random(1,Gratz.db.profile.Delay), {})
							end
							
							
							
							end},
							TestGuildGroup = {type ="execute", name = "Test Guild Group", func = function() 
							
							Gratz:AddToNeoPending("Guild", "THIS IS A TEST", "TEST", 1)
							Gratz:AddToNeoPending("Guild", "THIS IS A TEST2", "TEST2", 1)
							Gratz:PrintoutNeoPending()
							if guildTimer == nil then
								guildTimer = Gratz:ScheduleTimer("SendGuildGratz", random(1,Gratz.db.profile.Delay), {})
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
						values = {L["RAID"], L["PARTY"], L["BATTLEGROUND"], L["GUILD"]},
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
																	width = "full"
													},
											IndividualDesc = {
																type = "description",
																order = 2,
																name = L["INDIVIDUAL_MESSAGE_DESC"] .."\n"..L["INDIVIDUAL_MESSAGE_DESC1"]

															},
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
							end

	}
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
--	Group Gratz
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
-- =======================================================================================================
function Gratz:OnInitialize()
    -- Called when the addon is loaded
	--Gratz:SetUpSpecificAchieveGratz()
	self.db = LibStub("AceDB-3.0"):New("GRATZ", defaults)
	Gratz:FillIndividualGratzOptions();
	Gratz:FillGroupGratzOptions()
	Gratz:FillBGVict ()
	--Gratz:FillUpSpecials();
	Gratz:FillUpDing()
	Gratz:FillUpGuildGratz()
	local config = LibStub("AceConfig-3.0")
	local registry = LibStub("AceConfigRegistry-3.0")
	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	registry:RegisterOptionsTable("Gratz Main", GratzMain)
	registry:RegisterOptionsTable("Individual Gratz", IndividualGratzOptions)
	registry:RegisterOptionsTable("Group Gratz", GroupGratzOptions)
	registry:RegisterOptionsTable("Battleground Victory", BGVictoryOptions)
	--registry:RegisterOptionsTable("Special Gratz",SpecialsOptions)
	registry:RegisterOptionsTable("Ding Gratz",DingGratzOptions)
	registry:RegisterOptionsTable("Guild Gratz",GuildGratzMenu)
	registry:RegisterOptionsTable("Specific Achievements",specificConfig)
	registry:RegisterOptionsTable("Profiles", profiles)


	local dialog = LibStub("AceConfigDialog-3.0")

	self.optionFrames = {
							main		= dialog:AddToBlizOptions("Gratz Main", "Gratz"),
							Ind			= dialog:AddToBlizOptions("Individual Gratz","Individual Gratz", "Gratz"),
							gro			= dialog:AddToBlizOptions("Group Gratz","Group Gratz", "Gratz"),
							ding		= dialog:AddToBlizOptions("Ding Gratz","Ding Gratz", "Gratz"),
							guild		=dialog:AddToBlizOptions("Guild Gratz","Guild Gratz", "Gratz"),
							bg			= dialog:AddToBlizOptions("Battleground Victory","Battleground Victory", "Gratz"),
							--Spe			= dialog:AddToBlizOptions("Special Gratz","Special Gratz", "Gratz"),
							Specific			= dialog:AddToBlizOptions("Specific Achievements","Specific Achievements", "Gratz"),
		profiles = dialog:AddToBlizOptions("Profiles", "Profiles", "Gratz")
						}

 
    -- Print a message to the chat frame
    self:RegisterEvent("CHAT_MSG_WHISPER")
    self:RegisterEvent("CHAT_MSG_ACHIEVEMENT")
    self:RegisterEvent("CHAT_MSG_GUILD")
    self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
    self:RegisterEvent("CHAT_MSG_RAID")
	self:RegisterEvent("CHAT_MSG_PARTY")
	self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	self.db.RegisterCallback(self, "OnProfileChanged", "SetupOptions")
	self.db.RegisterCallback(self, "OnNewProfile", "SetupOptions")
	self.db.RegisterCallback(self, "OnProfileCopied", "SetupOptions")
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

-- ========================================================================== --
-- Events
function Gratz:CHAT_MSG_ACHIEVEMENT(event, message, sender)

	if sender ~= UnitName("player")  then
		str = sender;
		achieveID, achGUID = Gratz:ParseAchievementLink(message)
		senderName, senderRealm = strsplit("-", sender)
		if UnitInBattleground(sender) ~= nil then
			str = str.."BG"
			--UnitIsSameServer
			--sender = { strsplit("-", "Benier-Mok'nathal") }
			Gratz:AddEntryToPending("Battleground", senderName, senderRealm, achieveID)
			Gratz:AddToNeoPending("Battleground", senderName, senderRealm, achieveID)
			if bgTimer == nil then
				bgTimer = Gratz:ScheduleTimer("BGAchieveTimer",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
			end

			--bgTimer

		end
		if UnitInRaid(sender) ~= nil and UnitInBattleground(sender) == nil then
			str = str.."raid"
			--print("Starting to add to raid")
			Gratz:AddEntryToPending("Raid", senderName, senderRealm, achieveID)
			Gratz:AddToNeoPending("Raid", senderName, senderRealm, achieveID)
			if raidTimer == nil then
				raidTimer = Gratz:ScheduleTimer("SendRGratz",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
			end

			
		end
		if UnitInParty(sender) ~= nil and UnitInRaid(sender) == nil and UnitInBattleground(sender) == nil then
			str = str.."Party"
			--Gratz:AddEntryToPending("Guild", achiever, GetRealmName(), achievID)
			Gratz:AddEntryToPending("Party", senderName, senderRealm, achieveID)
			Gratz:AddToNeoPending("Party", senderName, senderRealm, achieveID)
			if partyTimer == nil then
				partyTimer = Gratz:ScheduleTimer("PartyAchieveTimer",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
			end

		end
		if UnitInParty(sender) == nil and UnitInRaid(sender) == nil and UnitInBattleground(sender) == nil then
			str = str.."nearby"
			Gratz:AddEntryToPending("Nearby", senderName, senderRealm, achieveID)
			Gratz:AddToNeoPending("Nearby", senderName, senderRealm, achieveID)
			if nearbyTimer == nil then
				nearbyTimer = Gratz:ScheduleTimer("NearbyHandler",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
			end
		end
		
	end
end

function Gratz:CHAT_MSG_WHISPER(...)
	--TODO parameters and dinghandler
	if achiever ~= UnitName("player") then
	--TODO parameters and dinghandler
		--Gratz:DingHandlerName (achiever, "WHISPER")
	end
end
function Gratz:CHAT_MSG_GUILD(event, message, achiever)
	if achiever ~= UnitName("player") then
	--TODO parameters and dinghandler
	--	Gratz:DingHandlerName (achiever, "GUILD")
	end

end
function Gratz:CHAT_MSG_PARTY(event, message, achiever)
	if achiever ~= UnitName("player") then
	--TODO parameters and dinghandler   Gratz:DingHandlerName (dinger, channel)
	--	Gratz:DingHandlerName (achiever, "PARTY")
	end
end
function Gratz:CHAT_MSG_RAID(event, message, achiever)
	--TODO parameters and dinghandler
	if achiever ~= UnitName("player") then
	--TODO parameters and dinghandler   Gratz:DingHandlerName (dinger, channel)
	--	Gratz:DingHandlerName (achiever, "RAID")
	end
end
function Gratz:CHAT_MSG_GUILD_ACHIEVEMENT(event, message, achiever)
	if UnitName("player") ~= achiever and (Gratz.db.profile.AFKon or  UnitIsAFK("player") == nil) and Gratz:IsPersonOnIgnore(achiever, GetRealmName()) == false then
		
		tim = random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay);
		achievID, achievGUID = Gratz:ParseAchievementLink(message)
		Gratz:AddToNeoPending("Guild", achiever, GetRealmName(), achievID)
		Gratz:PrintoutNeoPending()
		if guildTimer == nil then
			guildTimer = Gratz:ScheduleTimer("SendGuildGratz", random(1,Gratz.db.profile.Delay), {})
		end

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
		if Gratz.db.profile.DingOn == true then  --{"Raid", "Party", "Battleground", "Guild"},
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
function Gratz:DingHandler (dingerGUID, channel)  --name = "Special Characters/n#n: Name of the leveler./n#c: Class of the leveler./n#r: Race of the leveler.",
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
		end
	end
	
end