GuildWho_Saved = {}
GuildWho_Stats = {}
GuildWho_Kicked = {}
GuildWho_Alts = {}
GuildWho_Settings = {}

function GUILDWHO_OnLoad()
  gwhobuild = "v0.1.3";
  this:RegisterEvent("CHAT_MSG_SYSTEM")
	--arg1    The content of the chat message.
  this:RegisterEvent("CHAT_MSG_GUILD")
	--arg1    Message that was sent 
	--arg2    Author 
	--arg3    Language that the message was sent in 
	--arg11   Chat lineID 
	--arg12   Sender GUID       
	this:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
	--arg1    The full body of the achievement broadcast message. 
	--arg2, arg5    Guildmember Name 
	--arg11    Chat lineID 
	--arg12    Sender GUID 			
	this:RegisterEvent("ACHIEVEMENT_EARNED")
	--achievementID The unit that was affected. (string) 
	this:RegisterEvent("UNIT_LEVEL")
	--unitID  The unit that was affected. (string) 
	--slash commands
	SlashCmdList["GWHO"] = GUILDWHO_Command;
	SLASH_GWHO1 = "/guildwho";
	SLASH_GWHO2 = "/gwho";
	currPlayer = UnitName("player")
	print("|cffffcc00GuildWho", gwhobuild,"loaded!");
end

local function tContains(table, item)
       local index = 1;
       while table[index] do
               if ( item == table[index] ) then
                       if (msgsys == true) then
                       	sysindex = index;
                       	--print("|cffffcc00GuildWho", gwhobuild,"Debug: System Index Updated,", sysindex);
                       elseif (msgguild == true) then
                       	guildindex = index;
                       	--print("|cffffcc00GuildWho", gwhobuild,"Debug: Guild Index Updated,", guildindex);
                       elseif (msgguildach == true) then
                       	guildachindex = index;
                       	--print("|cffffcc00GuildWho", gwhobuild,"Debug: GuildAch Index Updated,", guildachindex);
                       elseif (msglocal == true) then
                       	localindex = index;
                       	--print("|cffffcc00GuildWho", gwhobuild,"Debug: Local Index Updated,", localindex);
                       end
                       return 1;
               end
               index = index + 1;
       end
       return nil;
end

function GUILDWHO_GetCmd(msg)
if msg then
	local a=(msg); --contiguous string of non-space characters
	if a then
		return msg
	else	
		return "";
	end
end
end

function GUILDWHO_ShowHelp()
print("|cffffcc00GuildWho", gwhobuild,"usage:");
print("|cffffcc00Local Output:");
print("|cffffcc00'/guildwho {guild_member}' or '/gwho {guild_member}'");
print("|cffffcc00'/guildwho stats {guild_member}' or '/gwho stats {guild_member}'");
--print("|cffffcc00'/guildwho alts {guild_member}' or '/gwho alts {guild_member}'");
print("|cffffcc00Guild Chat Output:");
print("|cffffcc00'/guildwho statsg {guild_member}' or '/gwho statsg {guild_member}'");
print("|cffffcc00'/guildwho showver' or '/gwho statsg shover'");
print("|cffffcc00Manual Database submission:");
print("|cffffcc00'/guildwho addjoin {guild_member} mm/dd/yy mm/dd/yy' or '/gwho addjoin {guild_member} mm/dd/yy mm/dd/yy'");
print("|cffffcc00'/guildwho addjoinl {guild_member} {level}' or '/gwho addjoinl {guild_member} {level}'");
print("|cffffcc00'/guildwho addkick {guild_member} mm/dd/yy KickedBy' or '/gwho addkick {guild_member} mm/dd/yy KickedBy'");
print("|cffffcc00'/guildwho addkickr {guild_member} KickReason' or '/gwho addkick {guild_member} KickReason'");
print("|cffffcc00Settings:");
print("|cffffcc00'/gwho guildcmd' - Guild Chat .gwho command trigger on/off (Default: Off)");
print("|cffffcc00'/gwho usekickr' - Toggle use of the default Kick Reason");
print("|cffffcc00'/gwho setkickr' - Set the default Kick Reason");
print("|cffffcc00'/gwho showkickr'- Display the currently set Kick Reason");
end

