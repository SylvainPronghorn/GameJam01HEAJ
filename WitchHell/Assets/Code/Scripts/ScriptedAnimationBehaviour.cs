using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Animator))]
public class ScriptedAnimationBehaviour : MonoBehaviour
{
    public Animator _animatorController;

    public virtual void Awake()
    {
        _animatorController = GetComponent<Animator>();
    }

    public virtual void ResetTrigger(string triggerName)
    {
        _animatorController.ResetTrigger(triggerName);
    }
}
