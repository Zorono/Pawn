//==============================================================================
#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <zcmd>
//======================================//
native WP_Hash(buffer[], len, const str[]);
//==============================================================================
#define SQL_HOST "localhost"
#define SQL_USER "root"
#define SQL_PASS ""
#define SQL_DB ""
//==============================================================================
#define red	0xFF0000AA
#define yellow 0xFFFF00AA
#define blue 0x00FFFFAA
//==============================================================================
#define DIALOG_OTHER 900
#define DIALOG_TM 901
#define DIALOG_BANK_WITHDRAW 902
#define DIALOG_BANK_DEPOSIT 903
#define DIALOG_BANK_RECEIPT 904
#define DIALOG_ATR 905
#define DIALOG_FS 906
#define DIALOG_LS 907
#define DIALOG_AGE 908
#define DIALOG_DOB 909
#define DIALOG_CO 910
#define DIALOG_CI 911
#define DIALOG_PASS 912
#define DIALOG_LOGIN 913
//==============================================================================
#define MAX_ATMS 200
#define MAX_USES 10
//==============================================================================
enum AccountInfo
{
	Registered,
    FS,
    LS,
    Money,
    Age,
    DOB,
    Country,
    City,
    Password[128],
    Officer
};
enum ATMInfo
{
	Float:aX,
	Float:aY,
	Float:aZ,
	Float:aA,
	Text3D:aLabel,
	aID,
	aCP,
	aObje,
	aName[56]
};
new PlayerInfo[MAX_PLAYERS][AccountInfo];
new TMInfo[MAX_ATMS][ATMInfo];
new catm = 1;
new aString[76];
new Float:PosLoad_A[4];
new PlayerText:atmklik[MAX_PLAYERS][19];
new player1;
new AUSE_LIMIT[MAX_ATMS] = 1;
new mysql;
//==============================================================================
public OnFilterScriptInit()
{
    print("===========================================================");
	printf("|FS Name: Unique ATM Bank System v1.1");
	printf("|Scripted By: [BR]Zorono");
    print("===========================================================");
	mysql_log(LOG_ERROR | LOG_WARNING | LOG_DEBUG); 
	mysql = mysql_connect(SQL_HOST, SQL_USER, SQL_DB, SQL_PASS);
	if(mysql_errno(mysql) == 1)
	{
		printf("[MYSQL]: Connection to `%s` failed!",SQL_DB);
	}
	else
	{
		printf("[MYSQL]: Connection to `%s` succesful!",SQL_DB);
	}
	return 1;
}

public OnFilterScriptExit()
{
   mysql_close();
   DestroyATM();
   return 1;
}

