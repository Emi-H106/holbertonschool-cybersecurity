#!/bin/bash
mkdir -p /shared/devs
chgrp developers /shared/devs
chmod 775 /shared/devs
chmod g+s /shared/devs
chmod +t /shared/devs
