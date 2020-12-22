using System;
using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class TestUIPosition : MonoBehaviour
{
    public Transform Root_1_Child;
    public Transform Root_2_Child;

    private void OnGUI()
    {
        GUILayout.BeginVertical();
        
        if (GUI.Button(new Rect(10,10,150,100), "打印坐标"))
        {
            Debug.LogError($"世界坐标: {Root_1_Child.position}; 局部坐标: {Root_1_Child.localPosition}");
            Debug.LogError($"世界坐标: {Root_2_Child.position}; 局部坐标: {Root_2_Child.localPosition}");
        }
        if (GUI.Button(new Rect(10,110,150,100), "计算坐标"))
        {
            var worldPosition1 = Root_1_Child.position;
            var localPosition1 = Root_1_Child.localPosition;
        }
        if (GUI.Button(new Rect(10,210,150,100), "2 移动到 1"))
        {
            Root_2_Child.DOMove(Root_1_Child.position, 2.0f);
        }
        GUILayout.EndVertical();
    }
}
