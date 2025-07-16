version: "1.0.0"
title: "Create New Recipe"
description: "Create new Spack recipes using PyPackageCreator, official repo, or manual creation"
instructions: |
  You are a Spack recipe creation expert. Create new Spack recipes using the most appropriate
  method based on the package type and availability. The package type will be determined
  from URL analysis. Try PyPackageCreator for Python packages, check official Spack repository,
  and fall back to manual creation if needed.

parameters:
  - key: package_name
    input_type: string
    requirement: required
    description: "Name of the package to create"
  
  - key: package_url
    input_type: string
    requirement: required
    description: "URL to the package repository (used to determine package type)"
  
  - key: recipe_name
    input_type: string
    requirement: required
    description: "The Spack recipe name with prefix"

extensions:
  - type: builtin
    name: developer
    timeout: 300
    bundled: true

prompt: |
  Create a new Spack recipe for {{ package_name }}.
  
  Recipe name: {{ recipe_name }}
  Package URL: {{ package_url }}
  
  First, analyze the package URL to determine the package type, then follow the appropriate creation strategy:
  
  1. **Package Type Detection from URL**:
     - Analyze the URL to determine if it's Python, R, or other
     - Look for domain indicators: pypi.org (Python), cran.r-project.org (R), bioconductor.org (R)
     - For GitHub repositories, analyze repository language, README content, file structure
     - For other URLs, look for language-specific file patterns
  
  2. **For Python Packages** (if detected):
     - First, try PyPackageCreator: `cd ~/r-spack-recipe-builder && ./PyPackageCreator.py -f {{ package_name }}`
     - If successful, copy the generated packages to spack-repo
     - If PyPackageCreator fails, continue to other methods
  
  3. **Check Official Spack Repository**:
     - Check if the package exists in the official Spack repository
     - Use the `create` command to copy existing recipes: `create {{ recipe_name }}`
     - This provides a good base for further modifications
  
  4. **Create from Release URL** (if package_url provided):
     - If the URL points to a release archive, use: `spack create --skip-editor -b {{ package_url }}`
     - This works well for packages with proper releases
  
  5. **Create from Commit SHA** (if no releases):
     - Clone the repository and get commit information
     - Use: `spack create --skip-editor {{ recipe_name }}`
     - Add version with commit hash and date
  
  6. **Manual Creation** (fallback):
     - Create the recipe directory and basic package.py file
     - Add minimal metadata and version information
     - Provide guidance for manual completion
  
  Report the detected package type, creation method used, and any issues encountered.
  Provide the next steps for recipe modification and improvement. 