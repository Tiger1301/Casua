using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(DrawGizmo))]
public class DrawGizmoEditor : Editor
{
    //private void OnSceneGUI()
    //{
    //    DrawGizmo t = target as DrawGizmo;
    //
    //    if(t==null||t.gameObjects==null)
    //    {
    //        return;
    //    }
    //
    //    Vector3 centre = t.transform.position;
    //
    //    for(int i=0; 1<t.gameObjects.Length; i++)
    //    {
    //        if(t.gameObjects[i]!=null)
    //        {
    //            Handles.DrawLine(centre, t.gameObjects[i].transform.position);
    //        }
    //    }
    //}
}
