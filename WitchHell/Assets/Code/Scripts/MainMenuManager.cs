using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenuManager : MonoBehaviour
{

    [SerializeField]
    private GameObject mMainPanel;
    [SerializeField]
    private GameObject mCreditPanel;
    [SerializeField]
    private GameObject mSplashArtPanel;
    [SerializeField]
    private float mDurationSplashArt;

    private void Awake()
    {
        mSplashArtPanel.SetActive(true);
        mMainPanel.SetActive(false);
        mCreditPanel.SetActive(false);
        StartCoroutine(DeactivateSplashArt(mDurationSplashArt));
    }
    public void ActivateMainPanel()
    {
        mMainPanel.SetActive(true);
        mCreditPanel.SetActive(false);
        mSplashArtPanel.SetActive(false);
    }

    public void ActivateCreditPanel()
    {
        mMainPanel.SetActive(false);
        mCreditPanel.SetActive(true);
        mSplashArtPanel.SetActive(false);
    }

    public void LoadScene(int sceneIndex)
    {
        SceneManager.LoadScene(sceneIndex);
    }

    private IEnumerator DeactivateSplashArt(float waitTime)
    {
        yield return new WaitForSeconds(waitTime);
        ActivateMainPanel();
    } 

    public void QuitGame()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif
        Application.Quit();
    }
}
