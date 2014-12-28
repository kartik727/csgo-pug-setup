public void StartKnifeRound() {
    ServerCommand("exec sourcemod/pugsetup/knife");
    g_WaitingForKnifeWinner = true;
    g_WaitingForKnifeDecision = false;
    for (int i = 0; i < 5; i++)
        PugSetupMessageToAll("%t", "KnifeRound");
    ServerCommand("mp_restartgame 1");
}

public void EndKnifeRound() {
    ExecGameConfigs();
    g_WaitingForKnifeWinner = false;
    CreateTimer(3.0, BeginLO3, _, TIMER_FLAG_NO_MAPCHANGE);
}

static bool AwaitingDecision(int client) {
    if (!g_WaitingForKnifeDecision)
        return false;

    // always lets console make the decision
    if (client == 0)
        return true;

    // check if they're on the winning team
    return IsPlayer(client) && GetClientTeam(client) == g_KnifeWinner;
}

public Action Command_Stay(int client, int args) {
    if (AwaitingDecision(client)) {
        g_WaitingForKnifeDecision = false;
        EndKnifeRound();
    }
}

public Action Command_Swap(int client, int args) {
    if (AwaitingDecision(client)) {
        g_WaitingForKnifeDecision = false;
        for (int i = 1; i <= MaxClients; i++) {
            if (IsPlayer(i)) {
                int team = GetClientTeam(i);
                if (team == CS_TEAM_T)
                    SwitchPlayerTeam(i, CS_TEAM_CT);
                else if (team == CS_TEAM_CT)
                    SwitchPlayerTeam(i, CS_TEAM_T);
            }
        }
        EndKnifeRound();
    }
}