public OnPlayerConnect(playerid)
{
	atmklik[playerid][0] = CreatePlayerTextDraw(playerid, 105.799949, 53.453338, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, atmklik[playerid][0], 437.000000, 312.000000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][0], 1);
	PlayerTextDrawColor(playerid, atmklik[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][0], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][0], 0);

	atmklik[playerid][1] = CreatePlayerTextDraw(playerid, 160.025085, 86.759971, "box");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][1], 0.000000, 27.439989);
	PlayerTextDrawTextSize(playerid, atmklik[playerid][1], 492.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][1], 1);
	PlayerTextDrawColor(playerid, atmklik[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, atmklik[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, atmklik[playerid][1], 6149119);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][1], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][1], 0);

	atmklik[playerid][2] = CreatePlayerTextDraw(playerid, 379.599853, 93.516616, "PT. SA:Bank");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][2], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][2], 3);
	PlayerTextDrawColor(playerid, atmklik[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][2], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][2], 0);

	atmklik[playerid][3] = CreatePlayerTextDraw(playerid, 390.000091, 118.319976, "Choose Your Action");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][3], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][3], 3);
	PlayerTextDrawColor(playerid, atmklik[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][3], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][3], 0);

	atmklik[playerid][4] = CreatePlayerTextDraw(playerid, 195.599975, 136.496582, "===========================");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][4], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][4], 1);
	PlayerTextDrawColor(playerid, atmklik[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][4], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][4], 0);

	atmklik[playerid][5] = CreatePlayerTextDraw(playerid, 286.000396, 171.800216, "<---------- $ 1000");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][5], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][5], 3);
	PlayerTextDrawColor(playerid, atmklik[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][5], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][5], 2);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][5], 0);

	atmklik[playerid][6] = CreatePlayerTextDraw(playerid, 289.400634, 201.839935, "<---------- $ 5000");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][6], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][6], 3);
	PlayerTextDrawColor(playerid, atmklik[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][6], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][6], 2);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][6], 0);

	atmklik[playerid][7] = CreatePlayerTextDraw(playerid, 299.501251, 237.940093, "<---------- $ 10.000");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][7], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][7], 3);
	PlayerTextDrawColor(playerid, atmklik[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][7], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][7], 2);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][7], 0);

	atmklik[playerid][8] = CreatePlayerTextDraw(playerid, 303.326507, 274.066650, "<---------- $ 20.000");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][8], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][8], 3);
	PlayerTextDrawColor(playerid, atmklik[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][8], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][8], 2);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][8], 0);

	atmklik[playerid][9] = CreatePlayerTextDraw(playerid, 494.799926, 172.520477, "Other ---------->");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][9], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][9], 3);
	PlayerTextDrawColor(playerid, atmklik[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][9], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][9], 2);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][9], 0);

	atmklik[playerid][10] = CreatePlayerTextDraw(playerid, 489.199920, 202.346694, "Transfer ---------->");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][10], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][10], 3);
	PlayerTextDrawColor(playerid, atmklik[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][10], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][10], 2);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][10], 0);

	atmklik[playerid][11] = CreatePlayerTextDraw(playerid, 488.099822, 273.453002, "Exit ---------->");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][11], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][11], 3);
	PlayerTextDrawColor(playerid, atmklik[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][11], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][11], 2);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][11], 0);

	atmklik[playerid][12] = CreatePlayerTextDraw(playerid, 113.600028, 166.713577, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][12], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, atmklik[playerid][12], 40.000000, 26.000000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][12], 1);
	PlayerTextDrawColor(playerid, atmklik[playerid][12], -3457537);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][12], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][12], 4);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][12], 0);
	PlayerTextDrawSetSelectable(playerid, atmklik[playerid][12], true);

	atmklik[playerid][13] = CreatePlayerTextDraw(playerid, 113.000038, 199.053405, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][13], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, atmklik[playerid][13], 40.000000, 26.000000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][13], 1);
	PlayerTextDrawColor(playerid, atmklik[playerid][13], -3457537);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][13], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][13], 4);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][13], 0);
	PlayerTextDrawSetSelectable(playerid, atmklik[playerid][13], true);

	atmklik[playerid][14] = CreatePlayerTextDraw(playerid, 113.000053, 231.906768, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][14], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, atmklik[playerid][14], 40.000000, 26.000000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][14], 1);
	PlayerTextDrawColor(playerid, atmklik[playerid][14], -3457537);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][14], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][14], 4);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][14], 0);
	PlayerTextDrawSetSelectable(playerid, atmklik[playerid][14], true);

	atmklik[playerid][15] = CreatePlayerTextDraw(playerid, 112.900047, 266.006835, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][15], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, atmklik[playerid][15], 40.000000, 26.000000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][15], 1);
	PlayerTextDrawColor(playerid, atmklik[playerid][15], -3457537);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][15], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][15], 4);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][15], 0);
	PlayerTextDrawSetSelectable(playerid, atmklik[playerid][15], true);

	atmklik[playerid][16] = CreatePlayerTextDraw(playerid, 498.199676, 166.367080, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][16], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, atmklik[playerid][16], 40.000000, 26.000000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][16], 1);
	PlayerTextDrawColor(playerid, atmklik[playerid][16], -3457537);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][16], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][16], 4);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][16], 0);
	PlayerTextDrawSetSelectable(playerid, atmklik[playerid][16], true);

	atmklik[playerid][17] = CreatePlayerTextDraw(playerid, 498.999633, 198.060119, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][17], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, atmklik[playerid][17], 40.000000, 26.000000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][17], 1);
	PlayerTextDrawColor(playerid, atmklik[playerid][17], -3457537);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][17], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][17], 4);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][17], 0);
	PlayerTextDrawSetSelectable(playerid, atmklik[playerid][17], true);

	atmklik[playerid][18] = CreatePlayerTextDraw(playerid, 497.799743, 266.006958, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, atmklik[playerid][18], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, atmklik[playerid][18], 40.000000, 26.000000);
	PlayerTextDrawAlignment(playerid, atmklik[playerid][18], 1);
	PlayerTextDrawColor(playerid, atmklik[playerid][18], -3457537);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, atmklik[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, atmklik[playerid][18], 255);
	PlayerTextDrawFont(playerid, atmklik[playerid][18], 4);
	PlayerTextDrawSetProportional(playerid, atmklik[playerid][18], 0);
	PlayerTextDrawSetShadow(playerid, atmklik[playerid][18], 0);
	PlayerTextDrawSetSelectable(playerid, atmklik[playerid][18], true);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new query[128];
	mysql_format(mysql, query, sizeof(query), "UPDATE `players` SET `FS`=%s, `LS`=%s, `Money`=%d, `Age`=%d, `DOB`=%f, `Country`=%s, `City`=%s, `Officer`=%s WHERE `Username`=%s",\
	PlayerInfo[playerid][FS], PlayerInfo[playerid][LS], PlayerInfo[playerid][Money], PlayerInfo[playerid][Age], PlayerInfo[playerid][DOB], PlayerInfo[playerid][Country], PlayerInfo[playerid][City], PlayerInfo[playerid][Officer]);
	mysql_tquery(mysql, query, "", "");
	return 1;
}

