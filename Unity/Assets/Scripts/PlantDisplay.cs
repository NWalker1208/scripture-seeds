using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlantDisplay : MonoBehaviour
{
    public string plantName;
    public TMPro.TMP_Text title;
    public Slider progressBar;
    public TMPro.TMP_Text progressText;
    public PlantStem stem;

    public int progress = 0;

    // Start is called before the first frame update
    void Start()
    {
        // Load save data
        SaveDataV1 data = SaveSystem.LoadState();

        if (data != null && data.plants.ContainsKey(plantName))
            progress = data.plants[plantName].progress;

        // Update progress display
        UpdateProgress();
    }

    public void UpdateProgress()
    {
        title.text = char.ToUpper(plantName[0]) + plantName.Substring(1);

        progressBar.value = progress / 14.0f;
        progressText.text = "Day " + progress.ToString() + " / 14";

        stem.GenerateSpine(progress + 3);
    }
}
