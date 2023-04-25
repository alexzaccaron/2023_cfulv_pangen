# 6. *C. fulvum* has multiple dispensable chromosomes, one of which carries pseudogenized copies of candidate effector genes.

## Identification of gene flow between core and accessory chromosomes
To identify potential gene gene flow between core and accessory chromosomes, a Snakemake workflow in the `scripts/Snakefile` was used. Basically it:
* Hard masks tranposable elements in the dispensable chromosomes.
* Queries the dispensable chromosomes with BLASTn against the full genome.
* Removes BLASTn hits of the dispensable chromosomes against themselves.
* Identifies genes that intersect with regions of the dispensable chromosomes that had a BLASTn hit.

