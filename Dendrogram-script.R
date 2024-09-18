#For dendrogram
library(ape)
library(readxl)
distance_matrix <- as.matrix(read_excel("D:/R workspace/snpdistmatrix.xlsx"))
rownames(distance_matrix) <- distance_matrix[,1]
distance_matrix <- distance_matrix[,-1]
distance_matrix <- apply(distance_matrix, 2, as.numeric)
dist_matrix <- as.dist(distance_matrix)
hc <- hclust(dist_matrix, method = "average")
plot(hc)

#For conversion of snp dis matrix into newick file for iTOL
tree <- nj(dist_matrix)
write.tree(tree, file="core_snps_tree_file.newick")
