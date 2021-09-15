using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    [SerializeField]
    private Transform mCenterOfMassRigidbody;
    [SerializeField]
    private float mSpeed = 50.0f;

    private Transform mTransform;
    private Rigidbody mRigidBody;

    private void Awake()
    {
        mTransform = transform;
        mRigidBody = GetComponent<Rigidbody>();
        //mRigidBody.centerOfMass = mCenterOfMassRigidbody.position;
    }

    private void Update()
    {
        Movement();
    }

    private void Movement()
    {
        Vector3 dirMov = Vector3.zero;
        
        if (Input.GetKey(KeyCode.UpArrow))
        {
            dirMov += Vector3.forward;
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            dirMov += - Vector3.forward;
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            dirMov += Vector3.right;
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            dirMov += - Vector3.right;
        }

        dirMov.Normalize();

        //mRigidBody.MovePosition(dirMov * mSpeed * Time.deltaTime);
        //mRigidBody.AddForce(dirMov * mSpeed * Time.deltaTime, ForceMode.Impulse);
        mTransform.position += dirMov * mSpeed * Time.deltaTime; 
    }

}
