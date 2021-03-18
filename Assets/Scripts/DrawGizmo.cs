using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawGizmo : MonoBehaviour
{
    public GameObject[] gameObjects;
    public Vector3[] Position;
    public int ScalarProduct;
    // Start is called before the first frame update
    void Start()
    {
        gameObjects[0].transform.position = Position[0];
        gameObjects[1].transform.position = Position[1];
        //gameObjects[2].transform.position = Scalar();
    }

    // Update is called once per frame
    void Update()
    {
        ScalarProduct = Scalar();
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.white;
        Gizmos.DrawLine(transform.position, Position[0]);
        Gizmos.DrawLine(transform.position, Position[1]);
        //Gizmos.color = Color.red;
        //Gizmos.DrawLine(transform.position, Scalar());
        Gizmos.color = Color.green;
        Gizmos.DrawLine(transform.position, Sum());
        Gizmos.color = Color.yellow;
        Gizmos.DrawLine(transform.position, Difference());
        Gizmos.color = Color.blue;
        Gizmos.DrawLine(transform.position, Product());
    }

    public int Scalar()
    {
        //return new Vector3(Position[0].x * Position[1].x, Position[0].y * Position[1].y, Position[0].z * Position[1].z);
        //X = (int)Position[0].x * (int)Position[1].x;
        //Y = (int)Position[0].y * (int)Position[1].y;
        //Z = (int)Position[0].z * (int)Position[1].z;
        int ScalarProduct = (int)(Position[0].x * Position[1].x + Position[0].y * Position[1].y + Position[0].z * Position[1].z);
        return ScalarProduct;
    }
    public Vector3 Product()
    {
        return Vector3.Cross(Position[0], Position[1]);
    }
    public Vector3 Sum()
    {
        return new Vector3(Position[0].x + Position[1].x, Position[0].y + Position[1].y, Position[0].z + Position[1].z);
    }
    public Vector3 Difference()
    {
        return new Vector3(Position[0].x - Position[1].x, Position[0].y - Position[1].y, Position[0].z - Position[1].z);
    }
}