forward ATM_Load();
public ATM_Load()
{
 	PosLoad_A[0] = cache_get_field_content_float(3, "atmx");
    PosLoad_A[1] = cache_get_field_content_float(3, "atmy");
    PosLoad_A[2] = cache_get_field_content_float(3, "atmz");
 	PosLoad_A[3] = cache_get_field_content_float(3, "atma");
    cache_get_field_content(0, "isim", aString, mysql, 129);
	CreateATM(aString, PosLoad_A[0], PosLoad_A[1], PosLoad_A[2], PosLoad_A[3]);
	printf("ATM: %s loaded.", aString);
    return 1;
}

stock DestroyATM()
{
	for(new i = false; i <= MAX_ATMS; i++)
	{
	    TMInfo[i][aX] = -1;
	    TMInfo[i][aY] = -1;
	    TMInfo[i][aZ] = -1;
	    TMInfo[i][aA] = -1;
	    TMInfo[i][aID] = -1;
	    Delete3DTextLabel(TMInfo[i][aLabel]);
	    DestroyDynamicObject(TMInfo[i][aObje]);
		DestroyDynamicCP(TMInfo[i][aCP]);
	}
	catm = 1;
	return 1;
}

stock CreateATM(atmname[], Float:aaX, Float:aaY, Float:aaZ, Float:aaA){
	new atmName[100];
	format(atmName,76,"{ffffff}%s(%i)\n{ffffff}State: {77c97d}Active\nPress 'Y' To Open ATM Optians List", atmname, catm);
	TMInfo[catm][aX] = aaX;
	TMInfo[catm][aY] = aaY;
	TMInfo[catm][aZ] = aaZ;
	TMInfo[catm][aA] = aaA;
	TMInfo[catm][aID] = catm;
	TMInfo[catm][aCP] =  CreateDynamicCP(aaX, aaY, aaZ, 1.0,-1,-1,-1,100.0);
	TMInfo[catm][aLabel] = Create3DTextLabel(atmName, 0x6F006FFF, aaX, aaY, aaZ, 25.0, 0, 0);
	TMInfo[catm][aObje] = CreateDynamicObject(2942, TMInfo[catm][aX], TMInfo[catm][aY], TMInfo[catm][aZ]-0.5, 0.0000000, 0.0000000, TMInfo[catm][aA]);
	format(TMInfo[catm][aName], 56, "%s", atmname);
	catm++;
	return true;
}

forward MessageToOfficers(color,const string[]);
public MessageToOfficers(color,const string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) == 1) if (PlayerInfo[i][Officer] >= 1) SendClientMessage(i, color, string);
	}
	return 1;
}

