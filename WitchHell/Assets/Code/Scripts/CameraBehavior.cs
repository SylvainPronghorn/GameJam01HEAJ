using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraBehavior : MonoBehaviour
{
    [SerializeField]
    private Transform mTargetPosition;
    [Range(0.0f, 1.0f)]
    [SerializeField]
    private float mSpeedLerp = 0.5f;

    private Transform mTransform;

    private void Awake()
    {
        mTransform = transform;
    }

    private void Update()
    {
        Vector3 targPos = mTargetPosition.position;
        Vector3 actPos = mTransform.position;
        Vector3 newPos = Vector3.Lerp(targPos, actPos, mSpeedLerp);
        mTransform.position = newPos;

    }

}
