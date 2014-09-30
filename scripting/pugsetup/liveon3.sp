/** Begins the LO3 process. **/
public Action BeginLO3(Handle timer) {
    if (!g_MatchLive)
        return;

    Call_StartForward(g_hOnGoingLive);
    Call_Finish();

    // reset player tags
    for (int i = 1; i <= MaxClients; i++)
        if (IsValidClient(i) && !IsFakeClient(i))
            CS_SetClientClanTag(i, "");

    PugSetupMessageToAll("Restart 1/3...");
    ServerCommand("mp_restartgame 1");
    CreateTimer(3.0, Restart2);
}

public Action Restart2(Handle timer) {
    if (!g_MatchLive)
        return;

    PugSetupMessageToAll("Restart 2/3...");
    ServerCommand("mp_restartgame 1");
    CreateTimer(4.0, Restart3);
}

public Action Restart3(Handle timer) {
    if (!g_MatchLive)
        return;

    PugSetupMessageToAll("Restart 3/3...");
    ServerCommand("mp_restartgame 5");
    CreateTimer(5.1, MatchLive);
}

public Action MatchLive(Handle timer) {
    if (!g_MatchLive)
        return;

    Call_StartForward(g_hOnLive);
    Call_Finish();

    for (int i = 0; i < 5; i++)
        PugSetupMessageToAll("Match is \x04LIVE\x01");
}
