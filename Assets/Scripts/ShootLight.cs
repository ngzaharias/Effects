using UnityEngine;
using System.Collections;

public class ShootLight : MonoBehaviour {

    new public GameObject light = null;
    public float force = 100.0f;

	// Update is called once per frame
	void Update () 
    {
        if (Input.GetMouseButtonDown(0))
            SpawnLight();
	}

    void SpawnLight()
    {
        GameObject obj = Instantiate(light, transform.position, transform.rotation) as GameObject;
        obj.GetComponent<Rigidbody>().AddForce(transform.forward * force);
    }
}
