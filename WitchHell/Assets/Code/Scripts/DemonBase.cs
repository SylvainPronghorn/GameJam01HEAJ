using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class DemonBase : MonoBehaviour
{
    [SerializeField]
    private float mWaitBeforeGetPlayerScript = 0.8f;

    [Header("Looking At Player")]
    [SerializeField]
    private PlayerData mPlayerData;
    [SerializeField]
    private Transform mEyeTransform;
    [SerializeField]
    private float mHeightOfPlayer;

    [Header("Patrol")]
    [SerializeField]
    private Transform[] mPatrolPointsTransform;
    [SerializeField]
    private float mPatrolSpeed = 3.0f;
    [SerializeField]
    private float mDetectionRange = 10.0f;

    [Header("Chase")]
    [SerializeField]
    private float mChaseSpeed = 2.0f;
    [SerializeField]
    private float mCloseChaseSpeed = 3.3f;
    [SerializeField]
    private float mRangeAttackPlayer = 1.0f;
    [SerializeField]
    private float mRangeRunAfterPlayer = 3.0f;

    [Header("Animation")]
    [SerializeField]
    private Animator mAnimator;
    [SerializeField]
    private string mNameDisplacementFloat = "DisplacementBlend";
    [SerializeField]
    private float mIdleValue = 0.0f;
    [SerializeField]
    private float mWalkValue = 0.2f;
    [SerializeField]
    private float mRunValue = 0.75f;
    [SerializeField]
    private string mNameTriggerAttack = "Attack";

    [Header("Sounds")]
    [SerializeField]
    private AudioClip[] mAudioClips;
    [SerializeField]
    private AudioSource mAudioSource;

    private NavMeshAgent mAgent;
    [SerializeField]
    private RaycastHit mHitInfo;

    private PatrolPoint[] mPatrolPoints;
    private Vector3 mNextPatrolGoal;
    private int mPPcounter;
    private float mWaitduration;
    private bool mWaitingNewPath;
    private Player mPlayer;
    private bool mPlayerisHiding;
    private GameManager mGameManager;

    private enum Estate
    {
        Patrol,
        Idle,
        Chase,
        Count
    }
    private Estate mDemonState;

    private void Awake()
    {
        mAgent = GetComponent<NavMeshAgent>();
    }

    private void Start()
    {
        mDemonState = Estate.Count;
        if(mPatrolPointsTransform.Length > 0)
        {
            mPatrolPoints = new PatrolPoint[mPatrolPointsTransform.Length];
        }
        for (int i = 0;i < mPatrolPoints.Length; i++)
        {
            mPatrolPoints[i] = mPatrolPointsTransform[i].GetComponent<PatrolPoint>();
        }
        mPPcounter = 0;
        mNextPatrolGoal = mPatrolPointsTransform[mPPcounter].position;
        mAgent.SetDestination(mNextPatrolGoal);
        mWaitingNewPath = false;
        mPlayer = Player.sInstance;
        if(mPlayer != null)
        {
            mPlayerisHiding = false;
            mPlayer.OnHideCalled += OnPlayerHiding;
        }
        else
        {
            StartCoroutine(GetPlayerScript(mWaitBeforeGetPlayerScript));
        }
        mGameManager = GameManager.sInstance;
        if(mGameManager != null)
        {
            mGameManager.OnGameWon += GameIsWon;
        }
        SwitchState(Estate.Patrol);
    }

    private void Update()
    {
        UpdateState();
        if (!mAudioSource.isPlaying)
        {
            int random = UnityEngine.Random.Range(0, mAudioClips.Length);
            mAudioSource.clip = mAudioClips[random];
            mAudioSource.Play();
        }

    }


    #region State Methods
    private void SwitchState(Estate newstate)
    {
        Debug.Log("Demon switched state");
        OnExitState();
        mDemonState = newstate;
        OnEnterState();
    }

    private void OnEnterState()
    {
        switch (mDemonState)
        {
            case Estate.Patrol:
                mAnimator.SetFloat(mNameDisplacementFloat, mWalkValue);
                mAgent.speed = mPatrolSpeed;
                MoveToPP();
                break;
            case Estate.Chase:
                mAnimator.SetFloat(mNameDisplacementFloat, mWalkValue);
                mAgent.ResetPath();
                break;
            case Estate.Idle:
                mAnimator.SetFloat(mNameDisplacementFloat, mIdleValue);
                mAgent.ResetPath();
                break;
            case Estate.Count:
                break;
        }
    }
    private void UpdateState()
    {
        switch (mDemonState)
        {
            case Estate.Patrol:
                if (SeePlayer())
                {
                    SwitchState(Estate.Chase);
                }
                else
                {
                    MoveToPP();
                }
                break;
            case Estate.Chase:
                if (!SeePlayer())
                {
                    SwitchState(Estate.Patrol);
                }
                mAgent.SetDestination(mPlayerData.mPlayerPosition);
                break;
            case Estate.Idle:
                break;
            case Estate.Count:
                break;
        }
    }

    
    private void OnExitState()
    {
        switch (mDemonState)
        {
            case Estate.Patrol:
                break;
            case Estate.Chase:
                break;
            case Estate.Idle:
                break;
            case Estate.Count:
                break;
        }
    }
    #endregion

    private bool SeePlayer()
    {

        //Debug.Log("Entered See playerMethod");
        //Vector3 eyePos = mEyeTransform.position;
        //Vector3 playerPos = mPlayerData.mPlayerPosition;
        //playerPos = new Vector3(playerPos.x, playerPos.y + mHeightOfPlayer, playerPos.z);
        //Debug.Log("Pos : " + playerPos);

        //if (!Physics.Raycast(eyePos, playerPos, out mHitInfo))
        //{ 
        //    Debug.Log("See nothin'");
        //    return false;
        //}
        //else
        //{
        //    if (mHitInfo.transform.CompareTag("Player"))
        //    {
        //        Debug.Log("See Player");
        //        return true;
        //    }
        //    else
        //    {
        //        Debug.Log("See something, but not the player");
        //        return false;
        //    }

        //}
        if (mPlayerisHiding)
        {
            return false;
        }
        Vector3 eyePos = mEyeTransform.position;
        Vector3 playerPos = mPlayerData.mPlayerPosition;
        playerPos = new Vector3(playerPos.x, playerPos.y + mHeightOfPlayer, playerPos.z);
        float dist =  Vector3.Distance(eyePos, playerPos);
        
        
        if(dist < mRangeAttackPlayer)
        {
            mAnimator.SetTrigger(mNameTriggerAttack);
            //Launch Attack Anim
        }
        else if(dist < mRangeRunAfterPlayer)
        {
            mAnimator.SetFloat(mNameDisplacementFloat, mRunValue);
            mAgent.speed = mChaseSpeed;
        }


        if(dist<= mDetectionRange)
        {
            return true;
        }
        else
        {
            return false;
        }


    }


    private void MoveToPP()
    {
        //if(!mAgent.hasPath || mAgent.isStopped && !mWaitingNewPath)
        //{
        //    StartCoroutine(GetNewDestination(mWaitduration));
        //    mWaitingNewPath = true;
        //}
        if (!mAgent.pathPending)
        {
            if (mAgent.remainingDistance <= mAgent.stoppingDistance)
            {
                if (!mAgent.hasPath || mAgent.velocity.sqrMagnitude == 0f)
                {
                    StartCoroutine(GoToNewDestination(mWaitduration));
                    mPPcounter += 1;
                    if (mPPcounter > mPatrolPointsTransform.Length - 1)
                    {
                        mPPcounter = 0;
                    }
                    mNextPatrolGoal = mPatrolPointsTransform[mPPcounter].position;
                    mAgent.SetDestination(mNextPatrolGoal);
                    mWaitduration = mPatrolPoints[mPPcounter].mWaitDuration;
                    mAgent.isStopped = true;
                    mWaitingNewPath = true;
                }
            }
        }

    }

    private IEnumerator GoToNewDestination(float waitTime)
    {
        yield return new WaitForSeconds(waitTime);
        mAgent.isStopped = false;
        mWaitingNewPath = false;
    }


    private void OnPlayerHiding(object sender, Player.OnHideCalledEventArgs e)
    {
        mPlayerisHiding = e.isHiding;
        if (mPlayerisHiding) Debug.Log("Demon know player is hiding");
        else Debug.Log("Demon know player is not hiding");
    }

    private IEnumerator GetPlayerScript(float waitTime)
    {
        yield return new WaitForSeconds(waitTime);
        mPlayer = Player.sInstance;
        mPlayerisHiding = false;
        mPlayer.OnHideCalled += OnPlayerHiding;
    }

    private IEnumerator GoToIdleCoroutine(float waitTime)
    {
        yield return new WaitForSeconds(waitTime);
        SwitchState(Estate.Idle);
    }

    private void GameIsWon(object sender, EventArgs e)
    {
        SwitchState(Estate.Idle);
        StartCoroutine(GoToIdleCoroutine(0.5f));
    }

    //private void OnDrawGizmos()
    //{
    //    RaycastHit hitInfo;
    //    Vector3 eyePos = mEyeTransform.position;
    //    Vector3 playerPos = mPlayerData.mPlayerPosition;
    //    playerPos = new Vector3(playerPos.x, playerPos.y + mHeightOfPlayer, playerPos.z);
    //    if (Physics.Raycast(eyePos, playerPos, out hitInfo))
    //    {
    //        if (hitInfo.transform.CompareTag("Player"))
    //        {
    //            Debug.Log("See Player");
    //            Gizmos.color = Color.red;
    //        }
    //        else
    //        {
    //            Gizmos.color = Color.blue;
    //        }
    //    }
    //    Gizmos.DrawLine(eyePos, playerPos);
    //}


}
