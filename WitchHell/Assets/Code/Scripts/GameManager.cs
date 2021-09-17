using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager sInstance;

    public event EventHandler<EventArgs> OnGameWon;
    public event EventHandler<OnPauseCallEventArgs> OnPauseCalled;
    public class OnPauseCallEventArgs : EventArgs
    {
        public bool isPaused;
    }



    private bool mIsPaused;
    public bool IsPaused
    {
        get { return mIsPaused; }
    }

    private void Awake()
    {
        if(sInstance == null)
        {
            sInstance = this;
        }
        else
        {
            Destroy(gameObject);
        }
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.P) || Input.GetButtonDown("Start"))
        {
            PauseGame();
        }
    }

    public void CallPause()
    {
        PauseGame();
    }

    private void PauseGame()
    {
        Debug.Log("PauseGame");
        mIsPaused ^= true;
        OnPauseCalled?.Invoke(this, new OnPauseCallEventArgs { isPaused = mIsPaused });
        if (mIsPaused)
        {
            Time.timeScale = 0.0f;
        }
        else
        {
            Time.timeScale = 1.0f;
        }
    }

    public void WinTheGame()
    {
        OnGameWon?.Invoke(this, new EventArgs { } );
    }
}