stock PlayerName2(playerid)
{
  new plname[MAX_PLAYER_NAME];
  GetPlayerName(playerid, plname, sizeof(plname));
  return plname;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	    if(playertextid  == atmklik[playerid][5])
	    {
	        SendClientMessage(playerid, 0xA3B4C5FF, "You Have Recived $1000 From your Bank Account!");
	        GivePlayerMoney(playerid, 1000);
	        PlayerInfo[playerid][Money] -= 1000;
	        CancelSelectTextDraw(playerid);
	        for(new a=0 ; a<20 ; a++)
		   	PlayerTextDrawHide(playerid, atmklik[playerid][a]);
		}
		if(playertextid  == atmklik[playerid][6])
	    {
	        SendClientMessage(playerid, 0xA3B4C5FF, "You Have Recived $5000 From your Bank Account!");
	        GivePlayerMoney(playerid, 5000);
	        PlayerInfo[playerid][Money] -= 5000;
	        CancelSelectTextDraw(playerid);
	        for(new a=0 ; a<20 ; a++)
		   	PlayerTextDrawHide(playerid, atmklik[playerid][a]);
		}
		if(playertextid  == atmklik[playerid][7])
	    {
	        SendClientMessage(playerid, 0xA3B4C5FF, "You Have Recived $10.000 From your Bank Account!");
	        GivePlayerMoney(playerid, 10000);
	        PlayerInfo[playerid][Money] -= 10000;
	        CancelSelectTextDraw(playerid);
	        for(new a=0 ; a<20 ; a++)
		   	PlayerTextDrawHide(playerid, atmklik[playerid][a]);
		}
		if(playertextid  == atmklik[playerid][8])
	    {
	        SendClientMessage(playerid, 0xA3B4C5FF, "You Have Recived $20.000 From your Bank Account!");
            GivePlayerMoney(playerid, 20000);
            PlayerInfo[playerid][Money] -= 20000;
	        CancelSelectTextDraw(playerid);
	        for(new a=0 ; a<20 ; a++)
		   	PlayerTextDrawHide(playerid, atmklik[playerid][a]);
		}
		if(playertextid  == atmklik[playerid][9])
	    {
		    ShowPlayerDialog(playerid, DIALOG_OTHER, DIALOG_STYLE_LIST, "{FFFF00}Bank Optians", "Deposit a money\nWithdraw a Money\nCheck My Balance", "Select", "Cancel");
	        CancelSelectTextDraw(playerid);
	        for(new a=0 ; a<20 ; a++)
		   	PlayerTextDrawHide(playerid, atmklik[playerid][a]);
		}
		if(playertextid  == atmklik[playerid][10])
	    {
            ShowPlayerDialog(playerid,DIALOG_TM, DIALOG_STYLE_INPUT,"{FFFF00}Bank","Please, put here the Player ID that you need tranfer him a Money","Ok","Cancel");
	        CancelSelectTextDraw(playerid);
	        for(new a=0 ; a<20 ; a++)
		   	PlayerTextDrawHide(playerid, atmklik[playerid][a]);
		}
		if(playertextid  == atmklik[playerid][11])
	    {
	        CancelSelectTextDraw(playerid);
	        for(new a=0 ; a<20 ; a++)
		   	PlayerTextDrawHide(playerid, atmklik[playerid][a]);
		}
		return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if(dialogid == DIALOG_OTHER && response)
{
switch(listitem)
{
case 0:
{
ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "{33CCFF}Bank Deposit", "{FFFFFF}Please choose an amount of money you would like to deposit.\n{33CCFF}Note: {FFFFFF}This amount can not be more than the amount you currently have on you player\nand the min amount you can deposit is {33AA33}$1.", "Deposit", "Cancel");
}
case 1:
{
ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT, "{33CCFF}Bank Withdraw", "{FFFFFF}Please choose an amount of money you would like to withdraw.\n{33CCFF}Note: {FFFFFF}This amount can not be more than the amount you currently have in your bank account\nand the min amount you can withdraw is {33AA33}$1.", "Withdraw", "Cancel");
}
case 2:
{
new string[128];
format(string,sizeof(string),"You Have In Your Bank Account: $%d", PlayerInfo[playerid][Money]);
SendClientMessage(playerid,0xA3B4C5FF,string);
}
}
}
if(dialogid == DIALOG_TM && response)
{
player1 = strval(inputtext);
if(IsPlayerConnected(player1) && player1 != INVALID_PLAYER_ID && player1 != playerid)
{
ShowPlayerDialog(playerid, DIALOG_ATR, DIALOG_STYLE_INPUT, "Bank","{00FFFF}Please Enter The Amount Of money you want Tranfer it!","Apply","Cancel");
}
}

