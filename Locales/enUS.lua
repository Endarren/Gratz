--localization file for english/United States
local L = LibStub("AceLocale-3.0"):NewLocale("Gratz", "enUS", true)
if ( not L ) then 
    return;
end

--Premade Gratz messages
L["INDIVIDUALGRATZ1"] = "Congratz #n"

L["GROUPGRATZ1"] = "Congratz everyone"
L["DINGGRATZ1"] = "Congratz on leveling up"

L["BGVICT1"] = "Well done everyone!"
L["BGVICT2"] = "For the #f!"
L["BGVICT3"] = "Good #b everyone!"
L["BGVICT4"] = "We have won a great victory for the #f here at #b!"
L["BGVICT5"] = "The #e vermin have been eradicated."

L["9000I"] = "#n, what does the scouter say about your power level?"
L["9000G"] = "What does the scouter say about your power level?"

L["GUILD_SINGLE_GRATZ"] = "Congratz #n!  Keep bringing #g up!"
L["GUILD_GROUP_GRATZ"] = "Congratz!  Keep bringing #g up!"
--UI Messages

--Individual
L["INDIVIDUAL_NAME"] = "Individual Gratz"
L["INDIVIDUAL_MESSAGE"] = "Message"
L["INDIVIDUAL_DESC"] = "These gratz are for achievements from one person."
L["INDIVIDUAL_MESSAGE_DESC"] = "Special Characters"

L["INDIVIDUAL_MESSAGE_DESC1"] ="#n: Name of the achievers."
L["INDIVIDUAL_MESSAGE_DESC2"] ="#a: Name of the achievement."
--L["INDIVIDUAL_MESSAGE_DESC3"] ="#a: Name of the achievement."

--Group
L["GROUP_MESSAGE_NAME"] = "Message"
L["GROUP_MESSAGE_DESC"] = "Special Characters"



--Ding
L["DING_GROUP"] = "Ding"
L["DING_NAME"] = "Ding Message"

L["DING_DESC"] = "Special Characters"
L["DING_DESC1"] = "#n: Name of the leveler."
L["DING_DESC2"] = "#c: Class of the leveler."
L["DING_DESC3"] = "#r: Race of the leveler."

L["DING_CHANNEL_NAME"] = ""
L["DING_GROUP_DESC"] = "Which channels will you do ding gratz for"

--Specials
L["SPECIALS_TITLE"] = "Specials"
L["PLAYER_NAME"] = "Player name"
L["REALM_NAME"] = "Realm name"
L["THIS_REALM"] = "This Realm"
L["SPECIAL_ADD_PERSON"] = "Add person"
L["SPECIAL_MESSAGE_NAME"] = "Message"
L["IGNORE"] = "Ignore Achieves"
L["IGNORE_DESC"] = ""
L["WHISPER"] = "Whisper"
L["WHISPER_DESC"] = "Sets whether gratz are whispered to the person or just sent normally."
L["SPECIAL_GRATZ_ON"] = "Specific gratz enabled"
L["SPECAL_GRATZ_ON_DESC"]="Toggles whether this player will be sent gratz messages made for that player or not"
L["NEW_SPECIAL_GRATZ"] = "New Specific Gratz"
L["SPECIAL_ADD_GRATZ"] = "Add"



--Battleground 
L["BG_VICTORY_GROUP"] = "Battleground Victory Messages"
L["BG_VICTORY_MESSAGE_NAME"] = "Victory Message"
L["BG_VICTORY_MESSAGE_DESC"] = "Type in the message and click okay to save it."
L["BG_INSERT_DESC"] = "Special characters"
L["BG_INSERT_DESC1"] = "#b: The name of the Battleground."
L["BG_INSERT_DESC2"] = "#f: The name of your faction."
L["BG_INSERT_DESC3"] = "#e: The name the enemy faction."

--Global terms
L["ENABLED"] = "Enabled"
L["DELETE"] = "Delete"
L["ADD_MESSAGE"] = "Add Message"
L["TEST"] = "Test Message"

L["AFK"] = "AFK"
L["AFK_DESC"] = "Sets whether a gratz will be set if you are AFK"

L["CHANNEL"] = "Channels"
L["CHANNEL_DESC"] = "Sets what channels that an achieve is received from will get a gratz"

L["MAXDELAY"] = "Max Delay (Seconds)"
L["MINDELAY"] = "Min Delay (Seconds)"

L["PARTY"] = "Party"
L["RAID"] = "Raid"
L["BATTLEGROUND"] = "Battleground"
L["GUILD"] = "Guild"
L["NEARBY"] = "Nearby"
L["WHISPER"] = "Whisper"

L["Alliance"] = "Alliance"
L["Horde"] = "Horde"