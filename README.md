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

### Pointless Music Stuff
```
apt install ffmpeg
```

```
ffprobe site__assets_audio_cloudsmithin.mp3
```
