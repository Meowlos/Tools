using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening.Plugins;
using UnityEngine;
using UnityEngine.UI;
using Random = UnityEngine.Random;

[RequireComponent(typeof(RectTransform), typeof(RawImage))]
public class GetSetImagePixel : MonoBehaviour
{
    private RawImage m_img;
    private RectTransform m_trans;

    private void Start()
    {
        m_img = GetComponent<RawImage>();
        m_trans = GetComponent<RectTransform>();
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.S))
        {
            SetPixel();
        }
        if (Input.GetKeyDown(KeyCode.T))
        {
            GetPixel();
        }
    }

    private void SetPixel()
    {
        var size = m_trans.sizeDelta;
        var tex = new Texture2D(Mathf.CeilToInt(size.x), Mathf.CeilToInt(size.y));
        for (var x = 0; x < tex.width; x++)
        {
            for (var y = 0; y < tex.height; y++)
            {
                tex.SetPixel(
                    x,
                    y,
                    new Color(
                        Random.Range(0.0f, 1.0f),
                        Random.Range(0.0f, 1.0f),
                        Random.Range(0.0f, 1.0f),
                        1.0f
                    )
                );
            }
        }
        tex.Apply();
        m_img.texture = tex;
    }

    private void GetPixel()
    {
        // var pos = m_trans.position;
        // var size = m_trans.sizeDelta;
        //
        //
        //
        // var tex = m_img.texture as Texture2D;
        // if (tex == null)
        // {
        //     return;
        // }
        // for (var x = 0; x < 10; x++)
        // {
        //     for (var y = 0; y < 10; y++)
        //     {
        //     }
        // }
    }
}