function GUILDWHO_Command(msg)
   local Cmd, SubCmd = GUILDWHO_GetCmd(msg);
   if (Cmd == "")then
      GUILDWHO_ShowHelp();
   elseif (strsub(Cmd,1,8) == "addjoin ")then	
      --print("|cffffcc00'addjoin trigger!");
      local n=0;
      for token in string.gmatch(Cmd, "[^%s]+") do
         -- print(token)
         n=n + 1;
         if (n == 2)then
            PlayerName = token;
         elseif (n == 3)then
            JoinDate = token;
         elseif (n == 4)then
            RankDate = token;
         end
      end
      if (tContains(GuildWho_Saved,PlayerName) == 1) then
      print("|cffffcc00GuildWho", gwhobuild," Player Name:", PlayerName,"is already in the database.");
      else
      print("|cffffcc00GuildWho", gwhobuild," Player Name:", PlayerName,"Join Date: ", JoinDate, "Rank Changed: ", RankDate);
			tinsert(GuildWho_Saved,getn(GuildWho_Saved),PlayerName) -- character name
			tinsert(GuildWho_Saved,getn(GuildWho_Saved),JoinDate)   -- join date
			tinsert(GuildWho_Saved,getn(GuildWho_Saved),RankDate)   -- rank change date      
			print("|cffffcc00GuildWho", gwhobuild,"Data stored. use /rl or logout/quit/camp to commit to disk.");
			end
  elseif (strsub(Cmd,1,9) == "addjoinl ")then
      --print("|cffffcc00'addjoinl trigger!");
      local guild, realm = (GetGuildInfo("player")), GetRealmName()
      local n=0;
      for token in string.gmatch(Cmd, "[^%s]+") do
         -- print(token)
         n=n + 1;
         if (n == 2)then
            PlayerName = token;
         elseif (n == 3)then
            JoinLevel = token;
         end
      end
			if (GuildWho_Stats[realm] == nil) then
			GuildWho_Stats[realm] = {}
			end
			if (GuildWho_Stats[realm][guild] == nil) then
			GuildWho_Stats[realm][guild] = {}
			end
			if(GuildWho_Stats[realm][guild][PlayerName] == nil) then
			GuildWho_Stats[realm][guild][PlayerName] = {}
			end
			if(GuildWho_Stats[realm][guild][PlayerName]["Join Level"] == nil) then
			GuildWho_Stats[realm][guild][PlayerName]["Join Level"] = {}
			end
			if(GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] == nil) then
			GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] = {}
			end
      if (GuildWho_Stats[realm][guild][PlayerName]) then
      print("|cffffcc00GuildWho", gwhobuild," Player Name:", PlayerName,"Join Level: ", JoinLevel);
			GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] = JoinLevel
			print("|cffffcc00GuildWho", gwhobuild,"Data stored. use /rl or logout/quit/camp to commit to disk.");
      else
      print("|cffffcc00GuildWho", gwhobuild," Player Name:", PlayerName,"is not in the database.");
			end			
	--testing v0.0.8
  elseif (strsub(Cmd,1,8) == "addkick ")then
      --print("|cffffcc00'addkick trigger!");
      local guild, realm = (GetGuildInfo("player")), GetRealmName()
      local n=0;
      for token in string.gmatch(Cmd, "[^%s]+") do
         -- print(token)
         n=n + 1;
         if (n == 2)then
            PlayerName = token;
         elseif (n == 3)then
            KickDate = token;
         elseif (n == 4)then
            KickedBy = token;
         end
      end
			if (GuildWho_Kicked[realm] == nil) then
			GuildWho_Kicked[realm] = {}
			end
			if (GuildWho_Kicked[realm][guild] == nil) then
			GuildWho_Kicked[realm][guild] = {}
			end
			if(GuildWho_Kicked[realm][guild][PlayerName] == nil) then
			GuildWho_Kicked[realm][guild][PlayerName] = {}
			end
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kick Date"] == nil) then
			GuildWho_Kicked[realm][guild][PlayerName]["Kick Date"] = {}
			end
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kicked By"] == nil) then
			GuildWho_Kicked[realm][guild][PlayerName]["Kicked By"] = {}
			end
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kick Date"]["value"] == nil) then
			GuildWho_Kicked[realm][guild][PlayerName]["Kick Date"]["value"] = {}
			end
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kicked By"]["value"] == nil) then
			GuildWho_Kicked[realm][guild][PlayerName]["Kicked By"]["value"] = {}
			end
      if (GuildWho_Kicked[realm][guild][PlayerName]) then
      print("|cffffcc00GuildWho", gwhobuild," Player Name:", PlayerName,"is already in the database.");
      else
      print("|cffffcc00GuildWho", gwhobuild," Player Name:", PlayerName,"Kick Date: ", KickDate, "Kicked by: ", KickedBy);
			GuildWho_Kicked[realm][guild][PlayerName]["Kick Date"]["value"] = KickDate
			GuildWho_Kicked[realm][guild][PlayerName]["Kicked By"]["value"] = KickedBy   
			print("|cffffcc00GuildWho", gwhobuild,"Data stored. use /rl or logout/quit/camp to commit to disk.");
			end
  elseif (strsub(Cmd,1,9) == "addkickr ")then
      --KickReason isnt specified by the system anywhere, so it will have to be manually added
      --for each kick. A kick is added and 'Kick Reason' table is not created until this is run.
      --print("|cffffcc00'addkickr trigger!");
      local guild, realm = (GetGuildInfo("player")), GetRealmName()
      local n=0;
      for token in string.gmatch(Cmd, "[^%s]+") do
         -- print(token)
         n=n + 1;
         if (n == 2)then
            PlayerName = token;
         elseif (n == 3)then
            KickReason = token;
         elseif (n >= 4)then
         		KickReason = KickReason .. "." .. token
         end
      end
			if (GuildWho_Kicked[realm] == nil) then
			GuildWho_Kicked[realm] = {}
			end
			if (GuildWho_Kicked[realm][guild] == nil) then
			GuildWho_Kicked[realm][guild] = {}
			end
			if(GuildWho_Kicked[realm][guild][PlayerName] == nil) then
			GuildWho_Kicked[realm][guild][PlayerName] = {}
			end
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kick Date"] == nil) then
			GuildWho_Kicked[realm][guild][PlayerName]["Kick Date"] = {}
			end
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kicked By"] == nil) then
			GuildWho_Kicked[realm][guild][PlayerName]["Kicked By"] = {}
			end
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kick Date"]["value"] == nil) then
			GuildWho_Kicked[realm][guild][PlayerName]["Kick Date"]["value"] = {}
			end
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kicked By"]["value"] == nil) then
			GuildWho_Kicked[realm][guild][PlayerName]["Kicked By"]["value"] = {}
			end
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kick Reason"] == nil) then
      GuildWho_Kicked[realm][guild][PlayerName]["Kick Reason"] = {}
    	end
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kick Reason"]["value"] == nil) then
      GuildWho_Kicked[realm][guild][PlayerName]["Kick Reason"]["value"] = {}
    	end
      if (GuildWho_Kicked[realm][guild][PlayerName]) then
      	print("|cffffcc00GuildWho", gwhobuild," Player Name:", PlayerName,"is in the GuildWho_Kicked database.");
      	print("|cffffcc00GuildWho", gwhobuild," Player Name:", PlayerName,"Kick Reason: ", KickReason);
				GuildWho_Kicked[realm][guild][PlayerName]["Kick Reason"]["value"] = KickReason
				print("|cffffcc00GuildWho", gwhobuild,"Data stored. use /rl or logout/quit/camp to commit to disk.");
			else
				print("|cffffcc00GuildWho", gwhobuild," Player Name:", PlayerName,"is not in the GuildWho_Kicked database!");
			end
   elseif (strsub(Cmd,1,6) == "stats ")then
      gsPlayerName = strsub(Cmd,7,strlen(Cmd))
      --print("|cffffcc00'stats trigger!", gsPlayerName);
      GUILDWHO_CheckStats(gsPlayerName)
   elseif (strsub(Cmd,1,7) == "statsg ")then
      gsPlayerName = strsub(Cmd,8,strlen(Cmd))
      gsPlayerName = strupper(strsub(gsPlayerName,1,1)) .. strsub(gsPlayerName,2,strlen(gsPlayerName))
      --print("|cffffcc00'statsg trigger!", gsPlayerName);
      GUILDWHO_CheckStatsG(gsPlayerName)
   elseif (strsub(Cmd,1,7) == "statsp ")then
      gsPlayerName = strsub(Cmd,8,strlen(Cmd))
      gsPlayerName = strupper(strsub(gsPlayerName,1,1)) .. strsub(gsPlayerName,2,strlen(gsPlayerName))
      --print("|cffffcc00'statsg trigger!", gsPlayerName);
      statsp = true
      GUILDWHO_CheckStatsG(gsPlayerName)
      statsp = false
   elseif (strsub(Cmd,1,8) == "guildcmd")then
   		if (GuildWho_Settings == nil) then
			GuildWho_Settings = {}
			end
   		if (GuildWho_Settings["gtriggers"] == nil) then
			GuildWho_Settings["gtriggers"] = "Off"
			--print("guildcmd off, not exist");
			end
   		if (GuildWho_Settings["gtriggers"] == "Off") then
			GuildWho_Settings["gtriggers"] = "On"
							print("|cffffcc00GuildWho guildcmd on, toggle");
   		elseif (GuildWho_Settings["gtriggers"] == "On") then
			GuildWho_Settings["gtriggers"] = "Off"
							print("|cffffcc00GuildWho guildcmd off, toggle");
			end
   elseif (strsub(Cmd,1,9) == "setkickr ")then
   		if (GuildWho_Settings == nil) then
			GuildWho_Settings = {}
			end
   		if (GuildWho_Settings["defkickr"] == nil) then
			GuildWho_Settings["defkickr"] = ""
			end
			GuildWho_Settings["defkickr"] = strsub(Cmd,10,strlen(Cmd))
   		print("|cffffcc00GuildWho Default Kick Reason:", GuildWho_Settings["defkickr"]);
   elseif (strsub(Cmd,1,9) == "showkickr")then
   		if (GuildWho_Settings == nil) then
			GuildWho_Settings = {}
			end
   		if (GuildWho_Settings["defkickr"] == nil) then
			GuildWho_Settings["defkickr"] = ""
			end
   		print("|cffffcc00GuildWho Default Kick Reason:", GuildWho_Settings["defkickr"]);
   elseif (strsub(Cmd,1,8) == "usekickr")then
   		if (GuildWho_Settings == nil) then
			GuildWho_Settings = {}
			end
   		if (GuildWho_Settings["usekickr"] == nil) then
			GuildWho_Settings["usekickr"] = "Off"
			end
   		if (GuildWho_Settings["usekickr"] == "Off") then
			GuildWho_Settings["usekickr"] = "On"
							print("|cffffcc00GuildWho usekickr on, toggle");
   		elseif (GuildWho_Settings["usekickr"] == "On") then
			GuildWho_Settings["usekickr"] = "Off"
							print("|cffffcc00GuildWho usekickr off, toggle");
			end
   		print("|cffffcc00GuildWho Default Kick Reason:", GuildWho_Settings["defkickr"]);
   elseif (strsub(Cmd,1,7) == "showver")then
   		SendChatMessage("GuildWho " .. gwhobuild .. " GitHub: https://github.com/Veritas83/GuildWho","guild")
   else
   GUILDWHO_Lookup(Cmd);
   end
