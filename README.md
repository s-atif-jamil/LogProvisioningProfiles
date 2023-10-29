# LogProvisioningProfiles
Log all Provisioning Profiles with their name, bundle-id, uuid and expiry-date from `~/Library/MobileDevice/Provisioning Profiles`. 

These profile's file name is `<<uuid>>.mobileprovision` so it is very hard to know which profile are expired or belong to which bundle-id.

It will print 4 lines for each profile:
1. Name of the profile
2. Id (bundle-id) of the profile
3. File-Name of the profile, which is the uuid of profile
4. Expiry-Date of the profile. Green for Non-Expired and Latest, Blue for Redundant i.e; It is not expired but it is old, Red for Expired.


## Usage/Examples
Open up Terminal, `cd` into your directory where did you download this `logProvisioningProfiles.sh`. Then type following command:

```bash
$ ./LogProvisioningProfiles.sh
```

## Background
I have morethan 100 mobileprovision files and around 70% were expired. Beside, I need to revert back my latest mobile provision profile to latest one. Because file name is uuid so it was very hard to find out the correct onw. So I wrote this bash script which move expired and redudant profiles on to Desktop. Hope it will be helpful to you :)
