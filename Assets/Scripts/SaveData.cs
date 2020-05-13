using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class PlantProgress
{
    public int progress;
    public DateTime lastUpdate;

    public PlantProgress(int progress, DateTime lastUpdate)
    {
        this.progress = progress;
        this.lastUpdate = lastUpdate;
    }
}

[System.Serializable]
public class SaveDataV1
{
    public Dictionary<string, PlantProgress> plants = new Dictionary<string, PlantProgress>();
}
