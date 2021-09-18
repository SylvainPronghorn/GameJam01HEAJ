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
    [SerializeField]
    private GameObject mTutoPanel;
    [SerializeField]
    private float mDurationTutoPanel;
    [SerializeField]
    private AudioSource mOnClickSound;

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
        mTutoPanel.SetActive(true);
        StartCoroutine(DisableTutoPanel(mDurationTutoPanel));
        mOnClickSound.Stop();
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

    private IEnumerator DisableTutoPanel(float waitTime)
    {
        yield return new WaitForSeconds(waitTime);
        mTutoPanel.SetActive(false);
    }

    public void OnClickActivateSound()
    {
        mOnClickSound.Stop();
        mOnClickSound.Play();
    }
}
