//==============================================================================
/*
* This Filterscript was scripted by [BR]Zorono
* Feel Free to Edit/Use it but please keep my credits and don't remove it
* SA-MP Forum Theard: http://forum.sa-mp.com/showthread.php?t=614109
* It Has been Updated on 20 September 2016 to Version 2.0
********************************************************************************
* New Features:-
1- Added Events Gift System
2- Fixed Some Bugs on Events Loading System
3- Added /events to see Today's Evens
4- Fixed mini Bug on /cevent
5- Added feature to check for events when every player join and if there is a event it will auto give him/her a gift (score/money)
6- Textdraws Design has been updated
7- When time updates its auto set player's Time
and much more you can find IN-GAME
*/
//==============================================================================
#include <a_samp> // Credits to SA-MP Team
#include <izcmd> // Credits to Zeax & Yashas
#include <dini> // Credits to Dracoblue
//==============================================================================
#define Events_Save_Path "Events/save/%d.ini"
#define Events_Config_Path "Events/settings/"
#define ENABLE_EVENTS_GIFT true // Comment 'true' to enable Events Gift System or 'faalse' to Disabble it

new Text:Date;
new Text:Time;
new events;
//==============================================================================
#define red 0xFF0000AA
#define blue1 0x00FFFFAA
//==============================================================================
enum EventInfo
{
  EvName[35],
  Day,
  Month,
}

// Official Holidays (unchangeable)
new Events[][EventInfo] =
{
 {"New Year's Day", 1, 1},
 {"Martin Luther King Day", 8, 1},
 {"Valentine's Day", 14, 2},
 {"Presidents's Day", 15, 2},
 {"Easter Sunday", 3, 27},
 {"Thomas Jefferson's Birthday", 13, 4},
 {"Mother's Day", 8, 5},
 {"Memorial Day", 30, 5},
 {"Father's Day", 16, 6},
 {"Independence Day", 4, 7},
 {"Labor Day", 5, 9},
 {"Columbos Day", 10, 10},
 {"Halloween", 31, 10},
 {"Election Day", 8, 11},
 {"Veterans Day", 11, 11},
 {"Christmas Eve", 24, 12},
 {"Christmas Day", 25, 12},
 {"Christmas Day Observed", 26, 12},
 {"New Year's Eve", 31, 12}
};

enum EventConfigs
{
  maxevents,
  holidays,
  use12hours,
}

new EventsData[EventConfigs];
 //==============================================================================
