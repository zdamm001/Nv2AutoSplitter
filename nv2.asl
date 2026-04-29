state("Nv2-Current")
{
    int uiState              : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x118;
    int gameState            : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x11C;
    bool isHighscore         : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x120;
    bool isPersonalBest      : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x124;
    int currentLevelInSet    : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x128;
    int startingTicks        : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x12C;
    int defaultStartingTicks : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x130;
    int currentTicks         : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x134;
    int ticksElapsed         : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x138;
    bool playingLevelSet     : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x13C;
    bool replayChosenByPlayer: "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x140;
    int ticksPerGold         : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x144;
    int thisTick             : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x148;
    int lastTick             : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x14C;
    int goldCollected        : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x150;
    // int goldCollected     : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x64, 0x150;
    // int goldCollected     : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x60, 0x150;
    int GOLD_DELAY           : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x154;
    int goldCountdown        : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x158;
    bool isReplay            : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x15C;
    int start                : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x160;
    bool gameTooSlow         : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x164;
    int pausedTime           : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x168;
    int SLOW_THRESHOLD       : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x1D8;
    int gameOverCooldown     : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x1E0;

    bool coopMode            : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x10;
    int selectedLevelIndexInSearch: "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x14;
    int selectedEpisode      : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x18;
    int selectedChallenge    : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x1C;
    int ticksToResumeWith    : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x20;
    bool scoreGoldImmediately: "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x24;
    bool resetScoreOnDeath   : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x28;
    int ninjaFlavour         : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x2C;
    uint p1Colour            : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x30;
    uint p2Colour            : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x34;
    int volume               : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x17C, 0x50;

    uint frame_num           : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x1A4, 0x10;
    bool STATEFLAG_won       : "Nv2-Current.exe", 0x0084D188, 0x4C0, 0x5C, 0x1A4, 0x14;
}

state("Nv2-PC")
{
    int goldCollected        : "Nv2-PC.exe", 0x0084D188, 0x4BC, 0x5C, 0x94; //FIX add rest of vars
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