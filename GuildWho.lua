GuildWho_Saved = {}

function GUILDWHO_OnLoad()
	 gwhobuild = "v0.0.3";
   if IsInGuild() then
      local guild, realm = (GetGuildInfo("player")), GetRealmName()
      --if GuildWho_Saved[realm] 
      --and GuildWho_Saved[realm][guild]
      this:RegisterEvent("CHAT_MSG_SYSTEM")
      --slash commands
      SlashCmdList["GWHO"] = GUILDWHO_Command;
      SLASH_GWHO1 = "/guildwho";
      SLASH_GWHO2 = "/gwho";
      print("GuildWho", gwhobuild,"loaded!");
   else
      print("You are not in a Guild. GuildWho not loaded.");
   end
end

local function tContains(table, item)
       local index = 1;
       while table[index] do
               if ( item == table[index] ) then
                       derp2 = index
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
print("GuildWho", gwhobuild,"usage:");
print("'/guildwho {guild_member}' or '/gwho {guild_member}'");
print("'/guildwho m {guild_member} mm/dd/yy mm/dd/yy' or '/gwho m {guild_member} mm/dd/yy mm/dd/yy'");
end

function GUILDWHO_Command(msg)
   local Cmd, SubCmd = GUILDWHO_GetCmd(msg);
   local guild, realm = (GetGuildInfo("player")), GetRealmName()
   if (Cmd == "")then
      GUILDWHO_ShowHelp();
   elseif (strsub(Cmd,1,2) == "m ")then
      print("'(m)anual trigger!");
      local n=0;
      for token in string.gmatch(Cmd, "[^%s]+") do
         -- print(token)
         n=n+1;
         if (n == 2)then
            PlayerName = token;
         elseif (n == 3)then
            JoinDate = token;
         elseif (n == 4)then
            RankDate = token;
         end
      end
      if (tContains(GuildWho_Saved,PlayerName) == 1) then
      print("GuildWho", gwhobuild," Player Name:", PlayerName,"is already in the database.");
      else
      print("GuildWho", gwhobuild," Player Name:", PlayerName,"Join Date: ", JoinDate, "Rank Changed: ", RankDate);
			tinsert(GuildWho_Saved,getn(GuildWho_Saved),PlayerName) -- character name
			tinsert(GuildWho_Saved,getn(GuildWho_Saved),JoinDate)   -- join date
			tinsert(GuildWho_Saved,getn(GuildWho_Saved),RankDate)   -- rank change date      
			print("GuildWho", gwhobuild,"Data stored. use /rl or logout/quit/camp to commit to disk.");
			end
   else
   GUILDWHO_Lookup(Cmd);
   end
end

function GUILDWHO_OnEvent(event)
    if(event == "CHAT_MSG_SYSTEM") then
    	if(string.find(arg1,"has joined the guild."))then
	    	GUILDWHO_Joined();
	    elseif(string.find(arg1,"has promoted"))then
	    	GUILDWHO_RankChange();
	    elseif(string.find(arg1,"has demoted"))then
	    	GUILDWHO_RankChange();
			end
		end
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
	if (tContains(GuildWho_Saved,PlayerName) == 1) then
		JDIndex = derp2+1
		RDIndex = derp2+2
		print("GuildWho", gwhobuild," Guild Member: ", PlayerName, "Joined: ", GuildWho_Saved[JDIndex], "Rank Changed: ", GuildWho_Saved[RDIndex]);
	else
		print("GuildWho", gwhobuild," ", PlayerName, " is not in the database.");
	end
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
		
	if (tContains(GuildWho_Saved,gPlayerName) == 1) then
		JDIndex = derp2+1
		RDIndex = derp2+2
		tinsert(GuildWho_Saved,RDIndex,date("%m/%d/%y"))
	else
		print("GuildWho", gwhobuild,": ", gPlayerName, " is not in the database. Adding new entry");
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),gPlayerName)             -- character name
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),date("%m/%d/%y")) -- join date
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),date("%m/%d/%y")) -- rank change date		
	end
end