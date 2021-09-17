using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoinBehavior : MonoBehaviour
{
    [HideInInspector]
    public static CoinBehavior sInstance;
    
    [SerializeField]
    private GameObject mCoinObj;

    private void Start()
    {
        if(sInstance == null)
        {
            sInstance = this;
        }
        else
        {
            Destroy(gameObject);
        }
        HideCoinObj();
    }

    public void RevealCoinObj()
    {
        mCoinObj.SetActive(true);
    } 

    public void HideCoinObj()
    {
        mCoinObj.SetActive(false);
    }
}
