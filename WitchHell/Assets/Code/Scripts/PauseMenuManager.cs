using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PauseMenuManager : MonoBehaviour
{
    [SerializeField]
    private GameObject mPausePanel;
    [SerializeField]
    private GameObject mEndGamePanel;

    private GameManager mGameManager;

    private void Start()
    {
        if(GameManager.sInstance != null)
        {
            mGameManager = GameManager.sInstance;
            mGameManager.OnPauseCalled += PauseCalled;
            mGameManager.OnGameWon += EndCalled;
        }
        mPausePanel.SetActive(false);
        mEndGamePanel.SetActive(false);
    }

    private void PauseCalled(object sender, GameManager.OnPauseCallEventArgs e)
    {
        ActivatePanel(e.isPaused);
    }

    private void EndCalled(object sender, EventArgs e)
    {
        ActivateEndPanel();
    }

    private void ActivatePanel(bool isPaused)
    {
        mPausePanel.SetActive(isPaused);
    }

    private void ActivateEndPanel()
    {
        mEndGamePanel.SetActive(true);
    }

    public void CallPause()
    {
        if(mGameManager != null)
        {
            mGameManager.CallPause();
        }
    }

    public void LoadScene(int levelIndex)
    {
        SceneManager.LoadScene(levelIndex);
    }

}
