state("Nv2-Current")
{
    int uiState           : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x118;
    int gameState         : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x11C;
    int currentLevelInSet : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x128;
    int ticksElapsed      : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x138;
    bool playingLevelSet  : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x13C;

    bool coopMode         : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x10;
    int selectedEpisode   : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x18;
    int selectedChallenge : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x1C;

    uint frame_num        : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x1A4, 0x10;
    bool STATEFLAG_won    : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x1A4, 0x14;
}

state("Nv2-PC")
{
    int uiState           : "Nv2-PC.exe", 0x0084D188, 0x4BC, 0x5C, 0x58;
    int gameState         : "Nv2-PC.exe", 0x0084D188, 0x4BC, 0x5C, 0x5C;
    int currentLevelInSet : "Nv2-PC.exe", 0x0084D188, 0x4BC, 0x5C, 0x68;
    int ticksElapsed      : "Nv2-PC.exe", 0x0084D188, 0x4BC, 0x5C, 0x7C;
    bool playingLevelSet  : "Nv2-PC.exe", 0x0084D188, 0x4BC, 0x5C, 0x80;

    bool coopMode         : "Nv2-PC.exe", 0x0084D188, 0x4BC, 0x5C, 0xC0, 0x10;
    int selectedEpisode   : "Nv2-PC.exe", 0x0084D188, 0x4BC, 0x5C, 0xC0, 0x18;
    int selectedChallenge : "Nv2-PC.exe", 0x0084D188, 0x4BC, 0x5C, 0xC0, 0x1C;

    uint frame_num        : "Nv2-PC.exe", 0x0084D188, 0x4BC, 0x5C, 0xE8, 0x10;
    bool STATEFLAG_won    : "Nv2-PC.exe", 0x0084D188, 0x4BC, 0x5C, 0xE8, 0x14;
}

startup
{
    settings.Add("splitOnEpisode", true, "Column Splits");
    settings.Add("splitOnColumn", false, "100% Splits");
}

init
{
    vars.running = false;
    vars.gameTimeFrames = 0;
    print("Process attached: " + game.ProcessName + " with PID " + game.Id);
}

start
{
    if (current.gameState == 2 && old.gameState == 1 && current.playingLevelSet) {
        vars.running = true;
        vars.gameTimeFrames = 0;
        return true;
    }
    return false;
}

update
{
    if (current.ticksElapsed > old.ticksElapsed)
    {
        vars.gameTimeFrames += current.ticksElapsed - old.ticksElapsed;
    }
}

isLoading
{
    return true;
}

gameTime
{
    return TimeSpan.FromSeconds(vars.gameTimeFrames / 60.0);
}

reset
{
    if (game.HasExited || current.uiState == 5) {
        vars.running = false;
        vars.gameTimeFrames = 0;
        return true;
    }

    if (settings["splitOnEpisode"])
    {
        if (current.selectedEpisode != -1)
        {
            if (current.selectedEpisode != old.selectedEpisode && current.selectedEpisode % 10 == 0)
            {
                vars.running = false;
                vars.gameTimeFrames = 0;
                return true;
            }
        }
        else if (current.selectedChallenge != -1)
        {
            if (current.currentLevelInSet != old.currentLevelInSet && current.currentLevelInSet == 0)
            {
                vars.running = false;
                vars.gameTimeFrames = 0;
                return true;
            }
        }
    }
    else if (settings["splitOnColumn"])
    {
        if (current.selectedEpisode != -1)
        {
            if (current.selectedEpisode != old.selectedEpisode && current.selectedEpisode == 0) {
                vars.running = false;
                vars.gameTimeFrames = 0;
                return true;
            }
        }
        else if (current.selectedChallenge != -1)
        {
            if (current.selectedChallenge != old.selectedChallenge && current.selectedChallenge == 0)
            {
                vars.running = false;
                vars.gameTimeFrames = 0;
                return true;
            }
        }
    }

    return false;
}

split
{
    if (settings["splitOnEpisode"])
    {
        return current.currentLevelInSet % 5 == 4 && current.STATEFLAG_won && !old.STATEFLAG_won;
    }
    else if (settings["splitOnColumn"])
    {
        if (current.selectedEpisode != -1)
        {
            return current.selectedEpisode % 10 == 9 && current.STATEFLAG_won && !old.STATEFLAG_won;
        }
        else if (current.selectedChallenge != -1)
        {
            return current.currentLevelInSet == 49 && current.STATEFLAG_won && !old.STATEFLAG_won;
        }
    }

    return false;
}