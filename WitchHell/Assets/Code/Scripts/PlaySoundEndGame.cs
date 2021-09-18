using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlaySoundEndGame : MonoBehaviour
{
    [SerializeField]
    private AudioSource mEndGameSound;


    private void Start()
    {
        mEndGameSound.Stop();
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            mEndGameSound.Play();
        }
    }
}