end

function GUILDWHO_OnEvent(event)
    if(event == "CHAT_MSG_SYSTEM") then
    	msgsys = true
    	if(string.find(arg1,"has joined the guild."))then
	    	GUILDWHO_Joined();
	    elseif(string.find(arg1,"has promoted"))then
	    	GUILDWHO_RankChange();
	    elseif(string.find(arg1,"has demoted"))then
	    	GUILDWHO_RankChange();
	    elseif(string.find(arg1,"has been kicked out of the guild by"))then
	    	GUILDWHO_RankChange();
		else
			--print("|cffffcc00GuildWho", gwhobuild,"Debug: (System Msg)", arg1);
		end
	end
	msgsys = false
    if(event == "CHAT_MSG_GUILD") then
		  local guild, realm = (GetGuildInfo("player")), GetRealmName()
    	msgguild = true
			--public cmd, testing v0.0.9
			if (strsub(arg1,1,6) == ".gwho ") then
	   		if (GuildWho_Settings == nil) then
				GuildWho_Settings = {}
				end
	   		if (GuildWho_Settings["gtriggers"] == nil) then
				GuildWho_Settings["gtriggers"] = "Off"
				end
	   		if (GuildWho_Settings["gtriggers"] == "On") then
					local guild, realm = (GetGuildInfo("player")), GetRealmName()
					msglocal = true
					msgguild = false
					local psPlayerName = strsub(arg1,7,strlen(arg1))
					psPlayerName = strupper(strsub(psPlayerName,1,1)) .. strlower(strsub(psPlayerName,2,strlen(psPlayerName)))
					--print("public cmd trigger! Target: ", psPlayerName);
					if (tContains(GuildWho_Saved,gsPlayerName) == 1 and (GuildWho_Stats[realm][guild][psPlayerName] == nil)) then
						SendChatMessage(psPlayerName .. " has not been a Guild Member.","guild")
					else
					GUILDWHO_CheckStatsG(psPlayerName);
					msglocal = false
					end
				end
			end
			GUILDWHO_InitTables(arg2)
      if (GuildWho_Stats[realm][guild][arg2]["Chat Lines"]["value"]) then
	      local gchatlines = GuildWho_Stats[realm][guild][arg2]["Chat Lines"]["value"];
				if (gchatlines == nil or type(gchatlines) == "table") then
					--print("gchatlines is nil or table")
					gchatlines = 0
				end
	      local gchatlines = gchatlines + 1
				GuildWho_Stats[realm][guild][arg2]["Chat Lines"]["value"] = gchatlines
      else
	      GuildWho_Stats[realm][guild][arg2]["Chat Lines"]["value"] = 0
				GuildWho_Stats[realm][guild][arg2]["Chat Lines"]["value"] = 1 -- New entry, 1 chat lines
				GuildWho_Stats[realm][guild][arg2]["Achievements"]["value"] = 0 -- New entry, 0 achievements
    	end
    	msgguild = false
    end
    if(event == "CHAT_MSG_GUILD_ACHIEVEMENT") then
    	msgguildach = true
			local gPlayerName = arg2
		  local guild, realm = (GetGuildInfo("player")), GetRealmName()
			GUILDWHO_InitTables(gPlayerName)
    	--print("|cffffcc00GuildWho", gwhobuild,"Debug: (Guild Ach)", arg2, gPlayerName);
      if (GuildWho_Stats[realm][guild][gPlayerName]["Achievements"]) then
	      --print("|cffffcc00GuildWho", gwhobuild,"Debug: (Guild Ach, Database Found): Player Name:", arg2, GuildWho_Stats[realm][guild][arg2]);      
	      local gachievements = GuildWho_Stats[realm][guild][gPlayerName]["Achievements"]["value"]
	      if (gachievements == nil or type(gachievements) == "table") then
	      	--print("gachievements is definately nil or a table")
	      	gachievements = 0
	      end
	      local gachievements = gachievements + 1
				GuildWho_Stats[realm][guild][gPlayerName]["Achievements"]["value"] = gachievements
      else
	      GuildWho_Stats[realm][guild][gPlayerName]["Achievements"]["value"] = 0
				GuildWho_Stats[realm][guild][gPlayerName]["Chat Lines"]["value"] = 0 -- New entry, 0 chat lines
				GuildWho_Stats[realm][guild][gPlayerName]["Achievements"]["value"] = 1 -- New entry, 1 achievements
    	end
    msgguildach = false
    end
    --testing v0.0.8
    if(event == "ACHIEVEMENT_EARNED") then
    	--print("ACHIEVEMENT_EARNED event fired!")
    	--arg1    The id of the achievement gained. 
    	msglocal = true
    	currPlayer = UnitName("player")
			local gPlayerName = currPlayer
		  local guild, realm = (GetGuildInfo("player")), GetRealmName()
			GUILDWHO_InitTables(gPlayerName)    
      if (GuildWho_Stats[realm][guild][gPlayerName]["Achievements"]) then
	      local gachievements = GuildWho_Stats[realm][guild][gPlayerName]["Achievements"]["value"]
	      if (gachievements == nil or type(gachievements) == "table") then
	      	--print("gachievements is definately nil or a table")
	      	gachievements = 0
	      end
	      local gachievements = gachievements + 1
				GuildWho_Stats[realm][guild][gPlayerName]["Achievements"]["value"] = gachievements
      else
	      GuildWho_Stats[realm][guild][gPlayerName]["Achievements"]["value"] = 0
				GuildWho_Stats[realm][guild][gPlayerName]["Chat Lines"]["value"] = 0 -- New entry, 0 chat lines
				GuildWho_Stats[realm][guild][gPlayerName]["Achievements"]["value"] = 1 -- New entry, 1 achievements
    	end
    msglocal = false
  end
  if(event == "UNIT_LEVEL") then
    --print("UNIT_LEVEL event fired! Target:", arg1)
  end
