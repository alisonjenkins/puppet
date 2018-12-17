#!/bin/bash
puppet apply --modulepath modules --hiera_config hiera.yaml --noop --test manifests/site.pp