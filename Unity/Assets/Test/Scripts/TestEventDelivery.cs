using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEditor;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class TestEventDelivery : MonoBehaviour, IPointerClickHandler, IBeginDragHandler, IDragHandler, IEndDragHandler
{
    public EventDelivery delivery;
    public int index;


    private void Start()
    {
        delivery.LongPress += CallBack;
    }

    private void CallBack(GameObject go, float pressTime)
    {
        if (go != gameObject)
        {
            return;
        }
        Debug.LogError($"{index}: long press time -> {pressTime}");
    }

    private void OnDestroy()
    {
        delivery.LongPress -= CallBack;
    }


    public void OnPointerClick(PointerEventData eventData)
    {
        Debug.LogError($"{index}: Pointer Click");
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        Debug.LogError($"{index}: Begin Drag");
    }

    public void OnDrag(PointerEventData eventData)
    {
        Debug.LogError($"{index}: Dragging");
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        Debug.LogError($"{index}: End Drag");
    }
}
