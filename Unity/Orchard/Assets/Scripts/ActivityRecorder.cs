using JetBrains.Annotations;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivityRecorder : MonoBehaviour
{
    public int minutesBetweenUpdates = 60 * 12;

    public void RecordActivity(string plantName)
    {
        SaveDataV1 data = SaveSystem.LoadState();

        if (data == null)
            data = new SaveDataV1();

        if (data.plants.ContainsKey(plantName))
        {
            if (DateTime.UtcNow - data.plants[plantName].lastUpdate > TimeSpan.FromMinutes(minutesBetweenUpdates))
            {
                if (data.plants[plantName].progress < 14)
                    data.plants[plantName].progress++;

                data.plants[plantName].lastUpdate = DateTime.UtcNow;
            }
            else
            {
                Debug.Log("No progress made, not enough time since last event");
                return;
            }
        }
        else
        {
            data.plants.Add(plantName, new PlantProgress(1, DateTime.UtcNow));
        }

        Debug.Log("Updating progress of \"" + plantName + "\" to " + data.plants[plantName].progress.ToString() + " (" + DateTime.UtcNow.ToString() + ")");

        SaveSystem.SaveState(data);
    }

    public void DeleteSaveData()
    {
        SaveSystem.DeleteSaveData();
    }
}
