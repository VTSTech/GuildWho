GuildWho_Saved = {}
GuildWho_Stats = {}

function GUILDWHO_OnLoad()
	 gwhobuild = "v0.0.4";
	 -- Doesnt detect in a guild in a timely fashion... Disabled.
   --if IsInGuild() then
      --local guild, realm = (GetGuildInfo("player")), GetRealmName()
      this:RegisterEvent("CHAT_MSG_SYSTEM")
			--arg1    The content of the chat message.
      --this:RegisterEvent("CHAT_MSG_GUILD")
			--arg1    Message that was sent 
			--arg2    Author 
			--arg3    Language that the message was sent in 
			--arg11   Chat lineID 
			--arg12   Sender GUID       
			--this:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
			--arg1    The full body of the achievement broadcast message. 
			--arg2, arg5    Guildmember Name 
			--arg11    Chat lineID 
			--arg12    Sender GUID 			
      --slash commands
      SlashCmdList["GWHO"] = GUILDWHO_Command;
      SLASH_GWHO1 = "/guildwho";
      SLASH_GWHO2 = "/gwho";
      print("|cffffcc00GuildWho", gwhobuild,"loaded!");
   --else
   --   print("|cffffcc00You are not in a Guild. GuildWho not loaded.");
   --end
end

local function tContains(table, item)
       local index = 1;
       while table[index] do
               if ( item == table[index] ) then
                       if (msgsys == true) then
                       	sysindex = index;
                       	-- print("|cffffcc00GuildWho", gwhobuild,"Debug: System Index Updated,", sysindex);
                       elseif (msgguild == true) then
                       	guildindex = index;
                       	-- print("|cffffcc00GuildWho", gwhobuild,"Debug: Guild Index Updated,", guildindex);
                       elseif (msgguildach == true) then
                       	guildachindex = index;
                       	-- print("|cffffcc00GuildWho", gwhobuild,"Debug: GuildAch Index Updated,", guildachindex);
                       elseif (msglocal == true) then
                       	localindex = index;
                       	-- print("|cffffcc00GuildWho", gwhobuild,"Debug: Local Index Updated,", localindex);
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
print("|cffffcc00'/guildwho {guild_member}' or '/gwho {guild_member}'");
-- print("|cffffcc00'/guildwho stats' or '/gwho stats'");
-- print("|cffffcc00'/guildwho stats {guild_member}' or '/gwho stats {guild_member}'");
print("|cffffcc00Manual Database submission:");
print("|cffffcc00'/guildwho m {guild_member} mm/dd/yy mm/dd/yy' or '/gwho m {guild_member} mm/dd/yy mm/dd/yy'");

end

function GUILDWHO_Command(msg)
   local Cmd, SubCmd = GUILDWHO_GetCmd(msg);
   local guild, realm = (GetGuildInfo("player")), GetRealmName()
   if (Cmd == "")then
      GUILDWHO_ShowHelp();
   elseif (strsub(Cmd,1,2) == "m ")then
      print("|cffffcc00'(m)anual trigger!");
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
			end
		end
		msgsys = false
