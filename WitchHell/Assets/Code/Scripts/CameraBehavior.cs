using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraBehavior : MonoBehaviour
{
    [SerializeField]
    private PlayerData mPlayerData;
    [SerializeField]
    private Transform mTargetPosition;
    [Range(0.0f, 1.0f)]
    [SerializeField]
    private float mSpeedLerp = 0.5f;
    [Range(0.0f, 1.0f)]
    [SerializeField]
    private float mLerpRotation = 0.5f;
    [SerializeField]
    private float mZAdditionFromPlayer = -5.0f;
    [SerializeField]
    private float mYAdditionFromPlayer = 15.0f;
    [SerializeField]
    private Vector2 mMinMaxHorizontalInclinaison;
    [SerializeField]
    private Vector2 mMinMaxVerticlaInclinaison;
    [SerializeField]
    private float mSpeedInclinaison = 15.0f;


    private Transform mTransform;
    private float mBaseHorizontalInclinaison;
    private float mBaseVerticalInclinaison;

    private void Awake()
    {
        mTransform = transform;
        mBaseVerticalInclinaison = mTransform.rotation.eulerAngles.x;
        mBaseHorizontalInclinaison = mTransform.rotation.eulerAngles.y;
    }

    private void LateUpdate()
    {
        MoveCamera();
        //LookAtTarget();
        OrientCamera();
    }

    private void MoveCamera()
    {
        //Vector3 targPos = mTargetPosition.position;
        //Vector3 actPos = mTransform.position;
        //Vector3 newPos = Vector3.Lerp(targPos, actPos, mSpeedLerp);
        //mTransform.position = newPos;
        Vector3 pos = mPlayerData.mPlayerPosition;
        pos = new Vector3(pos.x, pos.y + mYAdditionFromPlayer, pos.z + mZAdditionFromPlayer);
        mTransform.position = Vector3.Lerp(mTransform.position, pos, mSpeedLerp);

    }

    //private void LookAtTarget()
    //{
    //    Quaternion ancRot = mTransform.rotation;
    //    mTransform.LookAt(mTargetPosition.position);
    //    Quaternion newRot = mTransform.rotation;
    //    newRot = Quaternion.Lerp(ancRot, newRot, mLerpRotation);
    //}

    private void OrientCamera()
    {
        float horizontalIntensity = 0.0f;
        float verticalIntensity = 0.0f;

        bool usedKeyboard = false;
        if (Input.GetKey(KeyCode.UpArrow))
        {
            usedKeyboard = true;
            verticalIntensity += 1.0f;
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            usedKeyboard = true;
            verticalIntensity -= 1.0f;
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            usedKeyboard = true;
            horizontalIntensity += 1.0f;
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            usedKeyboard = true;
            horizontalIntensity -= 1.0f;

        }
        if (!usedKeyboard)
        {
            horizontalIntensity = Input.GetAxis("Horizontal"); // the horizontal Left Axis
            verticalIntensity = Input.GetAxis("Vertical");     // the vertical Left Axis

        }

        Vector3 rot = mTransform.rotation.eulerAngles;
        float newVert = rot.x - (verticalIntensity * mSpeedInclinaison * Time.deltaTime);
        if(newVert < mBaseVerticalInclinaison + mMinMaxVerticlaInclinaison.x)
        {
            newVert = mBaseVerticalInclinaison + mMinMaxVerticlaInclinaison.x;
        }
        else if(newVert > mBaseVerticalInclinaison + mMinMaxVerticlaInclinaison.y)
        {
            newVert = mBaseVerticalInclinaison + mMinMaxVerticlaInclinaison.y;
        }
        float newHor = rot.z - (horizontalIntensity * mSpeedInclinaison * Time.deltaTime);
        if(newHor < mBaseHorizontalInclinaison + mMinMaxHorizontalInclinaison.x)
        {
            newHor = mBaseHorizontalInclinaison + mMinMaxHorizontalInclinaison.x;
        }
        else if(newHor > mBaseHorizontalInclinaison + mMinMaxHorizontalInclinaison.y)
        {
            newHor = mBaseHorizontalInclinaison + mMinMaxHorizontalInclinaison.y;
        }

        rot = new Vector3(newVert, rot.y, rot.z);
        Quaternion rotQuat = Quaternion.Euler(rot);
        mTransform.rotation = rotQuat;
    }

}
