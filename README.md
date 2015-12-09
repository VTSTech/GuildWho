## GuildWho
Title: GuildWho

Notes: Keeps track of a variety of information about Guild Members. Guild Join Date, Rank Change Date, Kick Date,Who Kicked. Total Chat Lines and Achievements.

Author: Veritas83 (GitHub) aka DatMage (Warmane)

Version: 0.1.1

Usage:

/gwho - show help

Local output

/gwho Nick - Performs Lookup on saved data. Checks Join Date, Rank Change Date and, if it exists, Kick Date and by whom.

/gwho stats Nick - Preforms Lookup on saved Stats data. Counts # of Guild Chat Lines and # of Achievements

Guild Chat output

/gwho statsg Nick - Preforms Lookup on saved Stats data. Counts # of Guild Chat Lines and # of Achievements. Outputs in Guild Chat.

/gwho showver - Displays version info and GitHub link

Settings

/gwho guildcmd - Toggles responding to .gwho Nick in guild chat

/gwho usekickr - toggles use of default kick reason

/gwho setkickr - sets the default kick reason

/gwho showkickr - shows the currently set kick reason

Manual Database submission (These are detected and added automatically while the Addon is loaded, except KickReason)

/gwho addjoin Nick 11/22/15 11/22/15 - Manual join submit

/gwho addkick Nick 11/22/15 KickedBy - Manual kick submit

/gwho addkickr Nick KickReason - Manual kick reason submit, Should be done for all kicks. (Not needed since v0.1.1, Default Kick Reason support added)

