using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Decomposition : MonoBehaviour
{
    public Vector3 vector;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(transform.position, vector);
        Gizmos.color = Color.white;
        Gizmos.DrawLine(transform.position, ComponentX());
        Gizmos.DrawLine(transform.position, ComponentY());
        Gizmos.DrawLine(transform.position, ComponentZ());
    }

    Vector3 ComponentX()
    {
        return new Vector3(vector.x, 0, 0);
    }
    Vector3 ComponentY()
    {
        return new Vector3(0, vector.y, 0);
    }
    Vector3 ComponentZ()
    {
        return new Vector3(0, 0, vector.z);
    }
}
