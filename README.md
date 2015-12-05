## GuildWho
Title: GuildWho

Notes: Keeps track of a variety of information about Guild Members. Guild Join Date, Rank Change Date, Kick Date,Who Kicked. Total Chat Lines and Achievements.

Author: Veritas83 (GitHub) aka DatMage (Warmane)

Version: 0.0.8

Usage:

/gwho - show help

Local output

/gwho Nick - Performs Lookup on saved data. Checks Join Date, Rank Change Date and, if it exists, Kick Date and by whom.

/gwho stats Nick - Preforms Lookup on saved Stats data. Counts # of Guild Chat Lines and # of Achievements

Guild chat output

/gwho statsg Nick - Preforms Lookup on saved Stats data. Counts # of Guild Chat Lines and # of Achievements. Outputs in Guild Chat.

Manual Database submission (These are detected and added automatically while the Addon is loaded, except KickReason)

/gwho addjoin Nick 11/22/15 11/22/15 - Manual join submit

/gwho addkick Nick 11/22/15 KickedBy - Manual kick submit

/gwho addkickr Nick KickeReason - Manual kick reason submit
