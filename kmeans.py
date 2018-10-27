"""

To run clustering:
* Initialize a kmeans object and then use the run() method.

To get hex values of final cluster centroids:
* call the getClusterColorsAsHex() function on the generated Kmeans object. 

To get the weighted values and colors:
* call the getWeightedColors() function on the generated Kmeans object.

To change the kmeans amount of final clusters:
* in the Kmeans object, set the k=clusterNumber to your specified cluster number.

"""

from PIL import Image
import random
import numpy
from colormap import rgb2hex


class Cluster(object):

    def __init__(self):
        self.pixels = []
        self.centroid = None

    def addPoint(self, pixel):
        """
        Function to add a pixel to the images total pixel array.

        Args:
            pixel: The pixel value to be added.
        Returns: NA
        """
        self.pixels.append(pixel)

    def setNewCentroid(self):
        """
        Function to set the new centroid for a cluster.
        
        Args: NA
        Returns:
            (R, G, B) : The new color for the cluster centroid
        """

        R = [colour[0] for colour in self.pixels]
        G = [colour[1] for colour in self.pixels]
        B = [colour[2] for colour in self.pixels]

        R = sum(R) / len(R)
        G = sum(G) / len(G)
        B = sum(B) / len(B)

        self.centroid = (R, G, B)
        self.pixels = []

        return self.centroid


class Kmeans(object):

    def __init__(self, k=3, max_iterations=5, min_distance=5.0, size=200):
        self.k = k
        self.max_iterations = max_iterations
        self.min_distance = min_distance
        self.size = (size, size)
        self.weights = [None] * k

    def run(self, image):
        """
        Function to create the kmeans clusters for the image.
        
        Args: 
            image: Image object to run kmeans on
        Returns:
            array : The centroids for all of the final clusters in the form (R, G, B)
        """
        self.image = image
        self.image.thumbnail(self.size)
        self.pixels = numpy.array(image.getdata(), dtype=numpy.uint8)

        self.clusters = [None for i in range(self.k)]
        self.oldClusters = None

        randomPixels = random.sample(list(self.pixels), self.k)

        for idx in range(self.k):
            self.clusters[idx] = Cluster()
            self.clusters[idx].centroid = randomPixels[idx]

        iterations = 0

        while self.shouldExit(iterations) is False:

            self.oldClusters = [cluster.centroid for cluster in self.clusters]

            print(iterations)

            for pixel in self.pixels:
                self.assignClusters(pixel)

            for cluster in self.clusters:
                cluster.setNewCentroid()

            iterations += 1

        return [cluster.centroid for cluster in self.clusters]

    def assignClusters(self, pixel):
        """
        Function to assign cluster values by comparing distance between 
        pixel value and current cluster centroid.
        
        Args: 
            pixel : the pixel that is being compared to the current centroid
        Returns: NA
        """
        shortest = float('Inf')
        for cluster in self.clusters:
            distance = self.calcDistance(cluster.centroid, pixel)
            if distance < shortest:
                shortest = distance
                nearest = cluster

        nearest.addPoint(pixel)

    def calcDistance(self, a, b):
        """
        Function that calculates the distance between two pixels
        
        Args: 
            a : first pixel value
            b : second pixel value
        Returns: 
            float : distance between the two pixel values
        """
        result = numpy.sqrt(sum((a - b) ** 2))
        return result

    def shouldExit(self, iterations):
        """
        Function that indicates when clustering has finished and pixels
        have all been accounted for.
        
        Args: 
            iterations : current amount of iterations that clustering has done
        Returns: 
            boolean : True if clustering is done, False otherwise
        """
        if self.oldClusters is None:
            return False

        for idx in range(self.k):
            dist = self.calcDistance(
                numpy.array(self.clusters[idx].centroid),
                numpy.array(self.oldClusters[idx])
            )
            if dist < self.min_distance:
                return True

        if iterations <= self.max_iterations:
            return False

        return True

    def getClusterColorsAsHex(self):
        """
        Function that calculates the hex values of the final cluster centroids
        
        Args: NA
        Returns: 
            array : String values for the hex of the cluster centroids
        """
        totalColors = []
        i = 0
        for cluster in self.clusters:
            centroid = []
            for centr in cluster.centroid:
                centroid.append(int(centr))
            tup = tuple(centroid)
            totalColors.append(rgb2hex(tup[0], tup[1], tup[2]))
            self.weights[i] = (0, tup)
            i = i+1
        print("HEX COLORS: ", totalColors)
        return(totalColors)


    # This function creates the overall occurences for each cluster centroid color
    # after altering the pixels in the image to match their corresponding centroid
    def createWeights(self):
        """
        Function that calculates the total occurences for each cluster centroid
        by comparing a pixel to its associated centroid and aggregating the total
        occurences of each centroid. Modifies the first element of the tuple in the 
        'weights' value of the kMeans object.
        
        Args: NA
        Returns: NA
        """
        localPixels = [None] * len(self.image.getdata())
        for idx, pixel in enumerate(self.pixels):
                shortest = float('Inf')
                for cluster in self.clusters:
                    distance = self.calcDistance(cluster.centroid, pixel)
                    if distance < shortest:
                        shortest = distance
                        nearest = cluster
                        i = 0
                        if(None not in self.weights):
                            for (weight, color) in self.weights:
                                rounded_centroid = ((int)(nearest.centroid[0]), 
                                    (int)(nearest.centroid[1]), (int)(nearest.centroid[2]))
                                if(cmp(rounded_centroid, color) == 0):
                                    self.weights[i] = (weight + 1, color)
                                i = i+1

                localPixels[idx] = nearest.centroid


    # this function creates the tuple array of colors and their corresponding final weights
    def getWeightedColors(self):
        """
        Function that calculates the final weights of each cluster centroid.
        Calls the createWeights() function to aggregate the total occurences of pixels
        and then averages the values to determine percent weight of each centroid.
        
        Args: NA
        Returns: 
            array : tuples for each centroid in the form (weight, color) where color is an (R, G, B) value
        """
        self.getClusterColorsAsHex()
        self.createWeights()
        totalWeight = sum([pair[0] for pair in self.weights])
        i = 0
        for (weight, color) in self.weights:
            adjusted_weight = weight / totalWeight
            self.weights[i] = (adjusted_weight, color)
            i = i + 1
        print('COLOR WEIGHTS: ', self.weights)
        return(self.weights)

def cmp(a, b):
    """
    Function that compares two tuples.
    
    Args: 
        a : first tuple
        b : second tuple
    Returns: 
        integer : -1 if a is less than b, 1 if a is greater than b, 0 if they are the same
    """
    return (a > b) - (a < b) 


def main():
    # Change this to the string of the picture we are going to constantly override from Swift side
    image = Image.open("images/test-flower.jpg")
    k = Kmeans()
    k.run(image)
    k.getClusterColorsAsHex()
    k.getWeightedColors()

if __name__ == "__main__":
    main()
