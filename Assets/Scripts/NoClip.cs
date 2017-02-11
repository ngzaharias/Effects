using UnityEngine;
using System.Collections;

public class NoClip : MonoBehaviour {

    public float speed = 1.0f;

	// Update is called once per frame
	void Update () 
    {
        Vector3 direction = Vector3.zero;
        if (Input.GetKey(KeyCode.W))
            direction += transform.forward;
        if (Input.GetKey(KeyCode.S))
            direction += -transform.forward;
        if (Input.GetKey(KeyCode.A))
            direction += -transform.right;
        if (Input.GetKey(KeyCode.D))
            direction += transform.right;
        if (Input.GetKey(KeyCode.E))
            direction += transform.up;
        if (Input.GetKey(KeyCode.Q))
            direction += -transform.up;

        transform.position = transform.position + (direction * speed * Time.deltaTime);
	}
}
