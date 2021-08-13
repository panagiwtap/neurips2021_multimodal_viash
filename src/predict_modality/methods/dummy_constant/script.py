import anndata
import scipy.spatial
from scipy.sparse import csr_matrix
import numpy as np

# VIASH START
par = {
    "input_train_mod1": "../../../../resources_test/predict_modality/test_resource.train_mod1.h5ad",
    "input_test_mod1": "../../../../resources_test/predict_modality/test_resource.test_mod1.h5ad",
    "input_train_mod2": "../../../../resources_test/predict_modality/test_resource.train_mod2.h5ad",
    "output": "../../../../resources_test/predict_modality/test_resource.prediction.h5ad",
}
# VIASH END

# load dataset to be censored
ad_rna_train = anndata.read_h5ad(par["input_train_mod1"])
ad_rna_test = anndata.read_h5ad(par["input_test_mod1"])
ad_mod2 = anndata.read_h5ad(par["input_train_mod2"])


# Find the correct shape
mean = np.array(ad_mod2.X.mean(axis=0)).flatten()
prediction = np.tile(mean, (ad_rna_test.shape[0], 1))

# Write out prediction
out = anndata.AnnData(
    X=prediction,
    uns={
        "dataset_id": ad_mod2.uns["dataset_id"],
        "method_id": "dummy_constant",
    }
)
out.write_h5ad(par["output"])