public OnFilterScriptInit()
{
    LoadConfigs();
    LoadEvents();
	SetTimer("SetTime", 1000,1); // After Every Second time will get changed
	SetTimer("SetDate", 86400000,1); // After Every 24 Hour Date will get changed
	print("\n--------------------------------------");
	print(" Clock System v2.0 By [BR]Zorono");
	print("--------------------------------------\n");

	Time = TextDrawCreate(605.000000,25.000000,zGetTime());
	TextDrawAlignment(Time,3);
	TextDrawBackgroundColor(Time,0x000000FF);
	TextDrawFont(Time,3);
	TextDrawLetterSize(Time,0.535,2.2);
	TextDrawColor(Time,0xFFFFFFFF);
	TextDrawSetOutline(Time,2);
	TextDrawSetProportional(Time,1);
	TextDrawSetShadow(Time,1);

	Date = TextDrawCreate(610.000000,7.000000,zGetDate());
	TextDrawUseBox(Date,0);
	TextDrawFont(Date,3);
	TextDrawLetterSize(Date,0.6,1.5);
	TextDrawSetShadow(Date,1);
	TextDrawSetOutline(Date ,0);
	TextDrawBackgroundColor(Date, 0x000000FF);
	TextDrawBoxColor(Date,0x00000066);
	TextDrawColor(Date,0xFFFFFFFF);
	TextDrawTextSize(Date , -1880.0, -1880.0);
	TextDrawAlignment(Date,3);
	TextDrawSetOutline(Date,1);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

GivePlayerScore(playerid, score)
{
  SetPlayerScore(playerid, score+GetPlayerScore(playerid));
  return 1;
}
GivePlayerGift(playerid, action, amount)
{
  new string[300];
  if(action == 1) // if 1 = money gift
  {
	GivePlayerMoney(playerid, amount);
    format(string, sizeof(string), "Enjoy your NEW Event Gift: $%d Cash", amount);
    SendClientMessage(playerid,-1, string);
  }
  if(action == 2) // if 2 = score gift
  {
	GivePlayerScore(playerid, amount);
    format(string, sizeof(string), "Enjoy your NEW Event Gift: %d Score", amount);
    SendClientMessage(playerid,-1, string);
  }
  return 1;
}
LoadEvents()
{
   new file[200], sTr[245], done;
   new day, month, year, string[300];
   getdate(year, month, day);
   for(new i = 0; i < EventsData[maxevents]; i++)
   {
   format(file, sizeof(file), Events_Save_Path, i);
   if(!dini_Exists(file))
   {
          if(EventsData[holidays] == 1)
		  {
             dini_Create(file);
             dini_IntSet(file, "evtext", Events[i][EvName]);
             dini_IntSet(file, "evmonth", Events[i][Month]);
             dini_IntSet(file, "evday", Events[i][Day]);
             format(sTr, sizeof(sTr), "\n [Events]: %s Successfully Created & Loaded", Events[i][EvName]);
             print(sTr); events++;
		  }
   }
   else if(dini_Exists(file))
   {
          Events[i][EvName] = dini_Int(file,"evtext");
          Events[i][Month] = dini_Int(file,"evmonth");
          Events[i][Day] = dini_Int(file,"evday");
          format(sTr, sizeof(sTr), "\n [Events]: %s Successfully Loaded", Events[i][EvName]);
          print(sTr); events++;
   }
   if(month == dini_Int(file, "evmonth") && day == dini_Int(file, "evday"))
   {
	      if(Events[i][EvName] != 0 && Events[i][Day] != 0 && Events[i][Month] != 0)
		  {
	         for(new p = 0; p < GetMaxPlayers(); p++)
	         {
		        if(IsPlayerConnected(p))
                {
	                if(year == 2016 && done != 1)
	                {
                       format(string, sizeof(string), "[BOT]: Happy %s (%02d/%02d)", dini_Int(file, "evtext"), GetDay(day,month), GetMonth(month));
			        }
			        else
			        {
	                   format(string, sizeof(string), "[BOT]: Happy %s (%02d/%02d)", dini_Int(file, "evtext"), ReturnDayName(GetDayOfWeek(year, month, day)), GetMonth(month));
                    }
                    SendClientMessage(p,-1, string); done++;
                    format(Events[i][EvName], 129, "%s", dini_Int(file, "evtext"));
                }
	         }
	      }
	   }
   }
   return 1;
}

LoadConfigs()
{
   new file[200];
   format(file, sizeof(file), Events_Config_Path, "config.ini");
   if(dini_Exists(file))
   {
      EventsData[maxevents] = dini_Int(file,"MaxEvents");
      EventsData[holidays] = dini_Int(file,"EnableHolidays");
      EventsData[use12hours] = dini_Int(file,"Use12Hours");
	  print("\n [Events]: Configuration Settings Successfully Loaded");
   }
   else if(!dini_Exists(file))
   {
      dini_Create(file);
      if(!dini_Isset(file,"MaxEvents"))
	  {
	     dini_IntSet(file,"MaxEvents",40);
	     format(EventsData[maxevents], 129, "%d",40);
	  }
      if(!dini_Isset(file,"EnableHolidays"))
	  {
	     dini_IntSet(file,"EnableHolidays",0);
	     format(EventsData[holidays], 129, "%d",0);
	  }
      if(!dini_Isset(file,"Use12Hours"))
	  {
	     dini_IntSet(file,"Use12Hours",1);
	     format(EventsData[use12hours], 129, "%d",0);
	  }
	  print("\n [Events]: Configuration File Successfully Created");
   }
   return 1;
}

forward SetTime();
public SetTime() {
TextDrawSetString(Time, zGetTime());
return 1;
}

forward SetDate();
public SetDate() {

TextDrawSetString(Date, zGetDate());
return 1;
}

zGetDate()
{
new string[300];
new day, month, year; getdate(year, month, day);
if(year == 2016) // Sorry but 'GetDay' function returns 2016's DayOfWeek only! (Thanks To Gammix For his Suggestion)
{
   format(string, sizeof(string), "%s/%s/%d", GetDay(day,month), GetMonth(month), year);
}
else
{
   format(string, sizeof(string), "%s/%s/%d", ReturnDayName(GetDayOfWeek(year, month, day)), GetMonth(month), year);
}
return string;
}

zGetTime()
{
    new hour, minute, second, string[400];
    gettime(hour, minute, second);
    if(EventsData[use12hours] == 0)
    {
		format(string, sizeof(string), "%02d:%02d:%02d", hour, minute, second);
    }
    else
    {
		format(string, sizeof(string), "%s", ConvertTime(hour, minute, second));
    }
	for(new i = 0; i < GetMaxPlayers(); i++)
	{
		if(IsPlayerConnected(i))
		{
			SetPlayerTime(i, hour, minute);
		}
	}
    return string;
}
GetDay(dd,mm)
{
new Str[265];
if(mm == 1) {
if(dd == 1 || dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Friday");
if(dd == 2 || dd == 9 || dd == 16 || dd == 23 || dd == 30) format(Str, sizeof(Str),"Saturday");
if(dd == 3 || dd == 10 || dd == 17 || dd == 24 || dd == 31) format(Str, sizeof(Str),"Sunday");
if(dd == 4 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Monday");
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Tuesday");
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Wednesday");
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Thursday");
}
if(mm == 2) {
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Sunday");
if(dd == 1 || dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Monday");
if(dd == 2 || dd == 9 || dd == 16 || dd == 23) format(Str, sizeof(Str),"Tuesday");
if(dd == 3 || dd == 10 || dd == 17 || dd == 24) format(Str, sizeof(Str),"Wednesday");
if(dd == 4 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Thursday");
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Friday");
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Saturday");
}
if(mm == 3) {
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Sunday");
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Monday");
if(dd == 1 || dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Tuesday");
if(dd == 2 || dd == 9 || dd == 16 || dd == 23 || dd == 30) format(Str, sizeof(Str),"Wednesday");
if(dd == 3 || dd == 10 || dd == 17 || dd == 24 || dd == 31) format(Str, sizeof(Str),"Thursday");
if(dd == 4 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Friday");
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Saturday");
}
if(mm == 4) {
if(dd == 3 || dd == 10 || dd == 17 || dd == 24) format(Str, sizeof(Str),"Sunday");
if(dd == 4 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Monday");
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Tuesday");
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Wednesday");
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Thursday");
if(dd == 1 || dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Friday");
if(dd == 2 || dd == 9 || dd == 16 || dd == 23 || dd == 30) format(Str, sizeof(Str),"Saturday");
}
if(mm == 5) {
if(dd == 1 || dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Sunday");
if(dd == 2 || dd == 9 || dd == 16 || dd == 23 || dd == 30) format(Str, sizeof(Str),"Monday");
if(dd == 3 || dd == 10 || dd == 17 || dd == 24 || dd == 31) format(Str, sizeof(Str),"Tuesday");
if(dd == 4 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Wednesday");
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Thursday");
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Friday");
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Saturday");
}
if(mm == 6) {
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Sunday");
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Monday");
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Tuesday");
if(dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Wednesday");
if(dd == 1 || dd == 9 || dd == 16 || dd == 23 || dd == 30) format(Str, sizeof(Str),"Thursday");
if(dd == 2 || dd == 10 || dd == 17 || dd == 24) format(Str, sizeof(Str),"Friday");
if(dd == 3 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Saturday");
}
if(mm == 7) {
if(dd == 3 || dd == 10 || dd == 17 || dd == 24 || dd == 31) format(Str, sizeof(Str),"Sunday");
if(dd == 4 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Monday");
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Tuesday");
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Wednesday");
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Thursday");
if(dd == 1 || dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Friday");
if(dd == 2 || dd == 9 || dd == 16 || dd == 23 || dd == 30) format(Str, sizeof(Str),"Saturday");
}
if(mm == 8) {
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Sunday");
if(dd == 1 || dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Monday");
if(dd == 2 || dd == 9 || dd == 16 || dd == 23 || dd == 30) format(Str, sizeof(Str),"Tuesday");
if(dd == 3 || dd == 10 || dd == 17 || dd == 24 || dd == 31) format(Str, sizeof(Str),"Wednesday");
if(dd == 4 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Thursday");
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Friday");
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Saturday");
}
if(mm == 9) {
if(dd == 4 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Sunday");
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Monday");
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Tuesday");
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Wednesday");
if(dd == 1 || dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Thursday");
if(dd == 2 || dd == 9 || dd == 16 || dd == 23 || dd == 30) format(Str, sizeof(Str),"Friday");
if(dd == 3 || dd == 10 || dd == 17 || dd == 24) format(Str, sizeof(Str),"Saturday");
}
if(mm == 10) {
if(dd == 2 || dd == 9 || dd == 16 || dd == 23 || dd == 30) format(Str, sizeof(Str),"Sunday");
if(dd == 3 || dd == 10 || dd == 17 || dd == 24 || dd == 31) format(Str, sizeof(Str),"Monday");
if(dd == 4 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Tuesday");
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Wednesday");
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Thursday");
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Friday");
if(dd == 1 || dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Saturday");
}
if(mm == 11) {
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Sunday");
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Monday");
if(dd == 1 || dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Tuesday");
if(dd == 2 || dd == 9 || dd == 16 || dd == 23 || dd == 30) format(Str, sizeof(Str),"Wednesday");
if(dd == 3 || dd == 10 || dd == 17 || dd == 24) format(Str, sizeof(Str),"Thursday");
if(dd == 4 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Friday");
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Saturday");
}
if(mm == 12) {
if(dd == 4 || dd == 11 || dd == 18 || dd == 25) format(Str, sizeof(Str),"Sunday");
if(dd == 5 || dd == 12 || dd == 19 || dd == 26) format(Str, sizeof(Str),"Monday");
if(dd == 6 || dd == 13 || dd == 20 || dd == 27) format(Str, sizeof(Str),"Tuesday");
if(dd == 7 || dd == 14 || dd == 21 || dd == 28) format(Str, sizeof(Str),"Wednesday");
if(dd == 1 || dd == 8 || dd == 15 || dd == 22 || dd == 29) format(Str, sizeof(Str),"Thursday");
if(dd == 2 || dd == 9 || dd == 16 || dd == 23 || dd == 30) format(Str, sizeof(Str),"Friday");
if(dd == 3 || dd == 10 || dd == 17 || dd == 24 || dd == 31) format(Str, sizeof(Str),"Saturday");
}
return Str;
}

GetMonth(mm)
{
new Str[265];
if(mm == 1) format(Str, sizeof(Str),"January");
if(mm == 2) format(Str, sizeof(Str),"February");
if(mm == 3) format(Str, sizeof(Str),"March");
if(mm == 4) format(Str, sizeof(Str),"April");
if(mm == 5) format(Str, sizeof(Str),"May");
if(mm == 6) format(Str, sizeof(Str),"June");
if(mm == 7) format(Str, sizeof(Str),"July");
if(mm == 8) format(Str, sizeof(Str),"August");
if(mm == 9) format(Str, sizeof(Str),"September");
if(mm == 10) format(Str, sizeof(Str),"October");
if(mm == 11) format(Str, sizeof(Str),"November");
if(mm == 12) format(Str, sizeof(Str),"December");
return Str;
}

GetDayOfWeek(year, month, day)
{
	new a = floatround((14-month) / 12);
	new y = (year-a);
	new m = ((month + (12*a)) - 2);
	new d = ((day + y + (y/4) - (y/100) + (y/400) + ((31*m)/12)) % 7);
	return d;
}

ReturnDayName(dayofweek)
{
	new day[15];
	switch (dayofweek)
	{
		case 0: day = "Sunday";
		case 1: day = "Monday";
		case 2: day = "Tuesday";
		case 3: day = "Wednesday";
		case 4: day = "Thursday";
		case 5: day = "Friday";
		case 6: day = "Saturday";
		default: day = "Unknown";
	}
	return day;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

ConvertTime(hh,mm,ss)
{
new hourS,dinfo[60],ntime[128];

if(hh == 00) hourS = 12; dinfo = "AM";
if(hh == 01) hourS = 1; dinfo = "AM";
if(hh == 02) hourS = 2; dinfo = "AM";
if(hh == 03) hourS = 3; dinfo = "AM";
if(hh == 04) hourS = 4; dinfo = "AM";
if(hh == 05) hourS = 5; dinfo = "AM";
if(hh == 06) hourS = 6; dinfo = "AM";
if(hh == 07) hourS = 7; dinfo = "AM";
if(hh == 08) hourS = 8; dinfo = "AM";
if(hh == 09) hourS = 9; dinfo = "AM";
if(hh == 10) hourS = 10; dinfo = "AM";
if(hh == 11) hourS = 11; dinfo = "AM";
if(hh == 12) hourS = 12; dinfo = "AM";
if(hh == 13) hourS = 1; dinfo = "PM";
if(hh == 14) hourS = 2; dinfo = "PM";
if(hh == 15) hourS = 3; dinfo = "PM";
if(hh == 16) hourS = 4; dinfo = "PM";
if(hh == 17) hourS = 5; dinfo = "PM";
if(hh == 18) hourS = 6; dinfo = "PM";
if(hh == 19) hourS = 7; dinfo = "PM";
if(hh == 20) hourS = 8; dinfo = "PM";
if(hh == 21) hourS = 9; dinfo = "PM";
if(hh == 22) hourS = 10; dinfo = "PM";
if(hh == 23) hourS = 11; dinfo = "PM";
if(hh == 24) hourS = 12; dinfo = "PM";
format(ntime, sizeof(ntime), "%02d:%02d:%02d %s", hourS, mm, ss, dinfo);
return ntime;
}
public OnPlayerConnect(playerid)
{
   new egift = random(2);
   new emoney = random(2000); // you can ddefine it to what you need
   new escore = random(10); // you can ddefine it to what you need
   new day, month, year, string[300];
   getdate(year, month, day);
   for(new i = 0; i < EventsData[maxevents]; i++)
   {
      if(day == Events[i][Day] && month == Events[i][Month])
	  {
         format(string, sizeof(string), "[BOT]: Happy %s (%02d/%02d)", Events[i][EvName], GetDay(day,month), GetMonth(month));
         SendClientMessage(playerid,-1, string);
         #if ENABLE_EVENTS_GIFT == true
         switch(egift)
         {
			case 0: GivePlayerGift(playerid, 1, emoney);
			case 1: GivePlayerGift(playerid, 2, escore);
		 }
		 #endif
      }
   }
   return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	TextDrawHideForPlayer(playerid, Time), TextDrawHideForPlayer(playerid, Date);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	TextDrawShowForPlayer(playerid, Time), TextDrawShowForPlayer(playerid, Date);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}


public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

CMD:cevent(playerid, params[])
{
    new Index;
    new tmp[256];  tmp  = strtok(params,Index);
	new tmp2[256]; tmp2 = strtok(params,Index);
	new tmp3[256]; tmp3 = strtok(params,Index);
	if(isnull(tmp) || isnull(tmp2) || isnull(tmp3)) return SendClientMessage(playerid, red, "Usage: /cevent [event text] [event month] [event day]");
	new evetext = strval(tmp),evemonth = strlen(tmp2),eveday = strlen(tmp3);
	new file[200]; for(new i = 0; i < EventsData[maxevents]; i++) {format(file, sizeof(file), Events_Save_Path, i);}
	if(events > EventsData[maxevents]) return SendClientMessage(playerid, red, "ERROR: Max Events Reached!");
	if(dini_Exists(file)) return SendClientMessage(playerid, red, "ERROR: There's already event with this details found on our Database!");
    for(new i = 0; i < EventsData[maxevents]; i++)
    {
		new sTr[200];
        dini_Create(file);
    	dini_IntSet(file, "evtext", evetext); format(Events[i][EvName], 129, "%s",evetext);
        dini_IntSet(file, "evmonth", evemonth); format(Events[i][Month], 129, "%d",evemonth);
        dini_IntSet(file, "evday", eveday); format(Events[i][Day], 129, "%d",eveday);
        events++;
        SendClientMessage(playerid,blue1, "[Events]: you have Successfully Created event");
		format(sTr, sizeof(sTr), "Event ID: %d || Event Text: %s", events, evetext);
        SendClientMessage(playerid,blue1, sTr);
		format(sTr, sizeof(sTr), "Event Day: %d || Event Month: %d", eveday, evemonth);
        SendClientMessage(playerid,blue1, sTr);
    }
    return 1;
}
CMD:revent(playerid, params[])
{
    new Index;
    new tmp[256];  tmp  = strtok(params,Index);
	if(isnull(tmp)) return SendClientMessage(playerid, red, "Usage: /revent [event ID]");
	new eveid = strval(tmp);
	new file[200]; for(new i = 0; i < EventsData[maxevents]; i++) {format(file, sizeof(file), Events_Save_Path, eveid);}
	if(!dini_Exists(file)) SendClientMessage(playerid,red, "ERROR: this event isn't exists on our Database");
    dini_Remove(file);
    events--;
    new sTr[200];
	format(sTr, sizeof(sTr), "[Events]: you have Successfully Removed event ID: %d", eveid);
    SendClientMessage(playerid,blue1, sTr);
    return 1;
}
CMD:events(playerid,params[])
{
    new count = 0;
    new string[2900];
	new day, month, year; getdate(year, month, day);
    for(new i = 0; i < EventsData[maxevents]; i++)
    {
        if(day == Events[i][Day] && month == Events[i][Month])
	    {
            format(string, sizeof(string), "Event: %s |-| Date %d/%d \n", Events[i][EvName], Events[i][Month], Events[i][Day]);
		    count ++;
        }
    }
    if (count == 0)
    {
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX,"[BR]Zorono's Clock System" ,"No Events in the list.", "OK", "");
    }
    else
    {
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX,"[BR]Zorono's Clock System",string, "OK", "");
	}
	return 1;
}
//==============================================================================
