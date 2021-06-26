using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class Urp : MonoBehaviour
{
    //public Volume volume;
    //Vignette vignette;
    // Start is called before the first frame update
    void Start()
    {
        //if(volume.profile.TryGet(out Vignette vignette))
        //{
        //    this.vignette = vignette;
        //}
        Destroy(gameObject, 0.2f);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
