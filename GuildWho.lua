GuildWho_Saved = {}

function GUILDWHO_OnLoad()
    this:RegisterEvent("CHAT_MSG_SYSTEM")
    --slash commands
   SlashCmdList["GWHO"] = GUILDWHO_Command;
    SLASH_GWHO1 = "/guildwho";
    SLASH_GWHO2 = "/gwho";
end

function tContains(table, item)
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
print("GuildWho v0.0.1 usage:");
print("'/guildwho {guild_member}' or '/gwho {guild_member}'");
print("'/guildwho m {guild_member} mm/dd/yy mm/dd/yy' or '/gwho m {guild_member} mm/dd/yy mm/dd/yy'");
end

function GUILDWHO_Command(msg)
   local Cmd, SubCmd = GUILDWHO_GetCmd(msg);
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
      print("Player Name: ", PlayerName, "Join Date: ", JoinDate, "Rank Changed: ", RankDate);
			tinsert(GuildWho_Saved,getn(GuildWho_Saved),PlayerName)             -- character name
			tinsert(GuildWho_Saved,getn(GuildWho_Saved),JoinDate) -- join date
			tinsert(GuildWho_Saved,getn(GuildWho_Saved),RankDate) -- rank change date      
			print("Data stored. use /rl or logout/quit/camp to commit to disk.");
   end
end

function GUILDWHO_OnEvent(event)
    if(event == "CHAT_MSG_SYSTEM") then
    if(string.find(arg1,"has joined the guild.")) then GUILDWHO_Joined();
    if(string.find(arg1,"has promoted")) then GUILDWHO_RankChange();
    if(string.find(arg1,"has demoted")) then GUILDWHO_RankChange();
    end
    end
    end
    end
end

function GUILDWHO_Joined()
   if(string.find(arg1,"has joined the guild.")) then
		print(strsub(arg1,1,strlen(arg1)-22),date("%m/%d/%y"),date("%m/%d/%y"));
		derp = (strsub(arg1,1,strlen(arg1)-22));
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),derp)             -- character name
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),date("%m/%d/%y")) -- join date
		tinsert(GuildWho_Saved,getn(GuildWho_Saved),date("%m/%d/%y")) -- rank change date
	end
end

function GUILDWHO_Lookup()
	
end

function GUILDWHO_RankChange()

end