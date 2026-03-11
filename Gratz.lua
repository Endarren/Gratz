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
local pendingGratzTable =	{
								Raid			= {Achieves = {}, Earners = {}},
								Party			= {Achieves = {}, Earners = {}},
								Battleground	= {Achieves = {}, Earners = {}},
								Guild			= {Achieves = {}, Earners = {}},
								Nearby			= {Achieves = {}, Earners = {}}
}
-- ======================================================================================================================= --


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
	print("RAID GRATZ")
	channelMessageSent = false;
	details = Gratz:FindDetails("Raid")
	messageType = 1; --Single
	
	if details.earnernumber  > 1 then
		messageType = 2; --Group
	end

	
	
		if messageType == 1 then
		
			messageIndex = random(1,#Gratz.db.profile.IndividualGratz)
			mess = Gratz.db.profile.IndividualGratz[messageIndex].Message
			if pendingGratzTable.Raid.Earners[1] ~= nil then
				name, rea = strsplit("_", pendingGratzTable.Raid.Earners[1])
		--pendingGratzTable.Party.Earners
				mess   = string.gsub(mess, "#n", name)
				if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
					SendChatMessage(mess,"INSTANCE_CHAT")
				else
					SendChatMessage(mess,"RAID")
				end
			
			else
				print("Error: There were no earners.")
			end
		else
			messageIndex = random(1,#Gratz.db.profile.GroupGratz)
			mess = Gratz.db.profile.GroupGratz[messageIndex].Message
			if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
				SendChatMessage(mess,"INSTANCE_CHAT")
			else
				SendChatMessage(mess,"RAID")
			end
			print("Raid Achievement message.  MessageType:  "..messageType)

		end
	
	
	--Are there any specials on the list?
	--Are there any specific achieves?
		
		--TODO Find out if any of the 

	
	
	
	--Clear tables
	pendingGratzTable.Raid.Achieves = {}
	pendingGratzTable.Raid.Earners = {}
	raidTimer = nil;
end
function Gratz:PartyAchieveTimer(something)
	channelMessageSent = false;
	print("PARTY GRATZ")
	--Determine what kind of gratz message to send.
	details = Gratz:FindDetails("Party")
	messageType = 1; --Single
	
	if details.earnernumber  > 1 then
		messageType = 2; --Group
	end

	print("Specials "..#details.specials)
	print("Specifics "..#details.specifics)
		if messageType == 1 then
		
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

		else
			messageIndex = random(1,#Gratz.db.profile.GroupGratz)
			mess = Gratz.db.profile.GroupGratz[messageIndex].Message
			if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
				SendChatMessage(mess,"INSTANCE_CHAT")
			else
				SendChatMessage(mess,"PARTY")
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
	print("BG GRATZ")
	--Determine what kind of gratz message to send.
	details = Gratz:FindDetails("Battleground")
	messageType = 1; --Single
	
	if details.earnernumber  > 1 then
		messageType = 2; --Group
	end


	
	if messageType == 1 then
		
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
		
		print("BG Achievement message.  MessageType:  "..messageType)
	else
		messageIndex = random(1,#Gratz.db.profile.GroupGratz)
		mess = Gratz.db.profile.GroupGratz[messageIndex].Message
		if(IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
			SendChatMessage(mess,"INSTANCE_CHAT")
		else
		SendChatMessage(mess,"BATTLEGROUND")
		end
		print("BG Achievement message.  MessageType:  "..messageType)

	end
	
	
	--Are there any specials on the list?
	--Are there any specific achieves?
		
		--TODO Find out if any of the 

	--Clear tables
	pendingGratzTable.Battleground.Achieves = {}
	pendingGratzTable.Battleground.Earners = {}
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
	if channel == "Raid" then
		--Add achievement.
		if pendingGratzTable.Raid.Achieves[achieve] == nil then
			pendingGratzTable.Raid.Achieves[achieve] = 1
		else
			pendingGratzTable.Raid.Achieves[achieve] = pendingGratzTable.Raid.Achieves[achieve] +1
		end
		--Add the achiever.
		pendingGratzTable.Raid.Earners[name.."_"..realm] = true;

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
			print("Adding "..name)
		
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
				if channel == "Guild" then
					--Add achievement.
					if pendingGratzTable.Guild.Achieves[achieve] == nil then
						pendingGratzTable.Guild.Achieves[achieve] = 1
					else
						pendingGratzTable.Guild.Achieves[achieve] = pendingGratzTable.Guild.Achieves[achieve] +1
					end
					--Add the achiever.
					pendingGratzTable.Guild.Earners[name.."_"..realm] = true;
		
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
						SpecificAchievementGratz = {},
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
--	Specials
-- ========================================================================================== --
---Fields
local tempName = ""
local tempRealm = ""
local tempgratz = ""
local tempgratz2 = ""

local SpecialsOptions	=		{
type = "group",
name = L["SPECIALS_TITLE"],
args =	{
			NameBox1 =		{
								type = "input",
								name = L["PLAYER_NAME"],
								get = function () return tempName end,
								set = function (info, val) tempName = val end,
								order = 1
							},
			RealmBox1 =		{
								type = "input",
								name = L["REALM_NAME"],
								get = function () return tempRealm end,
								set = function (info, val) tempRealm = val end,
								order = 2
							},
			ThisRealm1 =	{
								type = "execute",
								name = L["THIS_REALM"],
								order = 3,
								func = function() tempRealm = GetRealmName() end
							},
			AddButton1 =	{
								type = "execute",
								name = L["SPECIAL_ADD_PERSON"],
								func = function() 
											Gratz:AddPersonToSpecials(tempName, tempRealm) 
											tempRealm	= ""
											tempName	= ""
										end,
								order = 4
							}
		}
								}

---
-- This function adds a person to the specials list.
--@Param name The name of the achiever.
--@Param realm The realm name of the achiever.
function Gratz:AddPersonToSpecials(name, realm)
	key = name.."_"..realm;
	if Gratz.db.profile.Specials[key] == nil then
		Gratz.db.profile.Specials[key] = {Ignore = false, Whisper = false, Specific = false, SpecificList = {Single = {}, Group = {}}}
		Gratz:AddPersonToSpecialssUI(key)
		return true
	else
		return false
	end
end

function Gratz:AddPersonToSpecialssUI(namerealm)
	print(namerealm);
	if SpecialsOptions.args[namerealm] == nil then

		if Gratz.db.profile.Specials[namerealm] ~= nil then
			print(namerealm);
			SpecialsOptions.args[namerealm] =	{
													type = "group",
													name = namerealm,
													agrs =	{
																IgnoreCheck1 =	{
																					type = "toggle",
																					name = L["IGNORE"] ,
																					desc = L["IGNORE_DESC"] ,
																					get = function () return Gratz.db.profile.Specials[namerealm].Ignore end,
																					set = function (info, val) Gratz.db.profile.Specials[namerealm].Ignore = val end,
																					order = 1
																				},
																WhisperGratz1 = {
																					type = "toggle",
																					name = L["WHISPER"],
																					desc = L["WHISPER_DESC"],
																					get = function () return Gratz.db.profile.Specials[namerealm].Whisper end,
																					set = function (info, val) Gratz.db.profile.Specials[namerealm].Whisper = val end,
																					order = 2
																				},
															SpecificGratz1 =	{
																					type = "toggle",
																					name = L["SPECIAL_GRATZ_ON"],
																					desc = L["SPECAL_GRATZ_ON_DESC"],
																					get = function () return Gratz.db.profile.Specials[namerealm].Specific end,
																					set = function (info, val) Gratz.db.profile.Specials[namerealm].Specific = val end,
																					order = 3
																				},
															SpecificGratzAdd1 =	{
																					type = "input",
																					name = L["NEW_SPECIAL_GRATZ"],
																					get = function() return tempgratz end,
																					set = function (info, val) tempgratz = val end,
																					order = 4
															},
															SpecificGratzAdd2 =	{
																					type = "input",
																					name = "Group",
																					get = function() return tempgratz2 end,
																					set = function (info, val) tempgratz2 = val end,
																					order = 4
															},
															AddSpecificGratz1 =	{
																					type = "execute",
																					name = L["SPECIAL_ADD_GRATZ"],
																					order = 5,
																					func = function() Gratz:AddNewSpecificGratz(namerealm, tempgratz,tempgratz2)  end
																				}
															}
												}
		--Gratz:AddNewSpecificGratz(namerealm, "Gratz")
			for k, v in pairs(Gratz.db.profile.Specials[namerealm].SpecificList) do
				Gratz:AddNewSpecificGratz(namerealm, v.Single,v.Group);
			end

		else

		end
		
	else
	
	end

end	

--- This function fills up the configuration UI list of all the 
-- special entries.
function Gratz:FillUpSpecials()
	for key, val in pairs (Gratz.db.profile.Specials) do
		--Gratz:AddPersonToSpecialssUI(key)	
	
	end
end


function Gratz:AddSpecificGratz(namerealm, key)
	SpecialsOptions.args[namerealm].args[tostring(#Gratz.db.profile.Specials.SpecificList)] =	{
		messBoxs =	{
						type = "input",
						name = L["SPECIAL_MESSAGE_NAME"],
						get = function() return Gratz.db.profile.Specials.SpecificList[key].Single end,
						set = function (info, val) Gratz.db.profile.Specials.SpecificList[key].Single = val end,
						order = 1,
						width = "full"
		},
		messBox =	{
						type = "input",
						name = "Group",
						get = function() return Gratz.db.profile.Specials.SpecificList[key].Group end,
						set = function (info, val) Gratz.db.profile.Specials.SpecificList[key].Group = val end,
						order = 1,
						width = "full"
					},
		Delete =	{
						type = "execute",
						name = L["DELETE"] ,
						func =	function () 
								
								end,
						order = 2
					}
}

end

function Gratz:AddNewSpecificGratz(namerealm, messageS, messageG)
	if Gratz.db.profile.Specials[namerealm] ~= nil then
		tinsert(Gratz.db.profile.Specials[namerealm].SpecificList.Single, messageS)
		tinsert(Gratz.db.profile.Specials[namerealm].SpecificList.Group, messageG)
		key = #Gratz.db.profile.Specials[namerealm].SpecificList
		Gratz:AddSpecificGratz(namerealm, key)
	end

end

				
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
										}
								}
					}
-- =======================================================================================================
-- Ding Gratz
-- ======================================================================================================================							
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
									name = "Only use these in guild",
									
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
function Gratz:AddGroupGuild (message)
	Gratz.db.profile.GuildGratzGroup[#Gratz.db.profile.GuildGratzGroup] = {Message = message}
	tinsert(Gratz.db.profile.GuildGratzGroup,{Message = message})
	Gratz:AddGroupGuildUI (#Gratz.db.profile.GuildGratzGroup)
end
function Gratz:AddGroupGuildUI (key)
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
																						}

																	}


	}
end
function Gratz:AddSingleGuild (message)
	Gratz.db.profile.GuildGratzSingle[#Gratz.db.profile.GuildGratzSingle] = {Message = message}
	tinsert(Gratz.db.profile.GuildGratzSingle,{Message = message})
	Gratz:AddSingleGuildUI (#Gratz.db.profile.GuildGratzSingle)
end


function Gratz:AddSingleGuildUI (key)
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

function Gratz:FillGroupGratzOptions()
	for key, val in pairs (self.db.profile.GroupGratz) do
		Gratz:AddGroupMessage(key)
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
-- =======================================================================================================
function Gratz:OnInitialize()
    -- Called when the addon is loaded
	--Gratz:SetUpSpecificAchieveGratz()
	self.db = LibStub("AceDB-3.0"):New("GRATZ", defaults)
	Gratz:FillIndividualGratzOptions();
	Gratz:FillGroupGratzOptions()
	Gratz:FillBGVict ()
	Gratz:FillUpSpecials();
	Gratz:FillUpDing()
	Gratz:FillUpGuildGratz()
	local config = LibStub("AceConfig-3.0")
	local registry = LibStub("AceConfigRegistry-3.0")

	registry:RegisterOptionsTable("Gratz Main", GratzMain)
	registry:RegisterOptionsTable("Individual Gratz", IndividualGratzOptions)
	registry:RegisterOptionsTable("Group Gratz", GroupGratzOptions)
	registry:RegisterOptionsTable("Battleground Victory", BGVictoryOptions)
	registry:RegisterOptionsTable("Special Gratz",SpecialsOptions)
	registry:RegisterOptionsTable("Ding Gratz",DingGratzOptions)
	registry:RegisterOptionsTable("Guild Gratz",GuildGratzMenu)


	local dialog = LibStub("AceConfigDialog-3.0")

	self.optionFrames = {
							main		= dialog:AddToBlizOptions("Gratz Main", "Gratz"),
							Ind			= dialog:AddToBlizOptions("Individual Gratz","Individual Gratz", "Gratz"),
							gro			= dialog:AddToBlizOptions("Group Gratz","Group Gratz", "Gratz"),
							--ding		= dialog:AddToBlizOptions("Ding Gratz","Ding Gratz", "Gratz"),
							guild		=dialog:AddToBlizOptions("Guild Gratz","Guild Gratz", "Gratz"),
							bg			= dialog:AddToBlizOptions("Battleground Victory","Battleground Victory", "Gratz")--,
						--	Spe			= dialog:AddToBlizOptions("Special Gratz","Special Gratz", "Gratz")
						}

 
    -- Print a message to the chat frame
    self:RegisterEvent("CHAT_MSG_WHISPER")
    self:RegisterEvent("CHAT_MSG_ACHIEVEMENT")
    self:RegisterEvent("CHAT_MSG_GUILD")
    self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
    self:RegisterEvent("CHAT_MSG_RAID")
	self:RegisterEvent("CHAT_MSG_PARTY")
	self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	self:SecureHook("LeaveBattlefield","BGReset")
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
			if bgTimer == nil then
				bgTimer = Gratz:ScheduleTimer("BGAchieveTimer",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
			end

			--bgTimer

		end
		if UnitInRaid(sender) ~= nil and UnitInBattleground(sender) == nil then
			str = str.."raid"
			Gratz:AddEntryToPending("Raid", senderName, senderRealm, achieveID)
			if raidTimer == nil then
				raidTimer = Gratz:ScheduleTimer("RaidAchieveTimer",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
			end

			
		end
		if UnitInParty(sender) ~= nil and UnitInRaid(sender) == nil and UnitInBattleground(sender) == nil then
			str = str.."Party"
			Gratz:AddEntryToPending("Party", senderName, senderRealm, achieveID)
			if partyTimer == nil then
				partyTimer = Gratz:ScheduleTimer("PartyAchieveTimer",random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay),{})
			end

		end
		if UnitInParty(sender) == nil and UnitInRaid(sender) == nil and UnitInBattleground(sender) == nil then
			str = str.."nearby"
			Gratz:AddEntryToPending("Nearby", senderName, senderRealm, achieveID)
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
function Gratz:SendGuildGratz (input)

	guildTimer = nil;

	for akey, aval in pairs (pendingGratzTable.Guild.Achieves) do
		
		
	end
	guildieCount = 0;
	lastguildiename = nil;
	for pkey, pval in pairs (pendingGratzTable.Guild.Earners) do
		guildieCount = guildieCount + 1;
		lastguildiename = pkey;
	end
	if guildieCount == 1 then

		message = nil
		--Gratz.db.profile.UseOtherGratzForGuild
		indexmess = 0;

		if Gratz.db.profile.UseOtherGratzForGuild then
			indexmess = random(1,#Gratz.db.profile.GuildGratzSingle+#Gratz.db.profile.IndividualGratz)
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
		SendChatMessage(message,"GUILD")
	else

		indexmess = 0;

		if Gratz.db.profile.UseOtherGratzForGuild then
			indexmess = random(1,#Gratz.db.profile.GuildGratzGroup+#Gratz.db.profile.GroupGratz)
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
		SendChatMessage(message,"GUILD")
	end
	astr = ""
	estr = ""
	for akey, aval in pairs (pendingGratzTable.Guild.Achieves) do
		astr = astr .." "..akey
	end
	for pkey, pval in pairs (pendingGratzTable.Guild.Earners) do
		estr = estr .." "..pkey;
	end

	pendingGratzTable.Guild.Achieves = {}
	pendingGratzTable.Guild.Earners = {}
end
function Gratz:CHAT_MSG_GUILD_ACHIEVEMENT(event, message, achiever)
	if UnitName("player") ~= achiever and (Gratz.db.profile.AFKon or  UnitIsAFK("player") == nil) and Gratz:IsPersonOnIgnore(achiever, GetRealmName()) == false then
		
		tim = random(Gratz.db.profile.MinDelay,Gratz.db.profile.Delay);
		achievID, achievGUID = Gratz:ParseAchievementLink(message)
		Gratz:AddEntryToPending("Guild", achiever, GetRealmName(), achievID)		
		if guildTimer == nil then
			guildTimer = Gratz:ScheduleTimer("SendGuildGratz", random(1,Gratz.db.profile.Delay), {})
		end

	end
end

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
						SendChatMessage(mess, "BATTLEGROUND")
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
						SendChatMessage(mess, "BATTLEGROUND")
						hasSentVictoryMessageForBG = true
					end
				end
			end
		end
	end
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
				SendChatMessage(mess, "RAID")
				dingWait[dinger] = self.ScheduleTimer("RemoveDingHold", 60, dinger)
			end
			if channel == "PARTY" and Gratz.db.profile.DingChannels[2] == true then
				SendChatMessage(mess, "PARTY")
				dingWait[dinger] = self.ScheduleTimer("RemoveDingHold", 60, dinger)
			end
			if channel == "BATTLEGROUND" and Gratz.db.profile.DingChannels[3] == true then
				SendChatMessage(mess, "BATTLEGROUND")
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
				SendChatMessage(mess, "RAID")
				dingWait[name.."-"..realm] = self.ScheduleTimer("RemoveDingHold", 60, name.."-"..realm)
			end
			if channel == "PARTY" and Gratz.db.profile.DingChannels[2] == true then
				SendChatMessage(mess, "PARTY")
				dingWait[name.."-"..realm] = self.ScheduleTimer("RemoveDingHold", 60, name.."-"..realm)
			end
			if channel == "BATTLEGROUND" and Gratz.db.profile.DingChannels[3] == true then
				SendChatMessage(mess, "BATTLEGROUND")
				dingWait[name.."-"..realm] = self.ScheduleTimer("RemoveDingHold", 60, name.."-"..realm)
			end
			if channel == "GUILD" and Gratz.db.profile.DingChannels[4] == true then
				SendChatMessage(mess, "GUILD")
				dingWait[name.."-"..realm] = self.ScheduleTimer("RemoveDingHold", 60, name.."-"..realm)
			end
		end
	end
	
end