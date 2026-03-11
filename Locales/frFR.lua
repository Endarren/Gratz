--localization file for french/France
local L = LibStub("AceLocale-3.0"):NewLocale("Gratz", "frFR")
if ( not L ) then 
    return;
end
-- =================================================================================================================================== --
--Premade Gratz messages
-- =================================================================================================================================== --
L["GRATZ"] = "Gratz"
L["INDIVIDUALGRATZ1"] = "Félicitations #n"
L["GROUPGRATZ1"] = "Félicitations à tous"
L["DINGGRATZ1"] = "Félicitations pour nivellement par le haut"
-- =================================================================================================================================== --
-- Battleground Victory Messages
-- =================================================================================================================================== --
L["BGVICT1"] = "Tous bien fait!"
L["BGVICT2"] = "Pour le #f!"
L["BGVICT3"] = "Bonne #b tout le monde!"
L["BGVICT4"] = "Nous avons remporté une grande victoire pour le #f ici à #b!"
L["BGVICT5"] = "Le #e vermine a été éradiquée."
-- =================================================================================================================================== --
L["9000I"] = "#n, what does the scouter say about your power level?"
L["9000G"] = "What does the scouter say about your power level?"
-- =================================================================================================================================== --
-- Guild Gratz Messages
-- =================================================================================================================================== --
L["GUILD_SINGLE_GRATZ"] = "Congrats #n! Gardez apportant #g up!"
L["GUILD_GROUP_GRATZ"] = "Félicitations! Gardez apportant #g up!"
-- =================================================================================================================================== --
--Individual Premade Gratz UI
-- =================================================================================================================================== --
L["INDIVIDUAL_NAME"] = "Félicitations individuelles"
L["INDIVIDUAL_MESSAGE"] = "Message"
L["INDIVIDUAL_DESC"] = "Ces félicitations sont des réalisations d'une personne."
L["INDIVIDUAL_MESSAGE_DESC"] = "Caractères spéciaux"

L["INDIVIDUAL_MESSAGE_DESC1"] ="#n: Nom du performants."
L["INDIVIDUAL_MESSAGE_DESC2"] ="#a: Nom de l'atteinte."
L["INDIVIDUAL_MESSAGE_DESC3"] ="#a: Name of the achievement."
-- =================================================================================================================================== --
--Group
-- =================================================================================================================================== --
L["GROUP_MESSAGE_NAME"] = "Message"
L["GROUP_MESSAGE_DESC"] = "Caractères spéciaux"

-- =================================================================================================================================== --
--Ding UI
-- =================================================================================================================================== --
L["DING_GROUP"] = "Ding"
L["DING_NAME"] = "Ding Message"

L["DING_DESC"] = "Caractères spéciaux"
L["DING_DESC1"] = "#n: Nom de la planeuse."
L["DING_DESC2"] = "#c: Classe de la planeuse."
L["DING_DESC3"] = "#r: Course de la planeuse."

L["DING_CHANNEL_NAME"] = ""
L["DING_GROUP_DESC"] = "Quels sont les canaux que vous allez faire pendant félicitations pour"
L["DING_STR"] = "%f[%a]ding%f[%A]"
-- =================================================================================================================================== --
--Specials
-- =================================================================================================================================== --
L["SPECIAL_PLAYERS_UI"] = "Les joueurs spéciales"
L["SPECIALS_TITLE"] = "Promotions"
L["PLAYER_NAME"] = "Nom du joueur"
L["REALM_NAME"] = "Nom de domaine"
L["THIS_REALM"] = "ce royaume"
L["SPECIAL_ADD_PERSON"] = "Ajouter personne"
L["SPECIAL_MESSAGE_NAME"] = "Message"
--L["IGNOREA"] = "Ignore Achieves"
L["IGNORE_DESC"] = ""

L["WHISPER_DESC"] = "Définit si félicitations sont chuchotés à la personne ou tout simplement envoyés normalement."
L["SPECIAL_GRATZ_ON"] = "Félicitations particulières ont permis"
L["SPECAL_GRATZ_ON_DESC"]="Bascule si ce joueur sera envoyé congrats messages faites pour ce joueur ou pas"
L["NEW_SPECIAL_GRATZ"] = "Nouveaux Félicitations particulières"
L["SPECIAL_ADD_GRATZ"] = "Ajouter"