end

function GUILDWHO_Joined()
   if(string.find(arg1,"has joined the guild.")) then
		--print(strsub(arg1,1,strlen(arg1)-22),date("%m/%d/%y"),date("%m/%d/%y"))
		derp = (strsub(arg1,1,strlen(arg1)-22))
		if (tContains(GuildWho_Saved,derp) == 1) then
			print("|cffffcc00GuildWho", gwhobuild," ", derp, " is already in the database.")
		else
		GUILDWHO_InitTables(derp)
		GuildRoster()
		GetNumGuildMembers()
		GetNumGuildMembers(true)
		local JIndex = table.getn(GuildWho_Saved)
		tinsert(GuildWho_Saved,JIndex,derp)             -- character name
		tinsert(GuildWho_Saved,JIndex + 1,date("%m/%d/%y")) -- join date
		tinsert(GuildWho_Saved,JIndex + 2,date("%m/%d/%y")) -- rank change date		
		end
		local guild, realm = (GetGuildInfo("player")), GetRealmName()
		if (GetGuildRosterShowOffline() == 1)then
		   SetGuildRosterShowOffline(nil)
		end
		--print("DEBUG (join):" .. derp)
		temp = GUILDWHO_JoinL(derp)
		temp = GUILDWHO_Lookup(derp)
		temp = GUILDWHO_CheckStats(derp)
	end
