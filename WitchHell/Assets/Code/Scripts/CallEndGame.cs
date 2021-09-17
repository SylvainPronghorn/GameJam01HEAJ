using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CallEndGame : MonoBehaviour
{
    GameManager mGameManager;

    private void Start()
    {
        mGameManager = GameManager.sInstance;
    }

    public void CallEnd() 
    {
        mGameManager.WinTheGame();
    }
}
