using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PauseMenuManager : MonoBehaviour
{
    [SerializeField]
    private GameObject mPausePanel;

    private GameManager mGameManager;

    private void Start()
    {
        if(GameManager.sInstance != null)
        {
            mGameManager = GameManager.sInstance;
            mGameManager.OnPauseCalled += PauseCalled;
        }
    }

    private void PauseCalled(object sender, GameManager.OnPauseCallEventArgs e)
    {
        ActivatePanel(e.isPaused);
    }

    private void ActivatePanel(bool isPaused)
    {
        mPausePanel.SetActive(isPaused);
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
