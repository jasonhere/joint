%% Step 2: Joint Spectral Decomposition
% After computing single-subject affinity (adjacency) matrices for a given
% population (or a subgroup), apply spectral decomposition to generate
% joint eigenvectors, which can be fed into a clustering algorithm.

%% Set parameters
hem             = 'L'; % Which hemisphere?
nVertices       = 29696; % Number of cortical vertices
subjects        = 1:1:20; % Subject numbers of the first set;
kMax            = 200; % Number of eigenvectors that will be kept for clustering
saveOutput      = 1; % Save the output matrix?
nSubjects       = length(subjects); % Number of total subjects
KArray          = 1:100; % Set of total subjects, ordered. Should be set
% to the size of the WW matrix. Used to determine which matrices will be 
% extracted out of the WW matrix.

% Load the WW matrix computed via Multi_layer_graph_generation
load(['WW_' hem], 'WW');

WW(setdiff(KArray,subjects),:) = [];
WW(:,setdiff(KArray,subjects)) = [];

% Joint spectral decomposition
Wmulti = cellWW_to_sparse( WW, 1, nSubjects );
Lmulti = compute_laplacian( Wmulti, 0 ); 
[eigenVectors, eigenValues] = eigs(Lmulti, kMax + 1, 'sm');                     

% I would suggest you compute the eigenvectors once and for different subsets
% of the population. Therefore, you could decouple the decomposition step  
% from clustering, which would make experimenting on different clustering 
% algorithms much easier.
if saveOutput
    EigenSet.eigenVectors = eigenVectors;
    EigenSet.eigenValues = eigenValues;
    save(['EigenSet_' hem], 'EigenSet');
end
