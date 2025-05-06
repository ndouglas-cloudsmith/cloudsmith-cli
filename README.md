# cloudsmith-cli
Basic commands for using Cloudsmith CLI effectively

```
export CLOUDSMITH_API_KEY=
```
```
DOG_NAME="sadie"
```


Step 1: Download and extract the Helm chart
```
curl -LO https://charts.bitnami.com/bitnami/nginx-15.5.2.tgz
mkdir -p nginx && tar -xzf nginx-15.5.2.tgz -C nginx
```

Step 2: Update the Chart.yaml version
```
sed -i "s/^name: nginx/name: ${DOG_NAME}/" nginx/nginx/Chart.yaml
sed -i "s/^version: 15.5.2/version: 0.1.0/" nginx/nginx/Chart.yaml
```

Step 3: Repackage the chart with the new version and dog name
```
helm package nginx/nginx --destination . --app-version 0.1.0 --version 0.1.0
mv "${DOG_NAME}-0.1.0.tgz" "${DOG_NAME}.tgz"
```

Step 4: Push to Cloudsmith
```
cloudsmith push helm acme-corporation/acme-repo-one "${DOG_NAME}.tgz" -k "$CLOUDSMITH_API_KEY"
```

Step 5: Confirm that your Doggie was successfully uploaded to Cloudsmith:
```
cloudsmith list packages acme-corporation/acme-repo-one
```

Step 6: Check to see if any tags have been added to your package:
```
cloudsmith tags list acme-corporation/acme-repo-one/<package-name>
```

Step 7: Add some tags that uniquely describe your dog: <br/>
For the below example, I added ```happy``` and ```hungry```, but you can add whatever best describes your dog:
```
cloudsmith tags add acme-corporation/acme-repo-one/<package-name> happy,hungry -k "$CLOUDSMITH_API_KEY"
```

Step 8: Let's see the full SBOM (Software Bill of Materials) for our newly-updated artifact:
```
cloudsmith list packages acme-corporation/acme-repo-one -F pretty_json | jq --arg name "$DOG_NAME" '.data[] | select(.display_name == $name)'
```


## Moving Forward

