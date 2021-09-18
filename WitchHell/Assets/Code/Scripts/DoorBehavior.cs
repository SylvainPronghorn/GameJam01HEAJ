using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoorBehavior : MonoBehaviour
{
    [SerializeField]
    private BoxCollider mBoxCollider;
    private Player mPlayer;

    private void Start()
    {
        mPlayer = Player.sInstance;
        mPlayer.OnHideCalled += HideCollider;
    }


    private void HideCollider(object sender, Player.OnHideCalledEventArgs e)
    {
        mBoxCollider.enabled = !e.isHiding;
    }

}
