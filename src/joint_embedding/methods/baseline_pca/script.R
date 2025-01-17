cat("Loading dependencies\n")
options(tidyverse.quiet = TRUE)
library(tidyverse)
requireNamespace("anndata", quietly = TRUE)
library(Matrix, warn.conflicts = FALSE, quietly = TRUE)

## VIASH START
# path <- "resources_test/joint_embedding/openproblems_bmmc_multiome_starter/openproblems_bmmc_multiome_starter."
path <- "output/datasets/joint_embedding/openproblems_bmmc_multiome_phase1/openproblems_bmmc_multiome_phase1.censor_dataset.output_"
# path <- "output/public_datasets/joint_embedding/dyngen_citeseq_1/dyngen_citeseq_1.censor_dataset.output_"
par <- list(
  input_mod1 = paste0(path, "mod1.h5ad"),
  input_mod2 = paste0(path, "mod2.h5ad"),
  output = "output.h5ad",
  n_dims = 4L,
  hvg_sel = 1000L
)
meta <- list(functionality_name = "foo")
## VIASH END

cat("Reading h5ad files\n")
input_mod1 <- anndata::read_h5ad(par$input_mod1)

rn <- rownames(input_mod1)
batch <- input_mod1$obs$batch
dataset_id <- input_mod1$uns[["dataset_id"]]
X_mod1 <- input_mod1$X

# select hvg
if (!is.null(par$hvg_sel) && ncol(X_mod1) > par$hvg_sel) {
  sd_mod1 <- proxyC::colSds(X_mod1)
  X_mod1 <- X_mod1[, head(order(sd_mod1, decreasing = TRUE), par$hvg_sel)]
}

rm(input_mod1)
gc()

X_mod2 <- anndata::read_h5ad(par$input_mod2)$X
if (!is.null(par$hvg_sel) && ncol(X_mod2) > par$hvg_sel) {
  sd_mod2 <- proxyC::colSds(X_mod2)
  X_mod2 <- X_mod2[, head(order(sd_mod2, decreasing = TRUE), par$hvg_sel)]
}

cat("Performing DR\n")
dr <- irlba::prcomp_irlba(
  cbind(X_mod1, X_mod2),
  n = par$n_dims
)$x

rownames(dr) <- rn
colnames(dr) <- paste0("comp_", seq_len(par$n_dims))

out <- anndata::AnnData(
  X = dr,
  uns = list(
    dataset_id = dataset_id,
    method_id = meta$functionality_name
  )
)

cat("Writing predictions to file\n")
zzz <- out$write_h5ad(par$output, compression = "gzip")