-- =================================================================================================================================== --
--Battleground 
-- =================================================================================================================================== --
L["BG_VICTORY_GROUP"] = "Battleground Victoire Messages"
L["BG_VICTORY_MESSAGE_NAME"] = "Victoire Messagee"
L["BG_VICTORY_MESSAGE_DESC"] = "Tapez le message et cliquez sur OK pour l'enregistrer."
L["BG_INSERT_DESC"] = "Caractères spéciaux"
L["BG_INSERT_DESC1"] = "#b: Le nom du champ de bataille."
L["BG_INSERT_DESC2"] = "#f: Le nom de votre faction."
L["BG_INSERT_DESC3"] = "#e: Le nom de la faction ennemie."
-- =================================================================================================================================== --
--Global terms
-- =================================================================================================================================== --
L["ENABLED"] = "Activé"
L["DELETE"] = "Effacer"
L["ADD_MESSAGE"] = "Ajouter un message"
L["TEST"] = "Test Message"
L["MESSAGE"] = "Message"
L["ADD"] = "Ajouter"
L["TEST_BUTTON"] = "Test"
L["TESTS"] = "Tests"
L["GROUP"] = "Groupe"
L["SINGLE"] = "Unique"
L["IGNORE"] = "Ignorer"

L["ADD_SINGLE"]= "Ajouter simple"
L["ADD_GROUP"] = "Ajouter un groupe"
L["ACHIEVE_ID"] = "réalisation ID"
L["ID"] = "ID"
L["REALM"] = "Domaine"
L["NAME"] = "Nom"
L["NAME_COLON"] = "Nom: "
-- =================================================================================================================================== --
-- AFK
-- =================================================================================================================================== --
L["AFK"] = "AFK"
L["AFK_DESC"] = "Définit si un bravo seront fixés si vous êtes AFK"


-- =================================================================================================================================== --
-- Delay
-- =================================================================================================================================== --
L["MAXDELAY"] = "Délai maximum (secondes)"
L["MINDELAY"] = "Délai minimum (secondes)"
-- =================================================================================================================================== --
--Channels
-- =================================================================================================================================== --
L["CHANNEL"] = "Filières"
L["CHANNEL_DESC"] = "Définit quels canaux qu'un atteindre est reçu de obtiendra un congratz"
L["PARTY"] = "Groupe"
L["RAID"] = "Raid"
L["BATTLEGROUND"] = "champ de bataille"
L["GUILD"] = "Guilde"
L["NEARBY"] = "Proche"
L["WHISPER"] = "Murmure"
-- =================================================================================================================================== --
--Factions
-- =================================================================================================================================== --
L["Alliance"] = "Alliance"
L["Horde"] = "Horde"
-- =================================================================================================================================== --

L["PLAYER_NAME"] = "Nom du joueur"
L["PLAYER_REALM"] = "Royaume du joueur"

-- =================================================================================================================================== --
-- Group Gratz UI
-- =================================================================================================================================== --
L["GROUP_GRATZ_UI"] = "Félicitations du Groupe"

-- =================================================================================================================================== --
--Priorities
-- =================================================================================================================================== --
L["PRIORITIES"] = "Priorités"
L["PRIORITY_NORMAL"] = "Normal"
L["PRIORITY_SPECIFIC"] = "Spécifique"
L["PRIORITY_SPECIAL"] = "Spécial"
-- =================================================================================================================================== --
L["SPECIFIC_ACHIEVE_UI"] = "Réalisations Spécifiques"
-- =================================================================================================================================== --
-- Test UI
-- =================================================================================================================================== --
L["TEST_PRINTOUT"] = "Normal:  %d  Spécifique:  %d  Spécial:  %d"

-- =================================================================================================================================== --
L["DELAY_NOTE"] = "Remarque: Il peut prendre un moment pour ce faire le plein une fois que vous connectez pour la première."
-- =================================================================================================================================== --
--Realm Toggle
-- =================================================================================================================================== --
L["REALM_TOGGLE"] = "Inclure Nom de domaine"
L["REALM_DESC"] = "Définit s'il faut inclure le nom de domaine d'un joueur dans les félicitations"
-- =================================================================================================================================== --
-- Guild Gratz UI
-- =================================================================================================================================== --
L["GUILD_GRATZ_DESC"] = "Ce sont des félicitations uniquement pour les membres de la guilde."
L["GUILD_GRATZ_TOGGLE"] = "N'utilisez que des félicitations de guilde dans la guilde"