Similar to AutoGratz, but with some more features, such as messages for specific people or achievements.

Working Features
Guild gratz.
Battleground Victory
Gratz for specific achievements.
Gratz for specific people.
Ding
Settings
Disable: This option makes it so that the addon does not send gratz messages at all.
Delay: This sets the range of delay before sending a gratz. The delay is in seconds. You do not want to use a delay of 0 seconds because it might send a gratz before the achievement is posted. The delay is selected randomly within the range you provide here.
AFK: Sets whether gratz messages are sent while you are AFK.
Party: Sets whether you do gratz for those in your party (Not the same as a raid or battleground group).
Raid: Sets whether you do gratz for those in your raid group.
Battleground: Sets whether you do gratz for those in your battleground group.
Nearby: Sets whether you do gratz for those nearby who are not in your group.
Guild: Sets whether you do gratz for those in your guild.
Ding Spam Timer: Sets how long the addon will send another ding message after the last one from the dinger.
Priorities: These are three values that are used to determine where a gratz message is taken from. Normal is for the standard messages for individuals and groups. Specific is for when an achievement that you marked for a unique message is pending a gratz. And special is for people you marked for special gratz. The lower the number, the higher the priority. If two priorities have the same value, a random tiebreaker is done.
Message Formats

Messages can be just plain text that you write out in the interface. There are some variable values that you can put in that will be replaced when the message goes out.

#n: Name of the achiever (Only for individual gratz messages)
#g: Name of the guild (Only for guild gratz messages)
#f: Name of your faction. (Currently only for Battlegrounds, but might be added to all. Also in rated battlegrounds, I do not know what it will use if you are playing the opposite faction's side).
#e: Name of the enemy faction (Same as #f).
#b: Name of the battleground (Battleground victory messages only).
#x: The number of achieves a person is being grated for (Individual messages only. NOT IN USE YET).
#c: Class name of the achiever (Individual messages only. NOT IN USE YET).
#r: Race of the achiever (Individual messages only. NOT IN USE YET).
#a: Link of achievement. (Specific achievement gratz messages only. NOT IN USE YET).

You can also use the target marker symbols in the messages the same way you would in normal chat.

{cross}: Red X.
{skull}: White Skull
{square}: Blue Square.
{diamond): Purple Diamond
{circle}: Orange Circle.
{triangle}: Green Triangle.
{star}: Yellow Star.

You might also be able to use some of the other chat variables, like %n for the name of a target, in your messages, so try to experiment with them. I will add a message test function for you to see what a message might look like.

Battleground Victory

These are messages that are used when you win a battleground.

I eventually want to add in this feature for arenas, Wintergrasp, and Tol Barad. I might also add in a feature to deal with the situation in rated battlegrounds where you are playing as the enemy faction: i.e. an Alliance team playing as the Horde team.

Special Gratz

This feature will allow you to create settings for certain people.

Blacklist: Set whether a player will be ignored for gratz.
Whisper: Set whether a gratz is sent in a whisper to that player instead. In the case of others earning achievements, it will do both a whisper and a regular gratz to the others.
Special Message: Messages for that player as well as messages for when that player earns the achievement with others.
Specific Gratz

Similar to special gratz, except for certain achievements, instead of players.

Blacklist: Set whether an achievement will be ignored for gratz. Blacklisted achievements are colored red on the list.
Specific Message: Messages for that achievement. Has both individual and group messages.
Ideas
Add option to use only guild messages in guild chat and not use messages for single and group.
