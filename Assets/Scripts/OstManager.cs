using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OstManager : MonoBehaviour
{
    UIManager UM;
    int StartOST;
    int LL = 0;
    int S1 = 0;
    int S2 = 0;
    int C1 = 0;
    int C2 = 0;

    public string LLOst;
    public string Start1Ost;
    public string Start2Ost;
    public string Combo1Ost;
    public string Combo2Ost;

    void Awake()
    {
        UM = FindObjectOfType<UIManager>();
        StartOST = Random.Range(1, 3);
    }

    // Start is called before the first frame update
    private void Start()
    {
        //if (StartOST == 1)
        //{
        //    FindObjectOfType<AudioManager>().Play(Start1Ost);
        //}
        //else if (StartOST == 2)
        //{
        //    FindObjectOfType<AudioManager>().Play(Start2Ost);
        //}
    }

    // Update is called once per frame
    void Update()
    {
        SetOST();
        if(UM.Lifes==0)
        {
            FindObjectOfType<AudioManager>().Stop(LLOst);
            FindObjectOfType<AudioManager>().Stop(Start1Ost);
            FindObjectOfType<AudioManager>().Stop(Start2Ost);
            FindObjectOfType<AudioManager>().Stop(Combo1Ost);
            FindObjectOfType<AudioManager>().Stop(Combo2Ost);
        }
    }

    void SetOST()
    {
        if(UM.Intensity==1)
        {
            if(UM.Lifes==1)
            {
                if(LL<1)
                {
                    FindObjectOfType<AudioManager>().Play(LLOst);
                    FindObjectOfType<AudioManager>().Stop(Start1Ost);
                    FindObjectOfType<AudioManager>().Stop(Start2Ost);
                    FindObjectOfType<AudioManager>().Stop(Combo1Ost);
                    FindObjectOfType<AudioManager>().Stop(Combo2Ost);
                    LL++;
                    S1 = 0;
                    S2 = 0;
                    C1 = 0;
                    C2 = 0;
                }
            }
            else if(UM.Lifes >= 1)
            {
                if(StartOST==1)
                {
                    if(S1<1)
                    {
                        FindObjectOfType<AudioManager>().Stop(LLOst);
                        FindObjectOfType<AudioManager>().Play(Start1Ost);
                        FindObjectOfType<AudioManager>().Stop(Start2Ost);
                        FindObjectOfType<AudioManager>().Stop(Combo1Ost);
                        FindObjectOfType<AudioManager>().Stop(Combo2Ost);
                        LL = 0;
                        S1++;
                        S2 = 0;
                        C1 = 0;
                        C2 = 0;
                    }
                }
                else if(StartOST==2)
                {
                    if(S2<1)
                    {
                        FindObjectOfType<AudioManager>().Stop(LLOst);
                        FindObjectOfType<AudioManager>().Stop(Start1Ost);
                        FindObjectOfType<AudioManager>().Play(Start2Ost);
                        FindObjectOfType<AudioManager>().Stop(Combo1Ost);
                        FindObjectOfType<AudioManager>().Stop(Combo2Ost);
                        LL = 0;
                        S1 = 0;
                        S2++;
                        C1 = 0;
                        C2 = 0;
                    }
                }
            }
        }
        else if(UM.Intensity==2)
        {
            if(C1<1)
            {
                FindObjectOfType<AudioManager>().Stop(LLOst);
                FindObjectOfType<AudioManager>().Stop(Start1Ost);
                FindObjectOfType<AudioManager>().Stop(Start2Ost);
                FindObjectOfType<AudioManager>().Play(Combo1Ost);
                FindObjectOfType<AudioManager>().Stop(Combo2Ost);
                LL = 0;
                S1 = 0;
                S2 = 0;
                C1++;
                C2 = 0;
            }
        }
        else if(UM.Intensity==3)
        {
            if(C2<1)
            {
                FindObjectOfType<AudioManager>().Stop(LLOst);
                FindObjectOfType<AudioManager>().Stop(Start1Ost);
                FindObjectOfType<AudioManager>().Stop(Start2Ost);
                FindObjectOfType<AudioManager>().Stop(Combo1Ost);
                FindObjectOfType<AudioManager>().Play(Combo2Ost);
                LL = 0;
                S1 = 0;
                S2 = 0;
                C1 = 0;
                C2++;
            }
        }
    }
}
