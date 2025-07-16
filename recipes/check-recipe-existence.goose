version: "1.0.0"
title: "Check Recipe Existence"
description: "Check if a Spack recipe already exists in the spack-repo"
instructions: |
  You are a Spack repository expert. Check if a recipe already exists for the given package
  in the spack-repo. Determine the appropriate recipe name with prefixes and check both
  local and remote repositories for existing recipes. The package type will be determined
  from the URL analysis in the validation step.

parameters:
  - key: package_name
    input_type: string
    requirement: required
    description: "Name of the package to check"
  
  - key: package_url
    input_type: string
    requirement: required
    description: "URL to the package repository (used to determine package type)"

extensions:
  - type: builtin
    name: developer
    timeout: 300
    bundled: true

prompt: |
  Check if a Spack recipe exists for {{ package_name }}.
  
  Package URL: {{ package_url }}
  
  First, analyze the package URL to determine the package type, then perform the checks:
  
  1. **Determine Package Type from URL**:
     - Analyze the URL to determine if it's Python, R, or other
     - Look for domain indicators: pypi.org (Python), cran.r-project.org (R), bioconductor.org (R)
     - For GitHub repositories, analyze the repository content and language indicators
     - For other URLs, look for language-specific file patterns
  
  2. **Determine Recipe Name**:
     - For Python packages: use prefix "py-" (e.g., py-numpy)
     - For R packages: use prefix "r-" (e.g., r-ggplot2)
     - For other packages: use no prefix (e.g., cmake)
  
  3. **Check Local Repository**:
     - Look in the local spack-repo packages directory
     - Check if the recipe directory exists
     - Verify the package.py file is present
  
  4. **Check GitHub Repository**:
     - Use GitHub API to check the wtsi-hgi/spack-repo repository
     - Look for the recipe in the packages directory
     - Handle API rate limits and network issues gracefully
  
  5. **Check Official Spack Repository**:
     - Check if the package exists in the official Spack repository
     - This can be used as a fallback or for copying existing recipes
  
  6. **Provide Status Report**:
     - Report whether the recipe exists (yes/no/manual)
     - Provide the determined recipe name with prefix
     - Include the detected package type
     - Include URLs to existing recipes if found
     - Suggest next steps based on the findings
  
  If the recipe exists, provide details about its location and current state.
  If it doesn't exist, confirm that a new recipe needs to be created. 