if(dialogid == DIALOG_ATR && response)
{
GivePlayerMoney(playerid, -strval(inputtext));
PlayerInfo[playerid][Money] -= strval(inputtext);
PlayerInfo[player1][Money] += strval(inputtext);
}
if(dialogid == DIALOG_BANK_DEPOSIT && response)
{
if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "{33CCFF}Deposit", "{FFFFFF}Please choose an amount of money you would like to deposit.\n{33CCFF}Note: {FFFFFF}This amount can not be more than the amount you currently have on you player\nand the min amount you can deposit is {33AA33}$1.", "Deposit", "Cancel");
if(strval(inputtext) > GetPlayerMoney(playerid) || strval(inputtext) < 1) return ShowPlayerDialog(playerid, DIALOG_BANK_DEPOSIT, DIALOG_STYLE_INPUT, "{33CCFF}Deposit", "{FF0000}Invalid amount!\n{FFFFFF}Please choose an amount of money you would like to deposit.\n{33CCFF}Note: {FFFFFF}This amount can not be more than the amount you currently have on you player\nand the min amount you can deposit is {33AA33}$1.", "Deposit", "Cancel");
new str[128];
GivePlayerMoney(playerid, -strval(inputtext));
PlayerInfo[playerid][Money] += strval(inputtext);
PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
format(str, sizeof str, "{FFFFFF}You have deposited: {33AA33}$%d\n\n{FFFFFF}Your new bank balance is {33AA33}$%d", strval(inputtext), PlayerInfo[playerid][Money]);
ShowPlayerDialog(playerid, DIALOG_BANK_RECEIPT, DIALOG_STYLE_MSGBOX, "{33CCFF}Deposited", str, "Ok", "");
}
if(dialogid == DIALOG_BANK_WITHDRAW && response)
{
new str[128], stringo[128];
for(new i = false; i <= MAX_ATMS; i++)
{
if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT, "{33CCFF}Withdraw", "{FFFFFF}Please choose an amount of money you would like to withdraw.\n{33CCFF}Note: {FFFFFF}This amount can not be more than the amount you currently have in your bank account\nand the min amount you can withdraw is {33AA33}$1.", "Withdraw", "Cancel");
if(strval(inputtext) > PlayerInfo[playerid][Money] || strval(inputtext) < 1) return ShowPlayerDialog(playerid, DIALOG_BANK_WITHDRAW, DIALOG_STYLE_INPUT, "{33CCFF}Withdraw", "{FF0000}Invalid amount!/n{FFFFFF}Please choose an amount of money you would like to withdraw.\n{33CCFF}Note: {FFFFFF}This amount can not be more than the amount you currently have in your bank account\nand the min amount you can withdraw is {33AA33}$1.", "Withdraw", "Cancel");
if(AUSE_LIMIT[i] >= MAX_USES) {
SendClientMessage(playerid, red, "Maximum limit reached. Please Wait untill A Bank Officer Refill This ATM Bancher!");
format(stringo, sizeof stringo, "[SA:Bank]:ATM ID:%d, Has reaced Limit Of Uses, Please Refill It!", i);
MessageToOfficers(yellow, stringo);
return 1;
}
GivePlayerMoney(playerid, strval(inputtext));
PlayerInfo[playerid][Money] -= strval(inputtext);
PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
AUSE_LIMIT[i]++;
format(str, sizeof str, "{FFFFFF}You have withdraw: {33AA33}$%d\n\n{FFFFFF}Your new bank balance is {33AA33}$%d.", strval(inputtext), PlayerInfo[playerid][Money]);
ShowPlayerDialog(playerid, DIALOG_BANK_RECEIPT, DIALOG_STYLE_MSGBOX, "{33CCFF}Withdraw", str, "Ok", "");
GivePlayerMoney(playerid, strval(inputtext));
  }
}
if(dialogid == DIALOG_FS && response)
{
if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_FS, DIALOG_STYLE_INPUT, "Bank", "{33AA33}Please Enter Your First Name!", "Okay", "Cancel");
PlayerInfo[playerid][FS] = strlen(inputtext);
ShowPlayerDialog(playerid, DIALOG_LS, DIALOG_STYLE_INPUT, "Bank", "Please Enter Your Last Name!", "Okay", "Cancel");
}
if(dialogid == DIALOG_LS && response)
{
if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_LS, DIALOG_STYLE_INPUT, "Bank", "{33AA33}Please Enter Your Last Name!", "Okay", "Cancel");
PlayerInfo[playerid][LS] = strlen(inputtext);
ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Bank", "Please Enter Your Age!", "Okay", "Cancel");
}
if(dialogid == DIALOG_AGE && response)
{
if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Bank", "{33AA33}Please Enter Your Age!", "Okay", "Cancel");
PlayerInfo[playerid][Age] = strval(inputtext);
ShowPlayerDialog(playerid, DIALOG_DOB, DIALOG_STYLE_INPUT, "Bank", "Please Enter Your Date Of Birth!", "Okay", "Cancel");
}
if(dialogid == DIALOG_DOB && response)
{
if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_DOB, DIALOG_STYLE_INPUT, "Bank", "{33AA33}Please Enter Your Date Of Birth!", "Okay", "Cancel");
PlayerInfo[playerid][DOB] = strlen(inputtext);
ShowPlayerDialog(playerid, DIALOG_CO, DIALOG_STYLE_INPUT, "Bank", "Please Enter Your Country!", "Okay", "Cancel");
}
if(dialogid == DIALOG_CO && response)
{
if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_CO, DIALOG_STYLE_INPUT, "Bank", "{33AA33}Please Enter Your Country!", "Okay", "Cancel");
PlayerInfo[playerid][Country] = strlen(inputtext);
ShowPlayerDialog(playerid, DIALOG_CI, DIALOG_STYLE_INPUT, "Bank", "Please Enter Your City!", "Okay", "Cancel");
}
if(dialogid == DIALOG_CI && response)
{
if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_CI, DIALOG_STYLE_INPUT, "Bank", "{33AA33}Please Enter Your City!", "Okay", "Cancel");
PlayerInfo[playerid][City] = strlen(inputtext);
ShowPlayerDialog(playerid, DIALOG_PASS, DIALOG_STYLE_INPUT, "Bank", "Please Enter Your Permant Password\nNote:You Must Save Your Password To Be able to acess Your Account on any Time!", "Okay", "Cancel");
}
if(dialogid == DIALOG_PASS && response)
{
new string[200],query[500];
if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_PASS, DIALOG_STYLE_INPUT, "Bank", "Please Enter Your Permant Password\nNote:You Must Save Your Password To Be able to acess Your Account on any Time!", "Okay", "Cancel");
SendClientMessage(playerid,red,"Congratz: You Have Suessfully Created Your Own ATM Bank Account. You Can Access It in any time From any San Andreas ATM Bank Pranch!");
format(string,sizeof(string),"[INFO]: Your Current Balance: $0");
SendClientMessage(playerid,0xA3B4C5FF,string);
WP_Hash(PlayerInfo[playerid][Password], 129, inputtext);
mysql_format(mysql, query, sizeof(query), "INSERT INTO `players` (`Username`, `FS`, `LS`, `Money`, `Age`, `DOB` ,`Country`, `City`, `Password`, `Officer`) VALUES ('%e', '%s', '%s', '%s', 0, '%d', '%s', '%s', '%s', 0)", PlayerName2(playerid), PlayerInfo[playerid][FS], PlayerInfo[playerid][LS], PlayerInfo[playerid][Age], PlayerInfo[playerid][DOB], PlayerInfo[playerid][Country], PlayerInfo[playerid][City], PlayerInfo[playerid][Password]);
mysql_tquery(mysql, query, "OnAccountRegister", "i", playerid);
}
if(dialogid == DIALOG_LOGIN && response)
{
new hpass[129], query[100];
WP_Hash(hpass, 129, inputtext);
if(!strcmp(hpass, PlayerInfo[playerid][Password]))
{
mysql_format(mysql, query, sizeof(query), "SELECT * FROM `players` WHERE `Username` = '%e' LIMIT 1", PlayerName2(playerid));
mysql_tquery(mysql, query, "OnAccountLoad", "i", playerid);
SelectTextDraw(playerid, 0xA3B4C5FF);
for (new x=0 ; x<20 ;x++) {
PlayerTextDrawShow(playerid, atmklik[playerid][x]);
PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
}
}
else
{
ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Bank", "Please Enter Your Password To Acess Your Account!", "Login", "Cancel");
}
}
return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_YES)
	{
	for(new i = false; i <= MAX_ATMS; i++)
	{
    	if(IsPlayerInRangeOfPoint(playerid,5.0,TMInfo[i][aX],TMInfo[i][aY],TMInfo[i][aZ])) {
        new query[128];
     	mysql_format(mysql, query, sizeof(query),"SELECT `Password`, `FS`, `LS`, `Money`, `Age`, `DOB`, `Country`, `City` FROM `players` WHERE `Username` = '%e' LIMIT 1", PlayerName2(playerid));
        mysql_tquery(mysql, query, "OnAccountCheck", "i", playerid);
        }
      }
    }
	return 1;
}

