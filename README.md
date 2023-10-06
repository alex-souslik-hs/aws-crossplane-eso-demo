# AWS Crossplane ESO Demo
The chart depends on `external-secrets` and the Upbound `provider-aws-iam` Crossplane provider.
It deploys all the resources necessary for the creation of AWS Secret Manager backed Kubernetes secrets.
It's best used as a dependency for other charts that'll consume the secrets.

## Example of Usage
The following example shows the expected Secret Manager `Secret` structure:
> **Note** 
> the `data` list is converted to YAML directly and as such [all fields under it](https://external-secrets.io/latest/spec/#external-secrets.io/v1beta1.ExternalSecretData) are supported.
```yaml
aws:
  secretManager:
    enabled: true
    secrets:
      - name: <k8s-secret-name>
        data:
          - secretKey: <k8s-secret-key>
            remoteRef:
              key: <aws-secret-name>
              property: <aws-secret-key>
```
