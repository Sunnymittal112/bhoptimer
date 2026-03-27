#include <sourcemod>
#include <sdktools>

#pragma newdecls required
#pragma semicolon 1

Handle g_hHudSync;
bool g_bShowKeys;
float g_fLastYaw;

public Plugin myinfo = 
{
    name = "Input Visualization HUD (Keys)",
    author = "FeTaL",
    description = "Displays WASD, Jump, Duck, and Mouse movement in the bottom-left corner.",
    version = "1.0",
    url = "https://github.com/Sunnymittal112/bhoptimer",
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_keys", Command_Keys, "Toggles the real-time input visualization HUD.");
    
    g_hHudSync = CreateHudSynchronizer();
}

public void OnClientPostAdminCheck(int client)
{
    g_bShowKeys[client] = false;
    g_fLastYaw[client] = 0.0;
}

public void OnClientDisconnect(int client)
{
    g_bShowKeys[client] = false;
}

public Action Command_Keys(int client, int args)
{
    if (client == 0)
    {
        ReplyToCommand(client, " This command must be used in-game.");
        return Plugin_Handled;
    }

    g_bShowKeys[client] =!g_bShowKeys[client];
    ReplyToCommand(client, " Keys HUD visualization is now %s.", g_bShowKeys[client]? "ON" : "OFF");
    
    return Plugin_Handled;
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[1], float angles[1], int &weapon)
{
    if (!g_bShowKeys[client] ||!IsPlayerAlive(client))
    {
        return Plugin_Continue;
    }

    float fCurrentYaw = angles[2];
    float fDelta = fCurrentYaw - g_fLastYaw[client];

    if (fDelta > 180.0) 
    {
        fDelta -= 360.0;
    }
    else if (fDelta < -180.0) 
    {
        fDelta += 360.0;
    }
    
    g_fLastYaw[client] = fCurrentYaw;

    char sW[3], sA[3], sS[3], sD[3], sJ[3], sC[3], sML[1], sMR[1];

    strcopy(sW, sizeof(sW), (buttons & IN_FORWARD)? "W" : " ");
    strcopy(sA, sizeof(sA), (buttons & IN_MOVELEFT)? "A" : " ");
    strcopy(sS, sizeof(sS), (buttons & IN_BACK)? "S" : " ");
    strcopy(sD, sizeof(sD), (buttons & IN_MOVERIGHT)? "D" : " ");
    
    // Action keys (Jump and Duck) as requested
    strcopy(sJ, sizeof(sJ), (buttons & IN_JUMP)? "J" : " ");
    strcopy(sC, sizeof(sC), (buttons & IN_DUCK)? "C" : " ");

    strcopy(sML, sizeof(sML), (fDelta > 0.05)? "<-" : "  ");
    strcopy(sMR, sizeof(sMR), (fDelta < -0.05)? "->" : "  ");

    char sBuffer;
    Format(sBuffer, sizeof(sBuffer), "   %s   \n %s %s %s \n %s   %s \n%s   %s", 
        sW, sA, sS, sD, sJ, sC, sML, sMR);

    SetHudTextParams(0.02, 0.88, 0.1, 255, 255, 255, 255, 0, 0.0, 0.0, 0.0);
    
    ShowSyncHudText(client, g_hHudSync, sBuffer);

    return Plugin_Continue;
}