using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoinDetectPlayer : MonoBehaviour
{
    CoinBehavior mCoinInstance;

    private void Start()
    {
        mCoinInstance = CoinBehavior.sInstance;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            mCoinInstance.RevealCoinObj();
        }
    }
}
