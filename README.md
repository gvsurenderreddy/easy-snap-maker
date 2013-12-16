AWS Easy Snapshot Maker (ESM)
=============================
### Automates the Amazon Web Services (AWS) snapshot creation process, also lists snapshots and volumes
Copyright (c) 2013 Jon Retting

Pre-Alpha v0.03

NON-FUNCTIONING

INFO:
-----
<tag-name> is the value of the "Name" tag given to your volume or instance (without <>)
<tag-name> required else if --list or --volumes is envoked
If tag-name is " - " asumes stdin piped for <tag-name>
Requires: $AWS_ACCESS_KEY, $AWS_SECRET_KEY, and $JAVA_HOME environmental variables bet set
Dependencies: AWS CLI Tools"

USAGE:
------
`create-snap.sh [-L | -V] | <tag-name> [-r region] [-a=N] [-idpqvh]`

OPTIONS:
--------
    -r    --region       AWS Region (required if $EC2_URL env var is not set)
    -L    --list         List snapshots (stdout=tag-name/snap-id/date-created)
    -V    --volumes      List volumes (stdout=tag-name/vol-id/mount-state/instance-id)
    -i    --instance     Lookup tag-name against Instances selects root vol for snapshot
    -a=N  --archive=N    Keep N snapshots removes snaps>N old (default=0)
    -d    --dryrun       Do a test run without making changes
    -p    --prompt       Prompts to continue/cancel after each execution process
    -q    --quiet        Dont output anything to stdout
    -E    --email        Email job start and completion or failure information
    -F    --fail         Exit script with error on all warning (default=continue)
    -v    --verbose      Output more information
    -h    --help         Display this cruft
          --version      Show version info

EXAMPLES:
---------
Creates a snapshot from the Volume with the Tag:Name "my-snap-tag" in us-west-1 region and removes snapshots with the same tag keeping only the last two.

`./create-snap.sh my-snap-tag -r us-west-1 -a 2`