using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.UIElements;

public class PlantStem : MonoBehaviour
{
    [SerializeField]
    float _baseWidth = 0.25f;
    public float baseWidth
    {
        get { return _baseWidth; }
        set { _baseWidth = value; GenerateMesh(); }
    }

    [SerializeField]
    Vector2[] _spine = new Vector2[10];
    public Vector2[] spine
    {
        get { return _spine; }
        set { _spine = value; GenerateMesh(); }
    }

    Mesh plantMesh;

    void Awake()
    {
        plantMesh = GetComponent<MeshFilter>().mesh;
    }

    void Start()
    {
        GenerateSpine();
    }

    public void GenerateSpine(int length = 0, bool generateMesh = true)
    {
        if (length == 0)
            length = spine.Length;

        Vector2[] newSpine = new Vector2[length];

        for (int i = 0; i < newSpine.Length; i++)
            newSpine[i] = new Vector2(math.cos(i*0.5f) * 0.1f, i * 0.25f);

        spine = newSpine;

        if (generateMesh)
            GenerateMesh();
    }

    public void GenerateMesh()
    {
        Vector3[] verts = new Vector3[spine.Length * 2];
        Vector2[] uv = new Vector2[spine.Length * 2];
        int[] tris = new int[(spine.Length - 1) * 6];

        // Generate mesh based on spine
        for(int i = 0; i < spine.Length; i++)
        {
            float stemWidth = baseWidth * (1.0f - (float)i / (spine.Length - 1));

            // Calculate normal
            Vector2 temp = Vector2.zero;

            if (i > 0)
                temp += (spine[i] - spine[i - 1]).normalized;

            if (i < spine.Length - 1)
                temp += (spine[i + 1] - spine[i]).normalized;

            if (i > 0 && i < spine.Length - 1)
                temp *= 0.5f;

            Vector3 stemNormal = new Vector3(temp.y, -temp.x, 0);

            // Create verts and tris
            verts[i * 2] = new Vector3(spine[i].x, spine[i].y, 0) - stemNormal * stemWidth * 0.5f;
            verts[i * 2 + 1] = new Vector3(spine[i].x, spine[i].y, 0) + stemNormal * stemWidth * 0.5f;

            uv[i * 2] = new Vector2(0, 1.0f / (spine.Length - 1));
            uv[i * 2 + 1] = new Vector2(1, 1.0f / (spine.Length - 1));

            if (i < spine.Length - 1)
            {
                tris[i * 6] = i * 2;
                tris[i * 6 + 1] = (i + 1) * 2;
                tris[i * 6 + 2] = i * 2 + 1;

                tris[i * 6 + 3] = (i + 1) * 2;
                tris[i * 6 + 4] = (i + 1) * 2 + 1;
                tris[i * 6 + 5] = i * 2 + 1;
            }
        }

        // Apply generated mesh
        plantMesh.Clear();
        plantMesh.vertices = verts;
        plantMesh.uv = uv;
        plantMesh.triangles = tris;
    }
}