end

function GUILDWHO_JoinL(PlayerName)
temp = GuildRoster()
temp = GetNumGuildMembers()
temp = GetNumGuildMembers(true)
for gwn = 1,GetNumGuildMembers(true) do
	 local guild, realm = (GetGuildInfo("player")), GetRealmName()
   local gwnPlayer,rank,rankindex,playerlevel,playerclass = GetGuildRosterInfo(gwn)  
   if (PlayerName == gwnPlayer)then
      --print("Found at: " .. gwn .. " ".. gwnPlayer .. " " .. playerlevel, GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"])
      GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] = playerlevel
   end
end
end

function GUILDWHO_InitTables(PlayerName)
temp = GuildRoster()
local guild, realm = (GetGuildInfo("player")), GetRealmName()
--print("DEBUG: (init tables)" .. PlayerName)
	if (GuildWho_Stats[realm] == nil) then
	GuildWho_Stats[realm] = {}
	end
	if (GuildWho_Stats[realm][guild] == nil) then
	GuildWho_Stats[realm][guild] = {}
	end
	if(GuildWho_Stats[realm][guild][PlayerName] == nil) then
	GuildWho_Stats[realm][guild][PlayerName] = {}
	end
	if(GuildWho_Stats[realm][guild][PlayerName]["Chat Lines"] == nil) then
	GuildWho_Stats[realm][guild][PlayerName]["Chat Lines"] = {}
	end
	if(GuildWho_Stats[realm][guild][PlayerName]["Achievements"] == nil) then
	GuildWho_Stats[realm][guild][PlayerName]["Achievements"] = {}
	end
	if(GuildWho_Stats[realm][guild][PlayerName]["Join Level"] == nil) then
	GuildWho_Stats[realm][guild][PlayerName]["Join Level"] = {}
		temp = GuildRoster()
		temp = GetNumGuildMembers()
		temp = GetNumGuildMembers(true)
		for gwn = 1,GetNumGuildMembers(true) do
			 local guild, realm = (GetGuildInfo("player")), GetRealmName()
		   local gwnPlayer,rank,rankindex,playerlevel,playerclass = GetGuildRosterInfo(gwn)  
		   if (PlayerName == gwnPlayer)then
		      --print("Found at: " .. gwn .. " ".. gwnPlayer .. " " .. playerlevel, GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"])
		      GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] = playerlevel
		   end
		end	
	end
  if (GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] == nil) then
		temp = GuildRoster()
		temp = GetNumGuildMembers()
		temp = GetNumGuildMembers(true)
		for gwn = 1,GetNumGuildMembers(true) do
			 local guild, realm = (GetGuildInfo("player")), GetRealmName()
		   local gwnPlayer,rank,rankindex,playerlevel,playerclass = GetGuildRosterInfo(gwn)  
		   if (PlayerName == gwnPlayer)then
		      --print("Found at: " .. gwn .. " ".. gwnPlayer .. " " .. playerlevel, GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"])
		      GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] = playerlevel
		   end
		end
     GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] = playerlevel
  end
  if (type(GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"]) == "table") then
		temp = GuildRoster()
		temp = GetNumGuildMembers()
		temp = GetNumGuildMembers(true)
		for gwn = 1,GetNumGuildMembers(true) do
			 local guild, realm = (GetGuildInfo("player")), GetRealmName()
		   local gwnPlayer,rank,rankindex,playerlevel,playerclass = GetGuildRosterInfo(gwn)  
		   if (PlayerName == gwnPlayer)then
		      --print("Found at: " .. gwn .. " ".. gwnPlayer .. " " .. playerlevel, GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"])
		      GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] = playerlevel
		   end
		end
     GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] = playerlevel
  end	
	if(GuildWho_Stats[realm][guild][PlayerName]["Chat Lines"]["value"] == nil) then
	GuildWho_Stats[realm][guild][PlayerName]["Chat Lines"]["value"] = {}
	end
	if(GuildWho_Stats[realm][guild][PlayerName]["Achievements"]["value"] == nil)then
	GuildWho_Stats[realm][guild][PlayerName]["Achievements"]["value"] = {}
	end
	if(GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] == nil) then
	GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] = {}
	end			
