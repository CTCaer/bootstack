#!/bin/bash

docker image build -t alizkan/l4t-bootfiles-misc:latest "$(dirname "$(dirname "$(dirname "$(readlink -f $0)")")")"
