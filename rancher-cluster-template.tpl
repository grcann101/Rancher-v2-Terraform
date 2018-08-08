nodes:
  - address: ${ip-add1} # hostname or IP to access nodes
    user: rancher # root user (usually 'root')
    role: [controlplane,etcd,worker] # K8s roles for node
    ssh_key_path: ${key-path}rancherv2.pem # path to PEM file
  - address: ${ip-add2} # hostname or IP to access nodes
    user: rancher # root user (usually 'root')
    role: [controlplane,etcd,worker] # K8s roles for node
    ssh_key_path: ${key-path}rancherv2.pem # path to PEM file
  - address: ${ip-add3} # hostname or IP to access nodes
    user: rancher # root user (usually 'root')
    role: [controlplane,etcd,worker] # K8s roles for node
    ssh_key_path: ${key-path}rancherv2.pem # path to PEM file
addons: |-
  ---
  kind: Namespace
  apiVersion: v1
  metadata:
    name: cattle-system
  ---
  kind: ServiceAccount
  apiVersion: v1
  metadata:
    name: cattle-admin
    namespace: cattle-system
  ---
  kind: ClusterRoleBinding
  apiVersion: rbac.authorization.k8s.io/v1
  metadata:
    name: cattle-crb
    namespace: cattle-system
  subjects:
  - kind: ServiceAccount
    name: cattle-admin
    namespace: cattle-system
  roleRef:
    kind: ClusterRole
    name: cluster-admin
    apiGroup: rbac.authorization.k8s.io
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: cattle-keys-server
    namespace: cattle-system
  type: Opaque
  data:
    cacerts.pem: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNqRENDQWZXZ0F3SUJBZ0lKQVBVNTJuc1RVOVh5TUEwR0NTcUdTSWIzRFFFQkN3VUFNRjh4Q3pBSkJnTlYKQkFZVEFrZENNUk13RVFZRFZRUUlEQXBUYjIxbExWTjBZWFJsTVNFd0h3WURWUVFLREJoSmJuUmxjbTVsZENCWAphV1JuYVhSeklGQjBlU0JNZEdReEdEQVdCZ05WQkFNTUQyZHlaV1Z1YzJsc2JDNWpiRzkxWkRBZUZ3MHhPREExCk16RXhNVE01TWpoYUZ3MHhPVEExTXpFeE1UTTVNamhhTUY4eEN6QUpCZ05WQkFZVEFrZENNUk13RVFZRFZRUUkKREFwVGIyMWxMVk4wWVhSbE1TRXdId1lEVlFRS0RCaEpiblJsY201bGRDQlhhV1JuYVhSeklGQjBlU0JNZEdReApHREFXQmdOVkJBTU1EMmR5WldWdWMybHNiQzVqYkc5MVpEQ0JuekFOQmdrcWhraUc5dzBCQVFFRkFBT0JqUUF3CmdZa0NnWUVBdEFmdVpPN2dLa1dJS3Ewc2pPc0xZRWhOVWxjUGxhQ0Y5eU5jeU9xa1UzTXltUVFWc0xCT1JyVy8KNE5rTGpieGdmNFRicnp3dkFxY3BVdnpZd3E5aWtQRUxhZm10djVGS01tZy96cWxtcGNwaVdKZTdoSWR0NnVNQwoxZHBxNWVlZnptMmpYTllSdmpvRWpPYUwvYWlka08xbCt3WU9CdXI1djhheXZYbXVqUnNDQXdFQUFhTlFNRTR3CkhRWURWUjBPQkJZRUZLd0JYN1VqUjJGUjlZQWUyQXVsUXJPbzk5bkdNQjhHQTFVZEl3UVlNQmFBRkt3Qlg3VWoKUjJGUjlZQWUyQXVsUXJPbzk5bkdNQXdHQTFVZEV3UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ1lFQQpMOGdUcUIrZDJlYzhPR3NpaUlYYkNqZXlHTVp3MTI0SVJZL3lGMUxFak9iRXB0b3MveWlTV01TQzkvSk5KLzAxCjF5Qm1LaHdONldiTkV1TmtRUXdDd2V0d2lqY1p4djAySnhVS0doekxseTYrSDJWQjlFaW84WCtlcGVTRDlrenUKQnovdXlXeTQ4SklUWm5TZk1JWTdVRjQwTVBjVzBBWC9ZYWo0aXhzQU5Lcz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
  ---
  apiVersion: v1
  kind: Service
  metadata:
    namespace: cattle-system
    name: cattle-service
    labels:
      app: cattle
  spec:
    ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      name: http
    selector:
      app: cattle
  ---
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    namespace: cattle-system
    name: cattle-ingress-http
    annotations:
      nginx.ingress.kubernetes.io/proxy-connect-timeout: "30"
      nginx.ingress.kubernetes.io/proxy-read-timeout: "1800"   # Max time in seconds for ws to remain shell window open
      nginx.ingress.kubernetes.io/proxy-send-timeout: "1800"   # Max time in seconds for ws to remain shell window open
      nginx.ingress.kubernetes.io/ssl-redirect: "false"        # Disable redirect to ssl
  spec:
    rules:
    - host: ${FQDNS}
      http:
        paths:
        - backend:
            serviceName: cattle-service
            servicePort: 80
  ---
  kind: Deployment
  apiVersion: extensions/v1beta1
  metadata:
    namespace: cattle-system
    name: cattle
  spec:
    replicas: 1
    template:
      metadata:
        labels:
          app: cattle
      spec:
        serviceAccountName: cattle-admin
        containers:
        - image: rancher/rancher:latest
          imagePullPolicy: Always
          name: cattle-server
          ports:
          - containerPort: 80
            protocol: TCP
          volumeMounts:
          - mountPath: /etc/rancher/ssl
            name: cattle-keys-volume
            readOnly: true
        volumes:
        - name: cattle-keys-volume
          secret:
            defaultMode: 420
            secretName: cattle-keys-server
