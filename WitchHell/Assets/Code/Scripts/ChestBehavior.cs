using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChestBehavior : MonoBehaviour
{
    [SerializeField]
    private Animator mAnimator;
    [SerializeField]
    private string mNameTriggerOpening = "Opening";


    private Player mPlayer;


    private void Start()
    {
        mPlayer = Player.sInstance;
    }

    public void GiveCoinToPlayer()
    {
        Debug.Log("Give coin called");
        mPlayer.GetCoin();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            mAnimator.SetTrigger(mNameTriggerOpening);
        }
    }
}
