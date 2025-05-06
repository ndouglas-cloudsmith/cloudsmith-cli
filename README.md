# cloudsmith-cli
Basic commands for using Cloudsmith CLI effectively

```
export CLOUDSMITH_API_KEY=
```


Step 1: Download and extract the Helm chart
```
curl -LO https://charts.bitnami.com/bitnami/nginx-15.5.2.tgz
mkdir -p nginx && tar -xzf nginx-15.5.2.tgz -C nginx
```

Step 2: Push to Cloudsmith
```
cloudsmith push helm acme-corporation/acme-repo-one nginx-15.5.2.tgz -k "$CLOUDSMITH_API_KEY"
```

Step 3: Confirm that your package was successfully uploaded to Cloudsmith:
```
cloudsmith list packages acme-corporation/acme-repo-one
```

Step 4: Check to see if any tags have been added to your package:
```
cloudsmith tags list acme-corporation/acme-repo-one/<package-name>
```

Step 5: Add some tags that uniquely describe your dog: <br/>
For the below example, I added ```happy``` and ```hungry```, but you can add whatever best describes your dog:
```
cloudsmith tags add acme-corporation/acme-repo-one/<package-name> happy,hungry -k "$CLOUDSMITH_API_KEY"
```

Step 6: Let's see the full SBOM (Software Bill of Materials) for our newly-updated artifact:
```
cloudsmith list packages acme-corporation/acme-repo-one -F pretty_json | jq --arg name "nginx" '.data[] | select(.display_name == $name)'
```

![Screenshot 2025-05-06 at 09 58 02](https://github.com/user-attachments/assets/4bffa8cb-426a-40e5-9081-da101d21c86d)


From here you can find the ```slug_perm``` value for synchronizing our package:
```
cloudsmith resync acme-corporation/acme-repo-one/AVcNRPG0ILFP
```

![Screenshot 2025-05-06 at 09 57 38](https://github.com/user-attachments/assets/79977e5b-3d65-49ce-9fcf-f52cb0d41c57)

If the package contains unwanted CVEs you can quarantine it immediately:
```
cloudsmith quarantine add acme-corporation/acme-repo-one/AVcNRPG0ILFP
```

## Moving Forward

