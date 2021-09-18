using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class PlayRandomSound : ScriptedAnimationBehaviour
{
    public AudioClip[] audioClips;
    public Vector2 randomPitchRange = new Vector2(0.9f, 1.1f);

    private AudioSource _audioSourceComponent;
    private bool _useAudio;

    public override void Awake()
    {
        base.Awake();
        _audioSourceComponent = GetComponent<AudioSource>();
    }

    private void OnEnable()
    {
        _useAudio = true;
    }

    private void OnDisable()
    {
        _useAudio = false;
    }

    private void PlayRandomClip(AudioClip[] audioClips, Vector2 pitchRange)
    {
        if (audioClips.Length > 0)
        {
            _audioSourceComponent.Stop();
            int clipID = Mathf.RoundToInt(Random.Range(0.0f, (float)audioClips.Length - 1.0f));
            _audioSourceComponent.clip = audioClips[clipID];
            _audioSourceComponent.pitch = Random.Range(pitchRange.x, pitchRange.y);
            _audioSourceComponent.Play();
        }
    }

    public void PlaySound()
    {
        if(_useAudio)
        {
            PlayRandomClip(audioClips, randomPitchRange);
        }
    }

    

}
