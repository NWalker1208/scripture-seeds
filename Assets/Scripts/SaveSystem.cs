using UnityEngine;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.Serialization;

public static class SaveSystem
{
    static readonly string pathV1 = Application.persistentDataPath + "/data.osv1";

    public static void SaveState(SaveDataV1 data)
    {
        BinaryFormatter formatter = new BinaryFormatter();
        FileStream stream = new FileStream(pathV1, FileMode.Create);

        formatter.Serialize(stream, data);
        stream.Close();

        Debug.Log("Saved successfully to " + pathV1);

        // Delete old save data files
        // if (File.exists())
        //      File.delete();
    }

    public static SaveDataV1 LoadState()
    {
        if (File.Exists(pathV1))
        {
            BinaryFormatter formatter = new BinaryFormatter();
            FileStream stream = new FileStream(pathV1, FileMode.Open);

            SaveDataV1 data;

            try
            {
                data = formatter.Deserialize(stream) as SaveDataV1;
            }
            catch (SerializationException)
            {
                data = null;
                Debug.LogError("Failed to deserialize V1 save data");
            }

            stream.Close();

            return data;
        }
        // Check for old save data versions, convert to new version
        else
        {
            Debug.LogError("No save data file found");
            return null;
        }
    }

    public static void DeleteSaveData()
    {
        Debug.Log("Deleting save data file");

        if (File.Exists(pathV1))
        {
            File.Delete(pathV1);
        }
        else
            Debug.LogError("No save data file found");
    }
}