end

function GUILDWHO_Lookup(PlayerName)
	--print("GuildWho", gwhobuild,"Debug: Lookup fired!");
	local guild, realm = (GetGuildInfo("player")), GetRealmName()
	msglocal = true
	PlayerName = strupper(strsub(PlayerName,1,1)) .. strsub(PlayerName,2,strlen(PlayerName))
	if (tContains(GuildWho_Saved,PlayerName) == 1) then
		JDIndex = localindex + 1
		RDIndex = localindex + 2
		print("|cffffcc00GuildWho", gwhobuild);
		print("|cffffcc00Guild Member:  ", PlayerName);
		print("|cffffcc00Joined:              ", GuildWho_Saved[JDIndex]);
		print("|cffffcc00Rank Changed: ", GuildWho_Saved[RDIndex]);
	else
		print("|cffffcc00GuildWho", gwhobuild," ", PlayerName, " is not in the GuildWho_Saved database.");
	end
	if(GuildWho_Stats[realm][guild][PlayerName] == nil)then
		GuildWho_Stats[realm][guild][PlayerName] = {}
	end
	if(GuildWho_Stats[realm][guild][PlayerName]["Join Level"] == nil)then
		GuildWho_Stats[realm][guild][PlayerName]["Join Level"] = {}
	end
	if(GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] == nil)then
		GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"] = {}
	else
		print("|cffffcc00Join Level: ",GuildWho_Stats[realm][guild][PlayerName]["Join Level"]["value"])
	end
	--Testing v0.1.2
	for n = 0,GetNumGuildMembers(true) do
	   local guild, realm = (GetGuildInfo("player")), GetRealmName()
	   local currPlayer,rank,rankindex,playerlevel,playerclass = GetGuildRosterInfo(n)
	   if (currPlayer == PlayerName)then
	      GUILDWHO_InitTables(PlayerName)
	      --print("Found at: " .. n .. " ".. PlayerName .. " " ..playerlevel)
	      print("|cffffcc00Rank: " .. rank)
	   end
	end	
	--print("|cffffcc00GuildWho", gwhobuild,"Debug: GuildWho_Kicked checking...");
	if (GuildWho_Kicked[realm][guild][PlayerName]) then
	--print("|cffffcc00GuildWho", gwhobuild,"Debug: GuildWho_Kicked[index-1] = ", GuildWho_Kicked[localindex - 1])
   	--Kick Reason added later, need to init tables.
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kick Reason"] == nil) then
      	GuildWho_Kicked[realm][guild][PlayerName]["Kick Reason"] = {}
    	end
			if(GuildWho_Kicked[realm][guild][PlayerName]["Kick Reason"]["value"] == nil) then
      	GuildWho_Kicked[realm][guild][PlayerName]["Kick Reason"]["value"] = {}
    	end
    --Kick Reason added later, need to init tables.
   	if (GuildWho_Kicked[realm][guild][PlayerName]["Kick Reason"]["value"])then
   		print("|cffff0000Kicked by", GuildWho_Kicked[realm][guild][PlayerName]["Kicked By"]["value"],"on",GuildWho_Kicked[realm][guild][PlayerName]["Kick Date"]["value"],"Kick Reason:",GuildWho_Kicked[realm][guild][PlayerName]["Kick Reason"]["value"]);
   	else
   		print("|cffff0000Kicked by", GuildWho_Kicked[realm][guild][PlayerName]["Kicked By"]["value"],"on",GuildWho_Kicked[realm][guild][PlayerName]["Kick Date"]["value"]);
   	end
	end
	msglocal = false
end

