import numpy as np

# Calculate Euclidean distance between two points
def euclidean_distance(point1, point2):
    return np.sqrt(np.sum((point1 - point2) ** 2))

# Assign each point to the nearest cluster centroid
def assign_to_clusters(X, centroids):
    num_clusters = centroids.shape[0]
    distances = np.zeros((X.shape[0], num_clusters))

    for i in range(num_clusters):
        distances[:, i] = np.linalg.norm(X - centroids[i], axis=1)

    return np.argmin(distances, axis=1)

# Update cluster centroids
def update_centroids(X, clusters, num_clusters):
    centroids = np.zeros((num_clusters, X.shape[1]))

    for i in range(num_clusters):
        cluster_points = X[clusters == i]
        if len(cluster_points) > 0:
            centroids[i] = np.mean(cluster_points, axis=0)

    return centroids

# K-Means clustering algorithm
def kmeans(X, k, max_iters=100):
    n_samples, n_features = X.shape
    centroids = X[np.random.choice(n_samples, k, replace=False)]
    clusters = np.zeros(n_samples)
    
    for _ in range(max_iters):
        prev_clusters = clusters.copy()
        clusters = assign_to_clusters(X, centroids)
        
        if np.array_equal(clusters, prev_clusters):
            break
        
        centroids = update_centroids(X, clusters, k)
    
    return clusters, centroids



## Example
# Sample data
X = np.array([[1, 2], [5, 8], [1, 3], [4, 7], [3, 5]])

# Number of clusters
K = 2

# Initialize centroids randomly
centroids = X[np.random.choice(X.shape[0], K, replace=False)]

# Maximum number of iterations
max_iterations = 100

for _ in range(max_iterations):
    # Assign each point to the nearest centroid
    distances = np.linalg.norm(X[:, np.newaxis, :] - centroids, axis=2)
    labels = np.argmin(distances, axis=1)
    
    # Update centroids
    for k in range(K):
        centroids[k] = np.mean(X[labels == k], axis=0)



