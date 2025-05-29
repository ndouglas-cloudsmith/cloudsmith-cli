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

For example, you can remove a tag that was incorrectly assigned:
```
cloudsmith tags remove acme-corporation/acme-repo-one/spotipy-2250-py3-none-anywhl-pgk6 flag-kqE7a0Mr5Yld -k "$CLOUDSMITH_API_KEY"
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
```
cloudsmith quarantine remove acme-corporation/acme-repo-one/AVcNRPG0ILFP
```

![Screenshot 2025-05-06 at 11 21 14](https://github.com/user-attachments/assets/55e5afdc-18c5-473f-a31b-d8c5114f6282)


## Steganography Stuff

```
#!/bin/bash

# Create a binary file of 500 bytes filled with random data
head -c 500 /dev/urandom > bark-of-the-beast.bin

# Embed 4 flags at different byte offsets
printf 'flag-G2W7YkBBPCn103ww' | dd of=bark-of-the-beast.bin bs=1 seek=100 conv=notrunc
printf 'flag-X9Y8Z7W6V5U4T3S2' | dd of=bark-of-the-beast.bin bs=1 seek=200 conv=notrunc
printf 'flag-JKLMNOPQRSTUVWX' | dd of=bark-of-the-beast.bin bs=1 seek=300 conv=notrunc
printf 'flag-A1B2C3D4E5F6G7H8' | dd of=bark-of-the-beast.bin bs=1 seek=400 conv=notrunc
```

If the flag is embedded plainly (as in your original script)
<br/> You can extract it using:
```
strings bark-of-the-beast.bin | grep 'flag-'
```
This works because:
1. strings pulls out printable ASCII sequences.
2. The flag is embedded in cleartext at a known offset (e.g., byte 200).


### If the flag is embedded in pieces or broken by null bytes
strings won't help directly since it breaks on non-printables (\x00, etc.). <br/>
You can use xxd or hexdump to visually inspect the file:

```
xxd -s 200 -l 32 bark-of-the-beast.bin
xxd bark-of-the-beast.bin | less
```

Then look around the known offsets (e.g., 57, 123, 299) for parts of the flag. If it's split, you'll see it as:
```
00000039: 66 6c 61 67 00 41 31 42 32 00 43 33 44 34 00 45  flag.A1B2.C3D4.E
```

Push it to Cloudsmith
```
cloudsmith push raw acme-corporation/acme-repo-one bark-of-the-beast.bin -k "$CLOUDSMITH_API_KEY"
```

```
apt install ffmpeg
```

```
ffprobe site__assets_audio_cloudsmithin.mp3
```

```
curl -s -X GET "https://api.cloudsmith.io/v1/packages/acme-corporation/acme-repo-one/"   -H "Accept: application/json"   -H "X-Api-Key: $API_KEY" |   jq '.[] | select(any(.tags.info[]?; test("latest")))'
```

## Bulk Package Download

Download 30 copies of the same file
```
wget https://raw.githubusercontent.com/ndouglas-cloudsmith/cloudsmith-cli/refs/heads/main/download-copies.sh
```
Make the file executable
```
chmod +x download-copies.sh
```
Run the bulk download script
```
./download-copies.sh
```

### Bulk Push
Bulk push all the recently downloaded artifacts to Cloudsmith:
```
wget https://raw.githubusercontent.com/ndouglas-cloudsmith/cloudsmith-cli/refs/heads/main/bulk-push.sh
chmod +x bulk-push.sh
./bulk-push.sh
```

To search for all python packages larger than 2KB with more than 50 downloads:
```
cloudsmith list packages cloudsmith/examples -q "format:python AND downloads:>50 AND size:>2048"
```

![cloudsmith](https://github.com/user-attachments/assets/8b6b96ed-fee2-4c65-bc5a-12d26903397c)



### Bulk Cleanup
Download the package cleanup script
```
wget https://raw.githubusercontent.com/ndouglas-cloudsmith/cloudsmith-cli/refs/heads/main/cleanup.sh
chmod +x cleanup.sh
./cleanup.sh
```
Clean the old files from your desktop
```
rm -v ~/*.whl
```

## Helm Stuff
```
cloudsmith list packages acme-corporation/acme-repo-one -k "$CLOUDSMITH_API_KEY"
```
```
helm create nigel-sample-chart
```
```
helm package nigel-sample-chart
```
```
tar -tzf nigel-sample-chart-0.1.0.tgz
```
```
cloudsmith push helm acme-corporation/acme-repo-one nigel-sample-chart-0.1.0.tgz -k "$CLOUDSMITH_API_KEY"
```
Check status of the package [Optional]
```
cloudsmith status acme-corporation/acme-repo-one/nigel-sample-chart-010tgz-yefa -k "$CLOUDSMITH_API_KEY"
```

## Embed Rego policy into a JSON payload file (self-contained policy-as-data)
My goal is to store and transmit the policy with metadata (like through an API). <br/>
I created a self-contained JSON file with the Rego policy embedded as a string.

```
wget https://raw.githubusercontent.com/ndouglas-cloudsmith/cloudsmith-cli/refs/heads/main/license.rego
```

You can generate this with a shell script:
```
escaped_policy=$(jq -Rs . < license.rego)

cat <<EOF > policy_with_payload.json
{
  "name": "ea-workflow2",
  "description": "Flag any package with a GPL License used in production",
  "rego": $escaped_policy,
  "enabled": true,
  "is_terminal": false,
  "precedence": 2
}
EOF
```

### Use the policy_with_payload.json in an API call to create a policy

```
curl -X POST "https://api.cloudsmith.io/v2/orgs/acme-corporation/policies/" \
  -H "Content-Type: application/json" \
  -H "X-Api-Key: $CLOUDSMITH_API_KEY" \
  -d @policy_with_payload.json | jq .
```

You can extract the **slug_perm** value from the JSON output using **jq** and then export it as an environment variable in a single command like this:
```
export SLUG_PERM=$(curl -s -X GET "https://api.cloudsmith.io/v2/orgs/acme-corporation/policies/" -H "X-Api-Key: $CLOUDSMITH_API_KEY" | jq -r '.results[0].slug_perm')
```

Attach a tagging action:
```
curl -X POST "https://api.cloudsmith.io/v2/orgs/acme-corporation/policies/$SLUG_PERM/actions/" \
  -H "Content-Type: application/json" \
  -H "X-Api-Key: $CLOUDSMITH_API_KEY" \
  -d '{
    "action_type": "AddPackageTags",
    "precedence": 32767,
    "tags": ["non-compliant-license"]
  }'
```

GNU Lesser General Public License v3 permits you to use, modify, and distribute the software, even in proprietary applications, provided that any modifications to the LGPL-covered components are also licensed under the LGPL. It's a common choice for libraries intended to be used within other software.
```
pip download python-gitlab==3.1.1
```
Upload to Cloudsmith to see if the package is correctly quarantined:
```
cloudsmith push python acme-corporation/acme-repo-one python_gitlab-3.1.1-py3-none-any.whl -k "$CLOUDSMITH_API_KEY"  --tags workflow2
```

Let's see if the packages was assigned the new tags:
```
cloudsmith list packages acme-corporation/acme-repo-one -k "$CLOUDSMITH_API_KEY" -q "format:python AND tag:workflow2"
```
