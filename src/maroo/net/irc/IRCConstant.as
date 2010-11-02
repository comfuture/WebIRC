package maroo.net.irc
{
	public class IRCConstant
	{		
		// Command Responses.
		public static const RPL_TRACELINK:String = "200";
		public static const RPL_TRACECONNECTING:String = "201";
		public static const RPL_TRACEHANDSHAKE:String = "202";
		public static const RPL_TRACEUNKNOWN:String = "203";
		public static const RPL_TRACEOPERATOR:String = "204";
		public static const RPL_TRACEUSER:String = "205";
		public static const RPL_TRACESERVER:String = "206";
		public static const RPL_TRACENEWTYPE:String = "208";
		public static const RPL_STATSLINKINFO:String = "211";
		public static const RPL_STATSCOMMANDS:String = "212";
		public static const RPL_STATSCLINE:String = "213";
		public static const RPL_STATSNLINE:String = "214";
		public static const RPL_STATSILINE:String = "215";
		public static const RPL_STATSKLINE:String = "216";
		public static const RPL_STATSYLINE:String = "218";
		public static const RPL_ENDOFSTATS:String = "219";
		public static const RPL_UMODEIS:String = "221";
		public static const RPL_STATSLLINE:String = "241";
		public static const RPL_STATSUPTIME:String = "242";
		public static const RPL_STATSOLINE:String = "243";
		public static const RPL_STATSHLINE:String = "244";
		public static const RPL_LUSERCLIENT:String = "251";
		public static const RPL_LUSEROP:String = "252";
		public static const RPL_LUSERUNKNOWN:String = "253";
		public static const RPL_LUSERCHANNELS:String = "254";
		public static const RPL_LUSERME:String = "255";
		public static const RPL_ADMINME:String = "256";
		public static const RPL_ADMINLOC1:String = "257";
		public static const RPL_ADMINLOC2:String = "258";
		public static const RPL_ADMINEMAIL:String = "259";
		public static const RPL_TRACELOG:String = "261";
		public static const RPL_NONE:String = "300";
		public static const RPL_AWAY:String = "301";
		public static const RPL_USERHOST:String = "302";
		public static const RPL_ISON:String = "303";
		public static const RPL_UNAWAY:String = "305";
		public static const RPL_NOWAWAY:String = "306";
		public static const RPL_WHOISUSER:String = "311";
		public static const RPL_WHOISSERVER:String = "312";
		public static const RPL_WHOISOPERATOR:String = "313";
		public static const RPL_WHOWASUSER:String = "314";
		public static const RPL_ENDOFWHO:String = "315";
		public static const RPL_WHOISIDLE:String = "317";
		public static const RPL_ENDOFWHOIS:String = "318";
		public static const RPL_WHOISCHANNELS:String = "319";
		public static const RPL_LISTSTART:String = "321";
		public static const RPL_LIST:String = "322";
		public static const RPL_LISTEND:String = "323";
		public static const RPL_CHANNELMODEIS:String = "324";
		public static const RPL_NOTOPIC:String = "331";
		public static const RPL_TOPIC:String = "332";
		public static const RPL_TOPICINFO:String = "333";
		public static const RPL_INVITING:String = "341";
		public static const RPL_SUMMONING:String = "342";
		public static const RPL_VERSION:String = "351";
		public static const RPL_WHOREPLY:String = "352";
		public static const RPL_NAMREPLY:String = "353";
		public static const RPL_LINKS:String = "364";
		public static const RPL_ENDOFLINKS:String = "365";
		public static const RPL_ENDOFNAMES:String = "366";
		public static const RPL_BANLIST:String = "367";
		public static const RPL_ENDOFBANLIST:String = "368";
		public static const RPL_ENDOFWHOWAS:String = "369";
		public static const RPL_INFO:String = "371";
		public static const RPL_MOTD:String = "372";
		public static const RPL_ENDOFINFO:String = "374";
		public static const RPL_MOTDSTART:String = "375";
		public static const RPL_ENDOFMOTD:String = "376";
		public static const RPL_YOUREOPER:String = "381";
		public static const RPL_REHASHING:String = "382";
		public static const RPL_TIME:String = "391";
		public static const RPL_USERSSTART:String = "392";
		public static const RPL_USERS:String = "393";
		public static const RPL_ENDOFUSERS:String = "394";
		public static const RPL_NOUSERS:String = "395";
		
		// Reserved Numerics.
		public static const RPL_TRACECLASS:String = "209";
		public static const RPL_STATSQLINE:String = "217";
		public static const RPL_SERVICEINFO:String = "231";
		public static const RPL_ENDOFSERVICES:String = "232";
		public static const RPL_SERVICE:String = "233";
		public static const RPL_SERVLIST:String = "234";
		public static const RPL_SERVLISTEND:String = "235";
		public static const RPL_WHOISCHANOP:String = "316";
		public static const RPL_KILLDONE:String = "361";
		public static const RPL_CLOSING:String = "362";
		public static const RPL_CLOSEEND:String = "363";
		public static const RPL_INFOSTART:String = "373";
		public static const RPL_MYPORTIS:String = "384";
		public static const ERR_YOUWILLBEBANNED:String = "466";
		public static const ERR_BADCHANMASK:String = "476";
		public static const ERR_NOSERVICEHOST:String = "492";
		
		// Error Responses
		public static const ERR_NOSUCHNICK:String = "401";
		public static const ERR_NOSUCHSERVER:String = "402";
		public static const ERR_NOSUCHCHANNEL:String = "403";
		public static const ERR_CANNOTSENDTOCHAN:String = "404";
		public static const ERR_TOOMANYCHANNELS:String = "405";
		public static const ERR_WASNOSUCHNICK:String = "406";
		public static const ERR_TOOMANYTARGETS:String = "407";
		public static const ERR_NOORIGIN:String = "409";
		public static const ERR_NORECIPIENT:String = "411";
		public static const ERR_NOTEXTTOSEND:String = "412";
		public static const ERR_NOTOPLEVEL:String = "413";
		public static const ERR_WILDTOPLEVEL:String = "414";
		public static const ERR_UNKNOWNCOMMAND:String = "421";
		public static const ERR_NOMOTD:String = "422";
		public static const ERR_NOADMININFO:String = "423";
		public static const ERR_FILEERROR:String = "424";
		public static const ERR_NONICKNAMEGIVEN:String = "431";
		public static const ERR_ERRONEUSNICKNAME:String = "432";
		public static const ERR_NICKNAMEINUSE:String = "433";
		public static const ERR_NICKCOLLISION:String = "436";
		public static const ERR_USERNOTINCHANNEL:String = "441";
		public static const ERR_NOTONCHANNEL:String = "442";
		public static const ERR_USERONCHANNEL:String = "443";
		public static const ERR_NOLOGIN:String = "444";
		public static const ERR_SUMMONDISABLED:String = "445";
		public static const ERR_USERSDISABLED:String = "446";
		public static const ERR_NOTREGISTERED:String = "451";
		public static const ERR_NEEDMOREPARAMS:String = "461";
		public static const ERR_ALREADYREGISTRED:String = "462";
		public static const ERR_NOPERMFORHOST:String = "463";
		public static const ERR_PASSWDMISMATCH:String = "464";
		public static const ERR_YOUREBANNEDCREEP:String = "465";
		public static const ERR_KEYSET:String = "467";
		public static const ERR_CHANNELISFULL:String = "471";
		public static const ERR_UNKNOWNMODE:String = "472";
		public static const ERR_INVITEONLYCHAN:String = "473";
		public static const ERR_BANNEDFROMCHAN:String = "474";
		public static const ERR_BADCHANNELKEY:String = "475";
		public static const ERR_NOPRIVILEGES:String = "481";
		public static const ERR_CHANOPRIVSNEEDED:String = "482";
		public static const ERR_CANTKILLSERVER:String = "483";
		public static const ERR_NOOPERHOST:String = "491";
		public static const ERR_UMODEUNKNOWNFLAG:String = "501";
		public static const ERR_USERSDONTMATCH:String = "502";

	}
}