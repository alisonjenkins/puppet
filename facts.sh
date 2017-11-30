#!/bin/bash
puppet facts --modulepath modules --hiera_config hiera.yaml manifests/site.pp
