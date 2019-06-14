using UnityEngine;



namespace CAMFG
{

    public class CameraPrototype : MonoBehaviour
    {

        #region Fields

        public Transform target;
        public float height = 5f;
        public float distance = 10f;
        public float angle = 45f;
        public float smoothSpeed = 0.5f;
        private Vector3 refVelocity;
        #endregion

        #region Unity methods
        void Update()
        {
            Vector3 worldPosition = (Vector3.forward * -distance) + (Vector3.up * height);
            Vector3 rotate = Quaternion.AngleAxis(angle, Vector3.up) * worldPosition;
            Vector3 flatTargetPosition = target.position;
            Vector3 finalPosition = flatTargetPosition + rotate;
            transform.position = Vector3.SmoothDamp(transform.position, finalPosition, ref refVelocity, smoothSpeed);
            transform.LookAt(flatTargetPosition);
        }

        private void OnDrawGizmosSelected()
        {
            Color oldColor = Gizmos.color;
            Gizmos.color = new Color(0.5f, 0f, 0f, 0.5f);

            if (target)
            {
                Gizmos.DrawLine(transform.position, target.position);
                Gizmos.DrawSphere(target.position, 1.5f);
            }
            Gizmos.DrawSphere(transform.position, 1.5f);

            Gizmos.color = oldColor;
        }
        #endregion
    }

}