-- This doesnt work right now. 
--    if(event == "CHAT_MSG_GUILD") then
--    	msgguild = true
--    	print("|cffffcc00GuildWho", gwhobuild,"Debug: (before parse)", arg2, msgguild);
--      if (tContains(GuildWho_Stats,arg2) == 1) then
--	     print("|cffffcc00GuildWho", gwhobuild,"Debug: Player Name:", arg2,"Index:", guildindex);
--	      local GCIndex = guildindex;     -- Character index
--				local GLIndex = GCIndex + 1; -- GChat lines
--				local GAIndex = GCIndex + 2; -- Achievements seen
--	      local gchatlines = 0;
--	      local gchatlines = GuildWho_Stats[GLIndex];
--	      local gchatlines = gchatlines + 1;
--				tinsert(GuildWho_Stats,GLIndex,gchatlines);
--				print("|cffffcc00GuildWho", gwhobuild,"Debug: (just after gchatline increment)", arg2,"Index:",GLIndex,"Chat Lines:",gchatlines);
--	      print("|cffffcc00GuildWho", gwhobuild,"Debug: Guild Member: ", arg2, "Chat lines: ", GuildWho_Stats[GLIndex], "Achievements seen: ", GuildWho_Stats[GAIndex]);
--      else
--	      --print("|cffffcc00GuildWho", gwhobuild,"Debug :", arg2,"Index (top of):",getn(GuildWho_Stats));
--				if (getn(GuildWho_Stats) == nil) then GCIndex = 0;
--				end
--				local GCIndex = getn(GuildWho_Stats); -- Character added at end of table
--				local GLIndex = GCIndex + 1; -- GChat lines
--				local GAIndex = GCIndex + 2; -- Achievements seen
--				tinsert(GuildWho_Stats,GCIndex,arg2); -- character name
--				print("|cffffcc00GuildWho", gwhobuild,"Debug (no previous) :", arg2,"Index (top of):",GCIndex);
--					if (tContains(GuildWho_Stats,arg2) == 1) then
--			      local GCIndex = guildindex;     -- Character index
--						local GLIndex = GCIndex + 1; -- GChat lines
--						local GAIndex = GCIndex + 2; -- Achievements seen
--						print("|cffffcc00GuildWho", gwhobuild,"Debug (GCIndex updated after insert):", arg2,"Index:",GCIndex);
--					end
--				tinsert(GuildWho_Stats,GLIndex,1);   -- chat lines
--				print("|cffffcc00GuildWho", gwhobuild,"Debug :", arg2,"Index:",GLIndex);
--				tinsert(GuildWho_Stats,GAIndex,0);   -- achievements seen
--				print("|cffffcc00GuildWho", gwhobuild,"Debug :", arg2,"Index:",GAIndex);
--				--print("|cffffcc00GuildWho", gwhobuild,"Data stored. use /rl or logout/quit/camp to commit to disk.");    	
--    	end
--    	msgguild = false
--    end
-- This doesnt work right now. 
--    if(event == "CHAT_MSG_GUILD_ACHIEVEMENT") then
--    	msgguildach = true
--    	print("|cffffcc00GuildWho", gwhobuild,"Debug: ", arg2, msgguildach);
--      if (tContains(GuildWho_Stats,arg2) == 1) then
--	      print("|cffffcc00GuildWho", gwhobuild,"Debug: Player Name:", arg2,"Index:", guildachindex);
--	      local GCIndex = guildachindex     -- Character index
--				local GLIndex = GCIndex + 1 -- GChat lines
--				local GAIndex = GCIndex + 2 -- Achievements seen
--	      local gachievements = 0;
--	      local gachievements = GuildWho_Stats[GAIndex]
--	      local gachievements = gachievements + 1;
--				tinsert(GuildWho_Stats,GAIndex,gachievements)
--	      print("|cffffcc00GuildWho", gwhobuild,"Debug :", arg2,"Index:",GAIndex,"Value:", gachievements);
--	      print("|cffffcc00GuildWho", gwhobuild,"Debug: Guild Member: ", arg2, "Chat lines: ", GuildWho_Stats[GLIndex], "Achievements seen: ", GuildWho_Stats[GAIndex]);
--      else
--	      --print("|cffffcc00GuildWho", gwhobuild,"Debug :", arg2);
--				local GCIndex = getn(GuildWho_Stats); -- Character added at end of table
--				local GLIndex = GCIndex + 1 -- GChat lines
--				local GAIndex = GCIndex + 2 -- Achievements seen
--				tinsert(GuildWho_Stats,GCIndex,arg2) -- character name
--					if (tContains(GuildWho_Stats,arg2) == 1) then
--			      local GCIndex = guildindex;     -- Character index
--						local GLIndex = GCIndex + 1; -- GChat lines
--						local GAIndex = GCIndex + 2; -- Achievements seen
--					end
--				tinsert(GuildWho_Stats,GLIndex,0)   -- chat lines
--				tinsert(GuildWho_Stats,GAIndex,1)   -- achievements seen
--				--print("|cffffcc00GuildWho", gwhobuild,"Data stored. use /rl or logout/quit/camp to commit to disk.");    	
--    	end
--    msgguildach = false
--    end    
-- This doesnt work right now. 
end

function GUILDWHO_Joined()
   if(string.find(arg1,"has joined the guild.")) then
		--print(strsub(arg1,1,strlen(arg1)-22),date("%m/%d/%y"),date("%m/%d/%y"));
		derp = (strsub(arg1,1,strlen(arg1)-22));
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),derp)             -- character name
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),date("%m/%d/%y")) -- join date
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),date("%m/%d/%y")) -- rank change date
	end
end

function GUILDWHO_Lookup(PlayerName)
	--print("GuildWho", gwhobuild,"Debug: Lookup fired!");
	msglocal = true
	if (tContains(GuildWho_Saved,PlayerName) == 1) then
		JDIndex = localindex + 1
		RDIndex = localindex + 2
		print("|cffffcc00GuildWho", gwhobuild," Guild Member: ", PlayerName, "Joined: ", GuildWho_Saved[JDIndex], "Rank Changed: ", GuildWho_Saved[RDIndex]);
	else
		print("|cffffcc00GuildWho", gwhobuild," ", PlayerName, " is not in the database.");
	end
	msglocal = false
end

function GUILDWHO_RankChange()
		-- arg1="Datmage has promoted Rodd to Senior Member.";
	if(string.find(arg1," has promoted ")) then
   --print (string.find(arg1,"has promoted"));
   --local sp,ep;
   sp,ep = (string.find(arg1," has promoted "));
   if(string.find(arg1," to ")) then
      -- print(string.find(arg1," to "));
      --local st,et;
      st,et = (string.find(arg1," to "));
      --print("String Length:",strlen(arg1));
      --local gPlayerName;
      gPlayerName = strsub(arg1,sp+14,st-1);
   end
end
		-- arg1="Datmage has demoted Rodd to Senior Member.";
	if(string.find(arg1," has demoted ")) then
   --print (string.find(arg1,"has demoted"));
   --local sp,ep;
   sp,ep = (string.find(arg1," has demoted "));
   if(string.find(arg1," to ")) then
      -- print(string.find(arg1," to "));
      --local st,et;
      st,et = (string.find(arg1," to "));
      --print("String Length:",strlen(arg1));
      --local gPlayerName;
      gPlayerName = strsub(arg1,sp+13,st-1);
   end
end
		msgsys = true
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