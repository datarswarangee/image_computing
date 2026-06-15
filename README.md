# CT Reconstruction using System Matrix Approach (MATLAB)

## 🧠 Conceptual Intuition (Simple View)

Think of this like trying to understand what's inside an object (like a fruit) by shining light from different angles.
* Each “ray” tells you partial information.
* All rays together help rebuild the original image.
* The system matrix acts like a **map** connecting rays to pixels.

## 📂 Project Structure

* `Folder_1`: Image preprocessing and resizing
* `Folder_2`: Projection (Radon transform simulation)
* `Folder_3`: System matrix construction
* `Folder_4`: Image reconstruction using matrix methods

## Folder_1: Image Preparation
### Objective
Prepare an input image for reconstruction.

### Method
* Load any grayscale image
* Resize to fixed dimension (e.g., 64×64)

### Key Concept
Reducing image size helps:
* Lower computation cost
* Ensure uniform processing

### Mathematical View
If original image is ( f(x, y) ), resizing creates a discretized version:
[
f \in \mathbb{R}^{N \times N}
]

## Folder_2: Projection Simulation

### Objective
Simulate how rays pass through the image.

### Method
* Use projection angles
* Compute line integrals across image

### Key Concept
Each ray sums pixel values along a line → gives one measurement.

### Mathematical Form
This is equivalent to the **Radon Transform**:
[
p(\theta, t) = \int f(x,y), ds
]
Where:
* ( \theta ): angle
* ( t ): distance from center

## Folder_3: System Matrix Construction

### Objective
Build matrix **A** that models ray–pixel relationships.

### Method
* Each row → one ray
* Each column → one pixel
* Entry = contribution of pixel to ray

### Challenge
Matrix size becomes huge:
[
A \in \mathbb{R}^{(\text{numRays}) \times (\text{numPixels})}
]

Example:

* 92160 × 262144 → ~180 GB ❌ (too large)

### Solution
* Use **sparse matrices**
* Avoid storing full matrix

### Key Idea 

Instead of storing everything:
> Only store where rays actually hit pixels.

## Folder_4: Image Reconstruction

### Objective
Recover original image from projections.

### Equation
[
Ax = b
]

Where:

* ( A ): system matrix
* ( x ): unknown image (flattened)
* ( b ): measured projections

### Methods Used

* Least Squares:
  [
  x = (A^T A)^{-1} A^T b
  ]

* Or iterative solvers (preferred for large systems)

### Practical Fixes Applied

* Avoid full matrix inversion
* Use efficient solvers (e.g., backslash `\`, `lsqr`)

## Issues Encountered & Fixes

### 1. Memory Error

```
Requested array exceeds maximum size
```

✔ Fixed by:

* Using `sparse()` instead of `zeros()`

---

### 2. Undefined Variable `f`

```
Unrecognized function or variable 'f'
```

✔ Fixed by:

* Loading image before resizing:

```matlab
f = imread('image.png');
f = rgb2gray(f);
```

### 3. Slow Execution
✔ Fixed by:
* Reducing image resolution
* Using sparse computations
* Avoiding explicit matrix construction where possible
  
## How to Run
1. Load image
2. Run folder_1(main) → preprocessing
3. Run folder_2(main) → projections
4. Run folder_3(main) → system matrix
5. Run folder_4(main) → reconstruction

## Output
* Original Image
* Projection Data
* Reconstructed Image
  
## Technologies Used
- MATLAB
- Linear Algebra
- Numerical Methods
- Image Processing

## Key Takeaways
* CT reconstruction is fundamentally a **linear algebra problem**
* System matrix approach is powerful but memory intensive
* Sparse methods are essential for scalability
* Reconstruction quality depends on:
  * Number of projections
  * Numerical stability

## Future Improvements

* Use iterative reconstruction (ART, SIRT)
* GPU acceleration
* Noise handling
* Real CT dataset testing


This project is for academic and educational use.
