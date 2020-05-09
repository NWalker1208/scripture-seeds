using System;
using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Experimental.Rendering.Universal;

public class Sun2D : MonoBehaviour
{
    public float distance;
    public float maxIntensity;
    public float timeOffset;

    Light2D sunlight;
    Camera mainCamera;

    private void Start()
    {
        sunlight = GetComponent<Light2D>();
        mainCamera = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        System.TimeSpan time = System.DateTime.Now.TimeOfDay;
        double sunAngle = ((time.TotalMinutes + timeOffset) / (24 * 60)) * 2 * Mathf.PI;
        sunAngle = sunAngle % (2 * Mathf.PI);

        Vector3 pos = transform.position;
        pos.x = distance * -Mathf.Sin((float)sunAngle);
        pos.y = distance * -Mathf.Cos((float)sunAngle);
        transform.position = pos;

        float intensity = Mathf.Cos(((float)sunAngle - Mathf.PI) * 0.75f) * maxIntensity;
        sunlight.intensity = intensity > 0 ? intensity : 0;
    }
}
