#!/bin/bash

# get the root of the directory
REPO_ROOT=$(git rev-parse --show-toplevel)

# ensure that the command below is run from the root of the repository
cd "$REPO_ROOT"

export NXF_VER=21.04.1

# bin/nextflow \
#   run . \
#   -main-script src/joint_embedding/workflows/censor_datasets/main.nf \
#   --datasets 'output/public_datasets/common/**.h5ad' \
#   --publishDir output/public_datasets/joint_embedding/ \
#   -resume


bin/nextflow \
  run . \
  -main-script src/joint_embedding/workflows/censor_datasets/main.nf \
  --datasets 'output/datasets/common/**.h5ad' \
  --publishDir output/datasets/joint_embedding/ \
  -resume


bin/nextflow \
  run . \
  -main-script src/joint_embedding/workflows/censor_datasets/main.nf \
  --datasets 'output/datasets_2021-11-08/common/**.h5ad' \
  --publishDir output/datasets_2021-11-08/joint_embedding/ \
  -resume \
  -c src/common/workflows/resource_labels_vhighmem.config \
  --censor_dataset__seed $SEED_SECRET


