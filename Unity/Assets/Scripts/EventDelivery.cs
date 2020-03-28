using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class EventDelivery : MonoBehaviour, IPointerUpHandler, IPointerDownHandler, IBeginDragHandler, IDragHandler, IEndDragHandler
{

    public delegate void LongPressCallBack(GameObject interactive, float pressTime);
    public event LongPressCallBack LongPress;
    [SerializeField] private float m_longPressTime = 0.0f;

    private bool m_longPress = false;
    private float m_timer = 0.0f;
    private bool inDragging = false;

    private GameObject m_press;

    void IPointerUpHandler.OnPointerUp(PointerEventData eventData)
    {
        m_longPress = false;

        if (inDragging)
        {
            return;
        }

        if (m_timer < m_longPressTime)
        {
            Execute(eventData, ExecuteEvents.pointerClickHandler);
        }
        else
        {
            Execute<ILongPressHandler>(eventData);
        }
        m_press = null;
    }

    void IPointerDownHandler.OnPointerDown(PointerEventData eventData)
    {
        m_press = FindCanInteractiveGameObject(eventData);
        m_timer = 0.0f;
        m_longPress = true;
    }

    void IBeginDragHandler.OnBeginDrag(PointerEventData eventData)
    {
        inDragging = true;
        m_press = FindCanInteractiveGameObject(eventData);
        Execute(eventData, ExecuteEvents.beginDragHandler);
    }

    void IDragHandler.OnDrag(PointerEventData eventData) => Execute(eventData, ExecuteEvents.dragHandler);

    void IEndDragHandler.OnEndDrag(PointerEventData eventData)
    {
        Execute(eventData, ExecuteEvents.endDragHandler);
        inDragging = false;
        m_press = null;
    }

    private void Update()
    {
        if (!m_longPress)
        {
            return;
        }
        m_timer += Time.deltaTime;
    }

    private GameObject FindCanInteractiveGameObject(PointerEventData eventData)
    {
        var list = new List<RaycastResult>(5);
        EventSystem.current.RaycastAll(eventData, list);
        foreach (var item in list)
        {
            var comp = item.gameObject.GetComponent<IEventSystemHandler>();
            if (!item.gameObject.activeInHierarchy || item.gameObject == gameObject || comp == null || !((MonoBehaviour)comp).enabled)
            {
                continue;
            }
            return item.gameObject;
        }
        return default;
    }

    private void Execute<T>(PointerEventData eventData, ExecuteEvents.EventFunction<T> fun = null) where T : IEventSystemHandler
    {
        if (m_press == null)
        {
            return;
        }

        var eventType = typeof(T);

        if (eventType == typeof(IPointerClickHandler))
        {
            var release = FindCanInteractiveGameObject(eventData);
            if (m_press != release)
            {
                return;
            }
        }

        if (eventType == typeof(ILongPressHandler))
        {
            LongPress?.Invoke(m_press, m_timer);
        }
        else if (fun != null)
        {
            ExecuteEvents.Execute(m_press, eventData, fun);
        }
    }
}
