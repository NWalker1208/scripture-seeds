using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.UIElements;

public class ButtonShadow : MonoBehaviour, IPointerDownHandler, IPointerUpHandler
{
    public float animationLength = 0.25f;
    public float shadowShrink = 0.1f;
    public UnityEngine.UI.Image shadowImage;

    enum AnimationState
    {
        HOLD,
        MOUSE_DOWN,
        MOUSE_UP
    }

    AnimationState clicked = AnimationState.HOLD;
    float clickTime;

    void Update()
    {
        switch(clicked)
        {
            case AnimationState.MOUSE_DOWN:
                if (Time.time < clickTime + animationLength)
                    shadowImage.transform.localScale = Vector3.one * (1 - shadowShrink * Mathf.Sin((Time.time - clickTime) / animationLength * (Mathf.PI / 2)));
                else
                {
                    shadowImage.transform.localScale = Vector3.one * (1 - shadowShrink);
                    clicked = AnimationState.HOLD;
                }
                break;

            case AnimationState.MOUSE_UP:
                if (Time.time < clickTime + animationLength / 2)
                    shadowImage.transform.localScale = Vector3.one * (1 - shadowShrink * Mathf.Sin((Time.time - clickTime + animationLength) / animationLength * (Mathf.PI / 2)));
                else
                {
                    shadowImage.transform.localScale = Vector3.one;
                    clicked = AnimationState.HOLD;
                }
                break;

            default:
                break;
        }    
    }

    public void OnPointerDown(PointerEventData e)
    {
        clicked = AnimationState.MOUSE_DOWN;
        clickTime = Time.time;
    }

    public void OnPointerUp(PointerEventData e)
    {
        clicked = AnimationState.MOUSE_UP;
        clickTime = Time.time;
    }
}
