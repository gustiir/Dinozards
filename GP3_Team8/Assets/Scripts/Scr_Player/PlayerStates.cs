using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerStates : MonoBehaviour
{
    #region Fields

    Animator animator;

    public enum PossibleStates { IsNormal, IsDashing, IsReflecting, IsShooting, GotHit, GotStunned};

    public PossibleStates currentState = PossibleStates.IsNormal;

    #endregion Fields


    void Start() {

        animator = GetComponent<Animator>();
        SetStateTo(PossibleStates.IsNormal);

    }

    private void OnEnable()
    {
        animator = GetComponent<Animator>();
        SetStateTo(PossibleStates.IsNormal);
    }
    //---------------------------------------------------
    // Returns if it is certain state

    public bool IsState(PossibleStates stateToCheck) {

        return animator.GetBool(stateToCheck.ToString());
    }

    //---------------------------------------------------
    // Returns Current State Enum. 

    public PossibleStates GetCurrentState()
    {
        return currentState;
    }

    //---------------------------------------------------
    // Sets State and Animator Controller bool true and the rest of the bools to false

    public void SetStateTo(PossibleStates stateToSet) {
        
        for (int i = 0; i < animator.parameterCount; i++) {

            if (animator.GetParameter(i).name == stateToSet.ToString()) {

                animator.SetBool(stateToSet.ToString(), true);
                currentState = stateToSet;
            }

            else {
                
                // If it is a Bool then sets it to false. So it doesn't try to set the Speed Variable
                if (animator.GetParameter(i).type == AnimatorControllerParameterType.Bool) {

                         animator.SetBool(animator.GetParameter(i).name, false);
                 }
            }
        }
    }
}