function GUILDWHO_RankChange()
  local guild, realm = (GetGuildInfo("player")), GetRealmName()
	msgsys = true		
	if(string.find(arg1," has promoted ")) then
   sp,ep = string.find(arg1," has promoted ");
   if(string.find(arg1," to ")) then
      st,et = string.find(arg1," to ");
      gPlayerName = strsub(arg1,sp+14,st-1);
   end
	end
		-- arg1="Datmage has demoted Rodd to Senior Member.";
	if(string.find(arg1," has demoted ")) then
   sp,ep = string.find(arg1," has demoted ");
   if(string.find(arg1," to ")) then
      st,et = string.find(arg1," to ");
      gPlayerName = strsub(arg1,sp+13,st-1);
   end
	end

	if(string.find(arg1," has been kicked out of the guild by "))then
	   local sp,ep = string.find(arg1," has been kicked out of the guild by ");
	   gPlayerName = strsub(arg1,1,sp - 1)
	   gKickedBy   = strsub(strsub(arg1,ep,strlen(arg1)),2,strlen(strsub(arg1,ep,strlen(arg1)))-1)
			if (GuildWho_Kicked[realm] == nil) then
			GuildWho_Kicked[realm] = {}
			end
			if (GuildWho_Kicked[realm][guild] == nil) then
			GuildWho_Kicked[realm][guild] = {}
			end
			if(GuildWho_Kicked[realm][guild][gPlayerName] == nil) then
			GuildWho_Kicked[realm][guild][gPlayerName] = {}
			end
			if(GuildWho_Kicked[realm][guild][gPlayerName]["Kick Date"] == nil) then
			GuildWho_Kicked[realm][guild][gPlayerName]["Kick Date"] = {}
			end
			if(GuildWho_Kicked[realm][guild][gPlayerName]["Kicked By"] == nil) then
			GuildWho_Kicked[realm][guild][gPlayerName]["Kicked By"] = {}
			end
			if(GuildWho_Kicked[realm][guild][gPlayerName]["Kick Date"]["value"] == nil) then
			GuildWho_Kicked[realm][guild][gPlayerName]["Kick Date"]["value"] = {}
			end
			if(GuildWho_Kicked[realm][guild][gPlayerName]["Kicked By"]["value"] == nil) then
			GuildWho_Kicked[realm][guild][gPlayerName]["Kicked By"]["value"] = {}
			end
   		if (GuildWho_Settings == nil) then
			GuildWho_Settings = {}
			end
   		if (GuildWho_Settings["usekickr"] == nil) then
			GuildWho_Settings["usekickr"] = "Off"			
			end
   		if(GuildWho_Kicked[realm][guild][gPlayerName]["Kick Reason"] == nil) then
      GuildWho_Kicked[realm][guild][gPlayerName]["Kick Reason"] = {}
    	end
			if(GuildWho_Kicked[realm][guild][gPlayerName]["Kick Reason"]["value"] == nil) then
      GuildWho_Kicked[realm][guild][gPlayerName]["Kick Reason"]["value"] = {}
    	end	   		
    	
   		if (GuildWho_Settings["usekickr"] == "On") then    	
   			GuildWho_Kicked[realm][guild][gPlayerName]["Kick Reason"]["value"] = GuildWho_Settings["defkickr"]
   		end
   		
		 if (GuildWho_Kicked[realm][guild][gPlayerName]) then
			 print("|cffffcc00GuildWho", gwhobuild,": ", gPlayerName, " is not in the GuildWho_Kicked database. Adding new entry");
			 GuildWho_Kicked[realm][guild][gPlayerName]["Kick Date"]["value"] = date("%m/%d/%y")
			 GuildWho_Kicked[realm][guild][gPlayerName]["Kicked By"]["value"] = gKickedBy
			 print("|cffffcc00GuildWho", gwhobuild,": ", gPlayerName, " added to the GuildWho_Kicked database!");
		 end
	end
	
	if (tContains(GuildWho_Saved,gPlayerName) == 1) then
		JDIndex = sysindex + 1
		RDIndex = sysindex + 2
		tinsert(GuildWho_Saved,RDIndex,date("%m/%d/%y"))
	else
		print("|cffffcc00GuildWho", gwhobuild,": ", gPlayerName, " is not in the database. Adding new entry");
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),gPlayerName)             -- character name
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),date("%m/%d/%y")) -- join date
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),date("%m/%d/%y")) -- rank change date		
	end
	msgsys = false
end

