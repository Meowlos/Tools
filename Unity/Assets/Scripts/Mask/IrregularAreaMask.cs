using System;
using System.Collections.Generic;
using System.Reflection;
using UnityEditor;
using UnityEditor.PackageManager;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

/// <summary>
/// 不规则区域遮罩
/// </summary>
public class IrregularAreaMask : RectMask2D
{
    private List<Image> m_images;

    protected override void Start()
    {
        GetMaskChild();
        base.Start();
        AddClippable();
    }

    private void OnEnable()
    {
        base.OnEnable();
        GetMaskChild();
        AddClippable();
    }

    private void GetMaskChild()
    {
        if (m_images == null)
        {
            m_images = new List<Image>(10);
        }
        else
        {
            m_images.Clear();
        }

        var childCount = transform.childCount;
        for (var i = 0; i < childCount; i++)
        {
            var img = transform.GetChild(i).GetComponent<Image>();
            if (img && img.gameObject.name.StartsWith("mask"))
            {
                m_images.Add(img);
            }
        }
    }

    private void AddClippable()
    {
        foreach (var img in m_images)
        {
            base.AddClippable(img);
        }
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.M))
        {
            var t = typeof(IrregularAreaMask).BaseType;
            var filed = t.GetField("m_MaskableTargets", BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.GetField);
            var value = filed.GetValue(this);
            if (value is HashSet<MaskableGraphic> set)
            {
                foreach (var maskable in set)
                {
                    Debug.LogError(maskable.gameObject.name);
                }
            }
        }
        if (Input.GetKeyDown(KeyCode.C))
        {
            var t = typeof(IrregularAreaMask).BaseType;
            var filed = t.GetField("m_ClipTargets", BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.GetField);
            var value = filed.GetValue(this);
            if (value is HashSet<IClippable> set)
            {
                foreach (var clippable in set)
                {
                    Debug.LogError(clippable.gameObject.name);
                }
            }
        }
    }
}