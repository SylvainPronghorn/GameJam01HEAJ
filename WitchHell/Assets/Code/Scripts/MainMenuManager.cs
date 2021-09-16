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

    public void ActivateMainPanel()
    {
        mMainPanel.SetActive(true);
        mCreditPanel.SetActive(false);
    }

    public void ActivateCreditPanel()
    {
        mMainPanel.SetActive(false);
        mCreditPanel.SetActive(true);
    }

    public void LoadScene(int sceneIndex)
    {
        SceneManager.LoadScene(sceneIndex);
    }

    public void QuitGame()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif
        Application.Quit();
    }
}