function GUILDWHO_CheckStats(gsPlayerName)
	temp = GuildRoster()
	temp = GetNumGuildMembers()
	temp = GetNumGuildMembers(true)
	local guild, realm = (GetGuildInfo("player")), GetRealmName()
	--print("GuildWho", gwhobuild,"Debug: Lookup fired!");
	msglocal = true
	gsPlayerName = strupper(strsub(gsPlayerName,1,1)) .. strsub(gsPlayerName,2,strlen(gsPlayerName))
	if(GuildWho_Stats[realm][guild][gsPlayerName] == nil) then
		print("|cffffcc00GuildWho", gwhobuild," ", gsPlayerName,"is not in the GuildWho_Stats Database.");
	else		
		print("|cffffcc00GuildWho", gwhobuild);
		print("|cffffcc00Guild Member:  ", gsPlayerName);
		GUILDWHO_InitTables(gsPlayerName)
		if(type(GuildWho_Stats[realm][guild][gsPlayerName]["Chat Lines"]["value"]) == "table") then
			print("|cffffcc00Chat Lines:              0");
		else
			print("|cffffcc00Chat Lines:              ", GuildWho_Stats[realm][guild][gsPlayerName]["Chat Lines"]["value"]);
		end
		if(type(GuildWho_Stats[realm][guild][gsPlayerName]["Achievements"]["value"]) == "table") then
		print("|cffffcc00Achievements: 0");
		else
		print("|cffffcc00Achievements: ", GuildWho_Stats[realm][guild][gsPlayerName]["Achievements"]["value"]);
		end	
	end
		--Testing v0.1.2
		for n = 0,GetNumGuildMembers(true) do
		   local guild, realm = (GetGuildInfo("player")), GetRealmName()
		   local currPlayer,rank,rankindex,playerlevel,playerclass = GetGuildRosterInfo(n)
		   if (currPlayer == gsPlayerName)then
		      GUILDWHO_InitTables(gsPlayerName)
		      --print("Found at: " .. n .. " ".. gsPlayerName .. " " ..playerlevel)
		      if (GuildWho_Stats[realm][guild][gsPlayerName] == nil) then
		         GuildWho_Stats[realm][guild][gsPlayerName] = {}
		      end
		      if (GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"] == nil) then
		         GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"] = {}
		      end
		      if (GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"] == nil) then
		         GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"] = playerlevel
		      end
		      if (type(GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"]) == "table") then
		         GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"] = playerlevel
		      end
		      if (tonumber(playerlevel) > tonumber(GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"]))then
		         print("|cffffcc00Levels Gained: " .. (tonumber(playerlevel) - tonumber(GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"])))
		      end
		   end
		end
	--print("|cffffcc00GuildWho", gwhobuild,"Debug: GuildWho_Kicked checking...");
	if (tContains(GuildWho_Kicked,gsPlayerName) == 1) then
	--print("|cffffcc00GuildWho", gwhobuild,"Debug: GuildWho_Kicked[index-1] = ", GuildWho_Kicked[localindex - 1])
   if (string.find(GuildWho_Kicked[localindex - 1],"/"))then
   	local d=d; -- do something that is not nothing, but has no purpose :)
   else
   	print("|cffff0000Kicked by", GuildWho_Kicked[localindex + 2],"on",GuildWho_Kicked[localindex + 1]);
	 end
	end
	msglocal = false
end

function GUILDWHO_CheckStatsG(gsPlayerName)
   local guild, realm = (GetGuildInfo("player")), GetRealmName()
   --print("GuildWho", gwhobuild,"Debug: Lookup fired!");
   msglocal = true
   gmsg = ""
   gsPlayerName = strupper(strsub(gsPlayerName,1,1)) .. strsub(gsPlayerName,2,strlen(gsPlayerName))
   if(GuildWho_Stats[realm][guild][gsPlayerName] == nil) then
      print("|cffffcc00GuildWho", gwhobuild," ", gsPlayerName,"is not in the GuildWho_Stats Database.");
      gmsg = "GuildWho " .. gwhobuild .. " Guild Member: " .. gsPlayerName
   else        
      gmsg = "GuildWho " .. gwhobuild .. " Guild Member: " .. gsPlayerName
      if(type(GuildWho_Stats[realm][guild][gsPlayerName]["Chat Lines"]["value"]) == "table") then
         gmsg = gmsg .." Chat Lines: 0 "
      else
         gmsg = gmsg .. " Chat Lines: " .. GuildWho_Stats[realm][guild][gsPlayerName]["Chat Lines"]["value"]
      end
      if(type(GuildWho_Stats[realm][guild][gsPlayerName]["Achievements"]["value"]) == "table") then
         gmsg = gmsg .. " Achievements: 0 "
      else
         gmsg = gmsg .." Achievements: " .. GuildWho_Stats[realm][guild][gsPlayerName]["Achievements"]["value"]
      end
   end
		--Testing v0.1.2
		for n = 1,GetNumGuildMembers() do
		   local guild, realm = (GetGuildInfo("player")), GetRealmName()
		   local currPlayer,rank,rankindex,playerlevel,playerclass = GetGuildRosterInfo(n)
		   if (currPlayer == gsPlayerName)then
		      --print("Found at: " .. n .. " ".. gsPlayerName .. " " ..playerlevel)
		      if (GuildWho_Stats[realm][guild][gsPlayerName] == nil) then
		         GuildWho_Stats[realm][guild][gsPlayerName] = {}
		      end
		      if (GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"] == nil) then
		         GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"] = playerlevel
		      end
		      if (type(GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"]) == "table") then
		         GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"] = playerlevel
		      end
		      if (tonumber(playerlevel) > tonumber(GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"]))then
		         gmsg = gmsg .. " Levels Gained: " .. (tonumber(playerlevel) - tonumber(GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"]))
		      end
		   gmsg = gmsg .. " Rank: " .. rank
		   end
end    
--print(gmsg)	
	temp = GUILDWHO_InitTables(gsPlayerName)
	if(GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"])then
		if (type(GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"]) ~= "table")then
			gmsg = gmsg .. " Join Level: " .. GuildWho_Stats[realm][guild][gsPlayerName]["Join Level"]["value"]
		end
	end   
		if (tContains(GuildWho_Saved,gsPlayerName) == 1) then
			JDIndex = localindex + 1
			RDIndex = localindex + 2
			gmsg = gmsg .. " Join Date: " .. GuildWho_Saved[JDIndex] .. " Rank Changed: " .. GuildWho_Saved[RDIndex]
		else
			print("|cffffcc00GuildWho", gwhobuild," ", PlayerName, " is not in the GuildWho_Saved database.");
		end
   --print("|cffffcc00GuildWho", gwhobuild,"Debug: GuildWho_Kicked checking...");
   if (GuildWho_Kicked[realm][guild][gsPlayerName]) then
      --print("|cffffcc00GuildWho", gwhobuild,"Debug: GuildWho_Kicked[index-1] = " .. GuildWho_Kicked[localindex - 1])
         if (GuildWho_Kicked[realm][guild][gsPlayerName]["Kick Reason"]["value"])then
         	gmsg = gmsg .. " Kicked by " .. GuildWho_Kicked[realm][guild][gsPlayerName]["Kicked By"]["value"] .. " on " .. GuildWho_Kicked[realm][guild][gsPlayerName]["Kick Date"]["value"] .. " Kick Reason: " .. GuildWho_Kicked[realm][guild][gsPlayerName]["Kick Reason"]["value"]
         else
         	gmsg = gmsg .. " Kicked by " .. GuildWho_Kicked[realm][guild][gsPlayerName]["Kicked By"]["value"] .. " on " .. GuildWho_Kicked[realm][guild][gsPlayerName]["Kick Date"]["value"]
       	 end
   end
   --print("|cffffcc00GuildWho", gwhobuild,"Debug:",gmsg)
   if (statsp == true) then
   	gmsg = gmsg .. " Guild: <" .. guild .."> "
   	SendChatMessage(gmsg,"party")
   	msglocal = false
   	statsp = false
   else
   	SendChatMessage(gmsg,"guild")
   	msglocal = false
   end
end