CMD:catm(playerid,params[])
{
	new aNeym[56],query[128];
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "You are not RCON Admin!");
	if(sscanf(params, "s[56]", aNeym)) return SendClientMessage(playerid, -1, "Usage: /catm [ATM Text]");
	if(catm >= MAX_ATMS) return SendClientMessage(playerid, -1, "Maximum limit reached!");
	else {
	new string[126], Float: gPos[4];
	GetPlayerPos(playerid, gPos[0], gPos[1], gPos[2]);
	GetPlayerFacingAngle(playerid, gPos[3]);
	mysql_format(mysql, query, sizeof(query), "UPDATE `players` SET `isim`=%d, `atmx`=%f, `atmy`=%f, `atmz`=%f, `atma`=%f WHERE `Aid`=%d",\
	aNeym, gPos[0], gPos[1], gPos[2], gPos[3], catm);
	mysql_tquery(mysql, query, "", "");
	CreateATM(aNeym, gPos[0], gPos[1], gPos[2], gPos[3]);
	format(string, sizeof string, "You Have Successfully Created:%s | ATM ID: %d", aNeym, catm-1);
	SendClientMessage(playerid, -1, string);
	}
    return 1;
}

CMD:datm(playerid,params[])
{
	new aid,query[128];
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "You are not RCON Admin!");
	if(sscanf(params, "i", aid)) return SendClientMessage(playerid, -1, "Usage: /datm [ATM ID]");
	else {
	mysql_format(mysql, query, sizeof(query), "DELETE FROM banks WHERE atmx = '%f', atmy = '%f', atmz = '%f', atma = '%f', Aid = '%d'",\
	TMInfo[aid][aX], TMInfo[aid][aY], TMInfo[aid][aZ], TMInfo[aid][aA], aid);
	mysql_tquery(mysql, query, "", "");
 	TMInfo[aid][aX] = -1;
	TMInfo[aid][aY] = -1;
	TMInfo[aid][aZ] = -1;
	TMInfo[aid][aA] = -1;
	TMInfo[aid][aID] = -1;
	Delete3DTextLabel(TMInfo[aid][aLabel]);
	DestroyDynamicCP(TMInfo[aid][aCP]);
	DestroyDynamicObject(TMInfo[aid][aObje]);
	catm--;
	if(catm == 0) catm = 1;
	}
    return 1;
}

