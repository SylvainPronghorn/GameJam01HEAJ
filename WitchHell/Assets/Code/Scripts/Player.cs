using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    [Header("Movement")]
    //[SerializeField]
    //private Transform mCenterOfMassRigidbody;
    [SerializeField]
    private float mSpeed = 50.0f;
    [SerializeField]
    private PlayerData mPlayerData;

    [Header("Idle")]
    [SerializeField]
    private float mTimeInIdleState = 1.5f;


    private enum Estate
    {
        Idle,
        InPlay,
        Dying,
        Count
    }
    private Estate mPlayerstate;

    private Transform mTransform;
    private Rigidbody mRigidbody;
    private BoxCollider mBoxCollider;


    #region Unity Methods
    private void Awake()
    {
        mTransform = transform;
        mRigidbody = GetComponent<Rigidbody>();
        //mRigidBody.centerOfMass = mCenterOfMassRigidbody.position;
        //mBoxCollider = GetComponent<BoxCollider>();
        //mBoxCollider.isTrigger = true;
        //mBoxCollider.isTrigger = false;
    }

    private void Start()
    {
        mPlayerstate = Estate.Count;
        SwitchState(Estate.Idle);
    }

    private void Update()
    {
        UpdateState();
    }

    private void FixedUpdate()
    {
        FixedUpdateState();
    }
    #endregion

    #region State Methods
    private void SwitchState(Estate newState)
    {
        OnExitState();
        mPlayerstate = newState;
        OnEnterState();
    }

    private void OnEnterState()
    {
        switch (mPlayerstate)
        {
            case Estate.Idle:
                StartCoroutine(SwitchToStateCoroutine(mTimeInIdleState, Estate.InPlay));
                break;
            case Estate.InPlay:
                break;
            case Estate.Dying:
                break;
            case Estate.Count:
                break;
            default:
                break;
        }
    }
    private void UpdateState()
    {
        switch (mPlayerstate)
        {
            case Estate.Idle:
                break;
            case Estate.InPlay:
                break;
            case Estate.Dying:
                break;
            case Estate.Count:
                break;
            default:
                break;
        }
    }

    private void FixedUpdateState()
    {
        switch (mPlayerstate)
        {
            case Estate.Idle:
                break;
            case Estate.InPlay:
                Movement();
                break;
            case Estate.Dying:
                break;
            case Estate.Count:
                break;
            default:
                break;
        }
    }

    private void OnExitState()
    {
        switch (mPlayerstate)
        {
            case Estate.Idle:
                break;
            case Estate.InPlay:
                break;
            case Estate.Dying:
                break;
            case Estate.Count:
                break;
            default:
                break;
        }
    }
    #endregion

    private void Movement()
    {
        Vector3 dirMov = Vector3.zero;
        bool usedKeyboard = false;
        float horizontalIntensity = 0.0f;
        float verticalIntensity = 0.0f;
        
        if (Input.GetKey(KeyCode.UpArrow))
        {
            dirMov += Vector3.forward;
            usedKeyboard = true;
            verticalIntensity = 1.0f;
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            dirMov += - Vector3.forward;
            usedKeyboard = true;
            verticalIntensity = -1.0f;
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            dirMov += Vector3.right;
            usedKeyboard = true;
            horizontalIntensity = 1.0f;
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            dirMov += - Vector3.right;
            usedKeyboard = true;
            horizontalIntensity = -1.0f;
        }

        //mRigidBody.MovePosition(dirMov * mSpeed * Time.deltaTime);
        //mRigidBody.AddForce(dirMov * mSpeed * Time.deltaTime, ForceMode.Impulse);
        //mTransform.position += dirMov * mSpeed * Time.deltaTime;

        if (!usedKeyboard)
        {
            horizontalIntensity = Input.GetAxis("Horizontal"); // the horizontal Left Axis
            verticalIntensity = Input.GetAxis("Vertical");     // the vertical Left Axis

            Vector2 dir2D = new Vector2(horizontalIntensity, verticalIntensity); //for the animator
            float movementAmplitude = Mathf.Clamp01(dir2D.magnitude);


            dirMov = Vector3.forward * verticalIntensity + Vector3.right * horizontalIntensity;
        }
        dirMov.Normalize();

        mRigidbody.AddForce(dirMov * Time.fixedDeltaTime * mSpeed, ForceMode.VelocityChange);

        if (horizontalIntensity != 0.0f || verticalIntensity != 0.0f)
        {
            transform.rotation = Quaternion.Euler(new Vector3(0.0f, Mathf.Atan2(-verticalIntensity, horizontalIntensity) * Mathf.Rad2Deg + 90.0f, 0.0f));
        }

        GivePositionToScriptableObject();
    }

    private void GivePositionToScriptableObject()
    {
        mPlayerData.mPlayerPosition = transform.position;
    }

    private IEnumerator SwitchToStateCoroutine(float waitTime, Estate newState)
    {
        yield return new WaitForSeconds(waitTime);
        SwitchState(newState);
    }

}