CMD:ratm(playerid,params[])
{
if(PlayerInfo[playerid][Officer] == 1) {
for(new i = false; i <= MAX_ATMS; i++)
{
if(IsPlayerInRangeOfPoint(playerid,2.0,TMInfo[i][aX],TMInfo[i][aY],TMInfo[i][aZ])) {
AUSE_LIMIT[i] = 0;
}
}
} else return SendClientMessage(playerid,red,"ERROR: You aren't ATM Bank Officer to use this Command!");
return 1;
}

CMD:setoff(playerid, params[])
{
new ID,orank,admname[MAX_PLAYER_NAME],pname[MAX_PLAYER_NAME];
if(IsPlayerAdmin(playerid))
{
if(sscanf(params,"ui",ID,orank)) {
SendClientMessage(playerid,red, "Usage: /setoff [id] [Rank]");
SendClientMessage(playerid,red, "1 - Junior Officer");
SendClientMessage(playerid,red, "2 - Senior Officer");
SendClientMessage(playerid,red, "3 - Master Officer");
return 1;
}
if(!IsPlayerConnected(ID)) return SendClientMessage(playerid,red, "Player is not connected");
GetPlayerName(playerid,admname, MAX_PLAYER_NAME);
GetPlayerName(ID,pname,MAX_PLAYER_NAME);
PlayerInfo[ID][Officer] = orank;
new string[128];
format(string,sizeof(string),"ERROR: Player is already this Rank");
if(PlayerInfo[ID][Officer] == orank) return SendClientMessage(playerid,red,string);
format(string,sizeof(string),"Congratz:Admin %s has set you to ATM Bank Officer Rank Status | V.I.P Rank: %d |",admname,orank);
SendClientMessage(ID,blue,string);
format(string,sizeof(string),"You have made %s ATM Bank Officer Rank %d",pname,orank);
SendClientMessage(playerid,blue,string);
} else return SendClientMessage(playerid,red,"ERROR: You need to be RCON Administrator to use this command");
return 1;
}

CMD:offs(playerid,params[])
{
	#pragma unused params
    new count = 0;
    new string[128];
    new OFFRank[128];
	SendClientMessage(playerid,blue, " ");
    SendClientMessage(playerid,blue, "___________ |- Online ATM Bank Officers -| ___________");
	SendClientMessage(playerid,blue, " ");
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
 		if (IsPlayerConnected(i))
		{
			if(PlayerInfo[i][Officer] >= 1 )
			{

			    {
			 		switch(PlayerInfo[i][Officer])
					{
						case 1: {
							OFFRank = "Junior Officer";
						}
						case 2: {
							OFFRank = "Senior Officer";
						}
						case 3: {
							OFFRank = "Master Officer";
						}
					}
				}
				format(string, 128, "Rank: %d - %s (ID:%i) | %s |",PlayerInfo[i][Officer], PlayerName2(i),i,OFFRank);
				SendClientMessage(playerid, yellow, string);
				count++;
			}
		}
	}
	if (count == 0)
	SendClientMessage(playerid,blue,"No ATM Bank Officers online ");
	SendClientMessage(playerid,blue, " _______________________________________");
	return 1;
}

forward OnAccountCheck(playerid);
public OnAccountCheck(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, mysql);
	if(rows)
	{
		cache_get_field_content(0, "FS", PlayerInfo[playerid][FS], mysql, 129);
		cache_get_field_content(0, "LS", PlayerInfo[playerid][LS], mysql, 129);
		cache_get_field_content(0, "Money", PlayerInfo[playerid][Money], mysql, 129);
		cache_get_field_content(0, "Age", PlayerInfo[playerid][Age], mysql, 129);
		cache_get_field_content(0, "DOB", PlayerInfo[playerid][DOB], mysql, 129);
		cache_get_field_content(0, "Country", PlayerInfo[playerid][Country], mysql, 129);
		cache_get_field_content(0, "City", PlayerInfo[playerid][City], mysql, 129);
		cache_get_field_content(0, "Password", PlayerInfo[playerid][Password], mysql, 129);
		cache_get_field_content(0, "Officer", PlayerInfo[playerid][Officer], mysql, 129);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Bank", "Please Enter Your Password To Acess Your Account!", "Login", "Cancel");
	}
	else
	{
		SendClientMessage(playerid,red,"ERROR: You Haven't Any ATM Bank Account Yet.");
		ShowPlayerDialog(playerid, DIALOG_FS, DIALOG_STYLE_INPUT, "Bank","{00FFFF}Please Enter Your First Name!","Ok","Cancel");

	}
	return 1;
}

forward OnAccountLoad(playerid);
public OnAccountLoad(playerid)
{
	cache_get_field_content(0, "FS", PlayerInfo[playerid][FS], mysql, 129);
	cache_get_field_content(0, "LS", PlayerInfo[playerid][LS], mysql, 129);
	cache_get_field_content_int(0, "Money", PlayerInfo[playerid][Money]);
	cache_get_field_content_int(0, "Age", PlayerInfo[playerid][Age]);
	cache_get_field_content(0, "DOB", PlayerInfo[playerid][DOB], mysql, 129);
	cache_get_field_content(0, "Country", PlayerInfo[playerid][Country], mysql, 129);
	cache_get_field_content(0, "City", PlayerInfo[playerid][City], mysql, 129);
	cache_get_field_content(0, "Password", PlayerInfo[playerid][Password], mysql, 129);
	cache_get_field_content_int(0, "Officer", PlayerInfo[playerid][Officer]);
	SendClientMessage(playerid, -1, "Successfully logged in"); 
	return 1;
}

forward OnAccountRegister(playerid);
public OnAccountRegister(playerid)
{
    printf("New account registered. ID: %d", playerid); 
    return 1;
}
